


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obdii_scanner/packages/socket_io/cubit/socket_cubit.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({
    Key? key,
    required this.startTimerHandler,
    required this.stopTimerHandler,
  }) : super(key: key);
  final Function startTimerHandler;
  final Function stopTimerHandler;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SocketCubit, SocketState>(
      builder: (context, state) {
        TextEditingController ipEntryController = TextEditingController()
          ..text = context.read<SocketCubit>().ipAddress();
        return AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.settings, color: Colors.blueAccent),
              Padding(
                padding: EdgeInsets.only(left: 15),
              ),
              Text('Connection Settings'),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Column(
                  children: [
                    Container(
                        child: (() {
                      if (state.connectionStatus ==
                          ConnectionStatus.connecting) {
                        return const CircularProgressIndicator();
                      }
                    }())),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 0, right: 0),
                      child: Row(
                        children: <Widget>[
                          const Text(
                            "Host:",
                            style: TextStyle(
                                color: Colors.lightBlueAccent,
                                fontWeight: FontWeight.w600),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 2),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.redAccent, width: 1.0)),
                            ),
                            child: SizedBox(
                              width: 115,
                              child: TextField(
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14),
                                controller: ipEntryController,
                                onChanged: (ip) =>
                                    context.read<SocketCubit>().ipChanged(ip),
                                decoration: const InputDecoration(
                                  hintText: 'ip address',
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                          ),
                          const Text(
                            "Port:",
                            style: TextStyle(
                              color: Colors.lightBlueAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.redAccent, width: 1.0)),
                            ),
                            child: Text(
                              context
                                  .read<SocketCubit>()
                                  .portNumber()
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await context.read<SocketCubit>().connectWithIpAndPort();
                if (context.read<SocketCubit>().state.connectionStatus ==
                    ConnectionStatus.connected) {
                  startTimerHandler(200);
                }
                Navigator.pop(context, 'Connect');
              },
              child: const Text('Connect'),
            ),
            TextButton(
              onPressed: () async {
                if (context.read<SocketCubit>().state.connectionStatus ==
                    ConnectionStatus.connected) {
                  stopTimerHandler();
                  await Future<void>.delayed(const Duration(milliseconds: 200));
                  await context.read<SocketCubit>().disConnect();
                }
                Navigator.pop(context, 'Disconnect');
              },
              child: const Text('Disconnect'),
            ),
          ],
        );
      },
    );
  }
}
