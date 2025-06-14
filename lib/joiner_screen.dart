
import 'package:flutter/material.dart';
import 'package:offline_voting/choosen_number_screen.dart';
import 'package:offline_voting/local_network_service/local_network_service.dart';

class JoinerScreen extends StatelessWidget {
  const JoinerScreen({super.key, required this.ipAndPort});
  final String ipAndPort;
  final points = const [0, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144];


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
                        sendMessageToHost(ipAndPort.split(" ").first,int.parse(ipAndPort.split(" ").last), points[index].toString());
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
