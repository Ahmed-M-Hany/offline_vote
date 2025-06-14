import 'package:flutter/material.dart';
import 'package:offline_voting/start_screen.dart';

import 'local_network_service/local_network_service.dart';

void main() {
  runApp(const MyApp());
}

var navigatorKey = GlobalKey<NavigatorState>();
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.orange,
          titleTextStyle: TextStyle(
            color: Colors.orange,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        scaffoldBackgroundColor: Color(0xff3D3D3D),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.orange,
          secondary: Colors.orange,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.black,
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
        cardTheme: const CardThemeData(
          color: Colors.black38,
          shadowColor: Colors.orange,
          surfaceTintColor: Colors.orange,
        ),


        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.orange,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      title: 'Offline Voting',
      home: StartScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _usernameController = TextEditingController();
  //form key
  final _formKey = GlobalKey<FormState>();
  //on page load, request the username via a dialog
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showUsernameDialog();
    });
  }
void _showUsernameDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: const Text('Enter Username'),
            content: Form(
              key: _formKey,
              child: TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(hintText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }else if (value.length <= 3) {
                    return 'Username must be at least 4 characters';
                  }
                  return null;
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Voting'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    startHost();
                  },
                  child: const Text('Listen for Votes'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // a wrap widget with the following children of fibbonacci numbers
            // Fibonacci numbers: 0, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144


          ],
        ),
      ),
    );
  }
}

