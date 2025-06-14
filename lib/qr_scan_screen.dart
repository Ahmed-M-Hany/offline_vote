
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:offline_voting/joiner_screen.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  MobileScannerController controller = MobileScannerController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (barcodes) {
          controller.stop();
          String result = barcodes.barcodes.first.rawValue ?? '';
          print('Barcode detected: ${barcodes.barcodes.first.rawValue}');
          Navigator.of(context).pop(); // Close the scanner screen
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => JoinerScreen(ipAndPort: result,),)
          );
        },
      ),
    );
  }
  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
