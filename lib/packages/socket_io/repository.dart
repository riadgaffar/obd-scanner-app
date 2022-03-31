import 'dart:convert';
import 'dart:io';

import 'package:units_converter/units_converter.dart';

import 'model/ip_address.dart';
import 'model/message.dart';
import 'model/socket_config.dart';

class Repository {
  late Message message;
  Socket? _socket;
  SocketConfig _socketConfig = const SocketConfig();

  void initialize() {
    message = const Message();
  }

  void ipAddressChanged(String value) {
    _socketConfig = SocketConfig(ipAddress: IPAddress.dirty(value));
  }

  SocketConfig getSocketConfig() {
    return _socketConfig;
  }

  Future<void> connectWithIpAndPort() async {
    _socket =
        await Socket.connect(_socketConfig.ipAddress.value, _socketConfig.port, timeout: const Duration(seconds: 2));
    print(
        'Connected to: ${_socket!.remoteAddress.address}:${_socket!.remotePort}');
    _socket!.listen(
      (List<int> event) async {
        String receivedMessage =
            utf8.decode(event).replaceAll(RegExp('[^A-Za-z0-9.]'), '');
        if (!(receivedMessage.contains('AT') ||
            receivedMessage.contains('ELM') || 
            receivedMessage.contains('STOPPED'))) {
          _parsePayload(receivedMessage);
        }
      },
      // handle errors
      onError: (error) {
        print(error);
        _socket!.destroy();
      },
      // handle server ending connection
      onDone: () {
        print('Server left.');
        _socket!.destroy();
        initialize();
      },
    );
  }

  Future<void> sendMessage(dynamic message) async {
    _socket!.write(message);
  }

  Future<void> disConnect() async {
    _socket!.close();
  }

  void _parsePayload(String payload) {
    if (payload.isEmpty) return;
    if (payload.length <= 5 && RegExp(r'^.*?\.\d+?V$').hasMatch(payload)) {
      /// voltage
      var _distiledPayload = payload.replaceAll(RegExp(r'ATRV'), '');
      if (_distiledPayload.isNotEmpty) {
        message = message.copyWith(voltage: _distiledPayload);
      }
    } else if (payload.length > 4 && payload.substring(payload.length - 6).contains('410D')) {
      /// speed PID 0D
      String rawL2c = payload
          .substring(payload.length - 2); //.replaceAll(RegExp(r'0D'), '');      
      if (rawL2c.isNotEmpty) {
        message = message.copyWith(speed: rawL2c.toMiles()!);
      }
    } else if (payload.length > 4 && payload.substring(payload.length - 8).contains('410C')) {
      /// rpm PID 0C
      String rawL4c =
          payload.substring(payload.length - 4).replaceAll(RegExp(r'410C'), '');
      if (rawL4c.isNotEmpty) {
        message = message.copyWith(rpm: rawL4c.toRPM());
      }
    } else if (payload.length > 4 && payload.substring(payload.length - 6).contains('4104')) {
      // Engine Load PID 04
      String rawL2c =
          payload.substring(payload.length - 2).replaceAll(RegExp(r'4104'), '');
      if (rawL2c.isNotEmpty) {
        message = message.copyWith(engineLoad: rawL2c.toPercentage());
      }
    } else if (payload.length > 4 && payload.substring(payload.length - 6).contains('4105')) {
      // temparature PID 05
      String rawL2c =
          payload.substring(payload.length - 2).replaceAll(RegExp(r'4105'), '');
      if (rawL2c.isNotEmpty) {
        message = message.copyWith(temparature: rawL2c.toTemperature());
      }
    } else if (payload.length > 4 && payload.substring(payload.length - 6).contains('412F')) {
      // Fuel Level PID 2F
      String rawL2c =
          payload.substring(payload.length - 2).replaceAll(RegExp(r'412F'), '');
      if (rawL2c.isNotEmpty) {
        message = message.copyWith(fuelLevel: rawL2c.toPercentage());
      }
    }
  }
}

extension on String {
  double? toMiles() {
    var km = int.tryParse(this, radix: 16)!.toDouble();
    var miles = (km * 0.621371);
    return miles.roundToDouble();
  }

  double toRPM() => (int.parse(this, radix: 16) / 4);

  double toTemperature() => (int.parse(this, radix: 16) - 40);

  double toPercentage() => ((int.parse(this, radix: 16) / 255) * 100);
}
