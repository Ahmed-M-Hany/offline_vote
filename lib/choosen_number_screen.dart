

import 'package:flutter/material.dart';

class ChoosenNumberScreen extends StatelessWidget {
  const ChoosenNumberScreen(this.point,{super.key});
  final int point;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: 'point_$point',
            child: Card(
              color: Colors.orange,

              child: InkWell(
                onTap: () {
                  // Handle the tap event
                },
                child: Center(
                  child: Text(
                    point.toString(),
                    style: const TextStyle(fontSize: 128),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
