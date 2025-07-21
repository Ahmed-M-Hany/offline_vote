// a stateless screen with two button "create host" and "join host"

import 'package:flutter/material.dart';

import 'package:offline_voting/features/host/presentation/view/host_screen.dart';
import 'package:offline_voting/features/joiner/presentation/view/qr_scan_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Voting'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => HostScreen(),));
              },
              child: const Text('Create Host'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Navigate to QR scan screen
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => QrScanScreen(),));
              },
              child: const Text('Join Host'),
            ),
          ],
        ),
      ),
    );
  }
}
