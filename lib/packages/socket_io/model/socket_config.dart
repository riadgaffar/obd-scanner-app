import 'package:equatable/equatable.dart';
import 'ip_address.dart';

class SocketConfig extends Equatable {
  final IPAddress ipAddress;
  final int port = 35000;

  const SocketConfig({
    this.ipAddress = const IPAddress.pure(),     
  });

  @override
  List<Object?> get props => [ipAddress, port];
}