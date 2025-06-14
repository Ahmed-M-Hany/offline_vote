
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:barcode/barcode.dart';
import 'package:flutter_svg/svg.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'local_network_service/local_network_service.dart' as LocNetworkService;
import 'main.dart';

class HostScreen extends StatefulWidget {
  const HostScreen({super.key});

  @override
  State<HostScreen> createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {
  RawDatagramSocket? socket;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //back button
        title: const Text('Host Screen'),
      ),
      body: FutureBuilder<RawDatagramSocket>(
          future: LocNetworkService.startHost(),
          builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError|| snapshot.data == null) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            socket = snapshot.data;
            return Column(
              children: [
                SizedBox(height: 8,),
                IconButton(onPressed: (){
                  _showIpAndPortQrDialog();
                }, icon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person_add_alt_1, color: Colors.white,),
                    const SizedBox(width: 10),
                    //add person text
                    const Text('Add', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                )),
                Expanded(child: RealTimeVotesList(snapshot.data!)),
              ],
            );
          }
          },
      ),
    );
  }
  _showIpAndPortQrDialog()async{
    var qr =Barcode.qrCode();
    final info = NetworkInfo();
    final ip = await info.getWifiIP();
    String ipAndPort = '${ip} ${54321}';
    var qrData = qr.toSvg(ipAndPort, width: 200, height: 200);
    Uint8List qrBytes = utf8.encode(qrData);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:  Text('Host IP and Port: $ipAndPort'),
          content: SvgPicture.memory(
            qrBytes,
            width: 200,
            height: 200,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}


class RealTimeVotesList extends StatefulWidget {
  const RealTimeVotesList( this.socket,{super.key});
  final RawDatagramSocket socket;

  @override
  State<RealTimeVotesList> createState() => _RealTimeVotesListState();
}

class _RealTimeVotesListState extends State<RealTimeVotesList> {
  List<String> votes = [];
  @override
  void initState() {
    widget.socket.listen((event) {
      if (event == RawSocketEvent.read) {
        final datagram = widget.socket.receive();
        if (datagram != null) {
          final message = utf8.decode(datagram.data);
          votes.add(message);
          setState(() {});
          print('🔵 Received from ${datagram.address.address}: $message');
        }
      }
    }
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: votes.length, // Placeholder for real-time votes
      itemBuilder: (context, index) {
        return ListTile(
          title: const Text('Real-time Votes', style: TextStyle(color: Colors.white)),
          subtitle:  Text(votes[index].toString(),style: TextStyle(color: Colors.white,fontSize: 16),),
        );
      },
    );
  }
  @override
  dispose() {
    widget.socket.close();
    super.dispose();
  }
}

