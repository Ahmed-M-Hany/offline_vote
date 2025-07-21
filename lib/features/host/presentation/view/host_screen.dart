import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:barcode/barcode.dart';
import 'package:flutter_svg/svg.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:offline_voting/data/models/vote_model.dart';
import 'package:offline_voting/data/repositories/votes_repository.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:offline_voting/core/services/local_network_service.dart' as LocNetworkService;

class HostScreen extends StatefulWidget {
  const HostScreen({super.key});

  @override
  State<HostScreen> createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {
  RawDatagramSocket? socket;
  List<String> constVotes = ["0", "1", "2", "3", "5", "8", "13", "21", "34", "55", "89", "144"];
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
                SizedBox(
                  height: 82,
                  child: Row(
                    children: [
                      Expanded(child: SizedBox(height: 80, child: RealTimeVotesList(snapshot.data!))),
                    ],
                  ),
                ),
                const SizedBox(height: 8,),
                ValueListenableBuilder<List<VoteModel>>(
                  valueListenable: recievedVotes,
                  builder: (BuildContext context, List<VoteModel> value, Widget? child) {
                    return SfCircularChart(
                      series: [
                        //for each vote, count how many times it appears in the recievedVotes list
                        PieSeries<String, String>(
                          dataLabelMapper: (datum, index) {
                            var y =value.where((v) => v.vote == datum).length;
                            return y!=0?datum:null;

                          },
                          dataLabelSettings: const DataLabelSettings(isVisible: true, labelPosition: ChartDataLabelPosition.outside,color: Colors.white),
                          dataSource: constVotes,
                          xValueMapper: (String vote, _) {

                            return vote;
                          },
                          yValueMapper: (String vote, _) => value.where((v) => v.vote == vote).length,
                          pointColorMapper: (String vote, _) {
                            switch (vote) {
                              case "0":
                                return Colors.red;
                              case "1":
                                return Colors.orange;
                              case "2":
                                return Colors.yellow;
                              case "3":
                                return Colors.green;
                              case "5":
                                return Colors.blue;
                              case "8":
                                return Colors.indigo;
                              case "13":
                                return Colors.purple;
                              case "21":
                                return Colors.pink;
                              case "34":
                                return Colors.brown;
                              case "55":
                                return Colors.grey;
                              case "89":
                                return Colors.cyan;
                              case "144":
                                return Colors.teal;
                              default:
                                return Colors.white;
                            }
                          },
                        ),
                      ],

                    );
                  },
                )
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
          title:  Text('Host IP and Port: $ipAndPort',style: TextStyle(color: Colors.black),),
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

  @override
  void initState() {
    widget.socket.listen((event) {
      if (event == RawSocketEvent.read) {
        final datagram = widget.socket.receive();
        if (datagram != null) {
          final message = utf8.decode(datagram.data);
          final parts = message.trim().split(' 9971 ');
          VoteModel vote = VoteModel(
              vote: parts.first,
              username: parts.last,
              address: datagram.address.address);
          //check if the address is already in the list
          //if the address and username already exists, modify the existing vote
          final existingVoteIndex = recievedVotes.value.indexWhere(
              (v) => (v as VoteModel).username == vote.username);

          setState(() {
            if (existingVoteIndex != -1) {
              recievedVotes.value[existingVoteIndex] = vote;
            } else {
              recievedVotes.value.add(vote);
            }
            recievedVotes.notifyListeners();
          });
          print('🔵 Received from ${datagram.address.address}: $message');
        }
      }
    }
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: recievedVotes,
      builder: (context, value, child) {
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          scrollDirection: Axis.horizontal,
          itemCount: recievedVotes.value.length, // Placeholder for real-time votes
          separatorBuilder: (context, index) => const SizedBox(width: 12,),
          itemBuilder: (context, index) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 50,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(recievedVotes.value[index].username, style: TextStyle(color: Colors.white,),maxLines: 1,),
                  Text(recievedVotes.value[index].vote.toString(),style: TextStyle(color: Colors.white,fontSize: 16),),
                ],

              ),
            );
          },
        );
      }
    );
  }
  @override
  dispose() {
    widget.socket.close();
    super.dispose();
  }
}

