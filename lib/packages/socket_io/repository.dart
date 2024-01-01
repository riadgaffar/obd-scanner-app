import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:obdii_scanner/packages/socket_io/model/obd_commands.dart';
import 'package:obdii_scanner/packages/socket_io/utils/payload_parser.dart';

import 'model/ip_address.dart';
import 'model/message.dart';
import 'model/socket_config.dart';
import 'utils/constants.dart' as constants;


class Repository {  
  late Message message;
  Socket? _socket;
  SocketConfig _socketConfig = const SocketConfig();
  PayloadParser payloadParser = PayloadParser();

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
        await Socket.connect(_socketConfig.ipAddress.value, _socketConfig.port, timeout: const Duration(seconds: constants.Wait.threeSec));    
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
        _socket!.destroy();
      },
      // handle server ending connection
      onDone: () {
        _socket!.destroy();
        initialize();
      },
    );
  }

  Future<void> sendCommand(OBDCommand command) async {
    final commandString = command.commandString;
    _socket!.write(commandString);
  }

  Future<void> disConnect() async {
    _socket!.close();
  }

  void _parsePayload(String payload) {
    if (payload.isEmpty || payload == "OK") return;
    message = payloadParser.parsePayload(message, payload);
  }
}
