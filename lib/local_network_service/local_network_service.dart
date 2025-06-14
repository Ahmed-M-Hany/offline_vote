
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../main.dart';



Future<RawDatagramSocket> startHost() async {
  const int port = 54321;
  final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
  final ip = await _getLocalIpAddress();

  print('🟢 Host started. IP: $ip, Port: $port');

  return socket;

}

Future<String> _getLocalIpAddress() async {
  final interfaces = await NetworkInterface.list(
    type: InternetAddressType.IPv4,
    includeLoopback: false,
  );

  for (final interface in interfaces) {
    for (final addr in interface.addresses) {
      if (!addr.isLoopback) {
        return addr.address;
      }
    }
  }

  return 'Unknown';
}



Future<void> sendMessageToHost(String hostIp,int port, String message,String username) async {
  final sender = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);

  final data = utf8.encode("$message 9971 $username");
  sender.send(data, InternetAddress(hostIp), port);

  ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
    SnackBar(content: Text('Estimation sent ✅'),duration: Duration(seconds: 1),),
  );


  print('🟢 Sent "$message" to $hostIp:$port');
  sender.close();
}

