import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';

class SimpleSocketManager with ChangeNotifier {
  late final socket;

  bool connected = false;
  bool get isConnected {
    return connected;
  }

  String receiveMessage = "";
  String get receivedMessage => receiveMessage;
  set receivedMessage(String message) {
    if (message.isNotEmpty) {
      receiveMessage = message;
      notifyListeners();
    }
  }
  
  Future<void> connect(String ipAddress, int port) async {
    socket = await Socket.connect(ipAddress, port);

    print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

    socket.listen(
      // handle data from the server
      (List<int> event) async {
        String parsedMessage = utf8.decode(event).replaceAll(RegExp('[^A-Za-z0-9.]'), '');
        if (parsedMessage.length >= 4) {
          receivedMessage = utf8.decode(event).replaceAll(RegExp('[^A-Za-z0-9.]'), '');
        }
        print("Socket parsedMessage: $parsedMessage");
        print("Socket receivedMessage: $receivedMessage");
      },
      // handle errors
      onError: (error) {
        connected = false;
        print(error);
        socket.destroy();
      },
      // handle server ending connection
      onDone: () {
        connected = false;
        print('Server left.');
        socket.destroy();
      },
    );
    connected = true;
  }

  Future<void> sendMessage(dynamic message) async {
    if (connected) {
      socket.write(message);
      // socket.flush();
      //await Future.delayed(const Duration(milliseconds: 200));
      // await Future.delayed(const Duration(seconds: 1));
    }
  }

  Future<void> disConnect() async {
    socket.close();
    connected = false;
  }

  Future<void> getSpeed() async {
    await sendMessage("010D\r");
  }

  Future<void> getRPM() async {
    await sendMessage("010C\r");
  }

  Future<void> getVolt() async {
    await sendMessage("ATRV\r");
  }

  Future<void> getCoolantTemp() async {
    await sendMessage("0105\r");
  }
}
