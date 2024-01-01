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

  Future<void> refreshInstrumentCluster() async {
    await _getRpm();
    await _getSpeed();
    await _getFuelLevel();
    await _getEngineLoad();
    await _getVoltage();
    await _getCoolantTemp();
  }

  Future<void> disConnect() async {
    await repository.disConnect();
    emit(const SocketState.disconnected());
  }

  Future<void> _resetScanner() async {
    await _autoDetectProtocol();
    await _doSoftReset();
    await _turnHeaderOff();
    await _turnHeaderOn();
    await _describeProtocolInNumber();
  }

  Future<void> _autoDetectProtocol() async {
    await repository.sendCommand(OBDAutoProtocolDetectionCommand());
    await _waitMs(200);
    emit(SocketState.connected(repository.message));
  }

  Future<void> _doSoftReset() async {
    await repository.sendCommand(OBDSoftRestCommand());
    await _waitMs(200);
    emit(SocketState.connected(repository.message));
  }

  Future<void> _turnHeaderOff() async {
    await repository.sendCommand(OBDDisplayHeaderOffCommand());
    await _waitMs(200);
    emit(SocketState.connected(repository.message));
  }

  Future<void> _turnHeaderOn() async {
    await repository.sendCommand(OBDDisplayHeaderOnCommand());
    await _waitMs(200);
    emit(SocketState.connected(repository.message));
  }

  Future<void> _describeProtocolInNumber() async {
    await repository.sendCommand(OBDDescribeProtocolInNumberCommand());
    await _waitMs(200);
    emit(SocketState.connected(repository.message));
  }

  Future<void> _getDtcs() async {
    await repository.sendCommand(OBDDiagnosticTroubleCodesCommand());
    await _waitMs(50);
    emit(SocketState.connected(repository.message));
  }

  Future<void> _getRpm() async {
    await repository.sendCommand(OBDDiagnosticEngineRpmCommand());
    await _waitMs(50);
    emit(SocketState.connected(repository.message));
  }

  Future<void> _getSpeed() async {
    await repository.sendCommand(OBDDiagnosticVehicleSpeedCommand());
    await _waitMs(50);
    emit(SocketState.connected(repository.message));
  }

  Future<void> _getFuelLevel() async {
    await repository.sendCommand(OBDDiagnosticFuelLevelCommand());
    await _waitMs(50);
    emit(SocketState.connected(repository.message));
  }

  Future<void> _getEngineLoad() async {
    await repository.sendCommand(OBDDiagnosticEngineLoadCommand());
    await _waitMs(50);
    emit(SocketState.connected(repository.message));
  }

  Future<void> _getVoltage() async {
    await repository.sendCommand(OBDDiagnosticVoltageCommand());
    await _waitMs(50);
    emit(SocketState.connected(repository.message));
  }

  Future<void> _getCoolantTemp() async {
    await repository.sendCommand(OBDDiagnosticCoolantTempCommand());
    await _waitMs(50);
    emit(SocketState.connected(repository.message));
  }

  Future<dynamic> _waitMs(int ms) async => await Future.delayed(Duration(milliseconds: ms));
}

