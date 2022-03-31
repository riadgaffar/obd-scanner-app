part of 'socket_cubit.dart';

enum ConnectionStatus { disconnected, connecting, connected, connectionFailed }

class SocketState extends Equatable {
  
  const SocketState._({
    this.connectionStatus = ConnectionStatus.disconnected,
    required this.message
  });

  const SocketState.disconnected() : this._(message: const Message());

  const SocketState.connecting()
      : this._(connectionStatus: ConnectionStatus.connecting, message: const Message());

  const SocketState.connectionFailed()
      : this._(connectionStatus: ConnectionStatus.connectionFailed, message: const Message());

  const SocketState.connected(Message socketMessage)
      : this._(connectionStatus: ConnectionStatus.connected, message: socketMessage);

  final ConnectionStatus connectionStatus;
  final Message message;
  
  @override
  List<Object?> get props => [connectionStatus, message];
}
