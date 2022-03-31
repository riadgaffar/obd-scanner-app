import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../model/message.dart';
import '../model/obd_commands.dart';
import '../repository.dart';

part 'socket_state.dart';

class SocketCubit extends Cubit<SocketState> {
  SocketCubit({required this.repository}) : super(const SocketState.disconnected());

  final Repository repository;

  void initialize() {
    repository.initialize();
  }

  void ipChanged(String value) {
    repository.ipAddressChanged(value);    
  }

  int portNumber() {
    return repository.getSocketConfig().port;
  }

  String ipAddress() {
    return repository.getSocketConfig().ipAddress.value;    
  }

  Future<void> connectWithIpAndPort() async {    
    try {
      emit(const SocketState.connecting());
      await repository.connectWithIpAndPort();
      await _resetScanner();
      emit(SocketState.connected(repository.message));
    } on Exception {
      emit(const SocketState.connectionFailed());
    }
  }

  Future<void> sendMessage(dynamic message) async {    
    await repository.sendMessage(message);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    emit(SocketState.connected(repository.message));
  }

  Future<void> sendSensorCommads() async {
    for (var cmd in sensorCommands) {
      await repository.sendMessage(cmd + '\r');      
      await Future.delayed(const Duration(milliseconds: 50));
      emit(SocketState.connected(repository.message));
    }
  }

  Future<void> disConnect() async {
    await repository.disConnect();
    emit(const SocketState.disconnected());
  }

  Future<void> _resetScanner() async {
    for (var cmd in resetScanToolCommands) {
      await repository.sendMessage(cmd + '\r');      
      await Future.delayed(const Duration(milliseconds: 200));      
    }
  }
}

