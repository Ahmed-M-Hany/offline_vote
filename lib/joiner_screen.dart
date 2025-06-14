
import 'package:flutter/material.dart';
import 'package:offline_voting/choosen_number_screen.dart';
import 'package:offline_voting/local_network_service/local_network_service.dart';

class JoinerScreen extends StatefulWidget {
  const JoinerScreen({super.key, required this.ipAndPort});
  final String ipAndPort;

  @override
  State<JoinerScreen> createState() => _JoinerScreenState();
}

class _JoinerScreenState extends State<JoinerScreen> {
  final points = const [0, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144];
  //form key
  final _formKey = GlobalKey<FormState>();
  String _username="";
  //open "please enter your username" dialog
  initState() {
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
            content: Form(
              key: _formKey,
              child: TextFormField(
                decoration:  InputDecoration(hintText: 'Username',hintStyle: TextStyle(color: Colors.grey)),
                validator: (value) {
                  _username = value ?? "";
                  if(value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  if (value.length < 3) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Username must be at least 4 characters ❌')),
                    );
                  }
                  return null;
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid username ❌')),
                    );
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
      // title: Story point estimate?
      appBar: AppBar(
        title: const Text('Story point estimate'),
      ),
      // a GridView widget with with cross axis children 4 cards inside it with text: 0, 1,2, 3, 5, 8, 13, 21, 34, 55, 89, 144
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              crossAxisCount: 4,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 1.0/1.3,
              children: List.generate(12, (index) {

                return Hero(
                  tag: 'point_${points[index]}',
                  child: Card(
                    color: Colors.orange,

                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChoosenNumberScreen(points[index]),));
                        sendMessageToHost(widget.ipAndPort.split(" ").first,int.parse(widget.ipAndPort.split(" ").last), points[index].toString(),_username);
                      },
                      child: Center(
                        child: Text(
                          points[index].toString(),
                          style: const TextStyle(fontSize: 26),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      )
    );
  }
}
