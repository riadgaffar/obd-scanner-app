import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obdii_scanner/packages/socket_io/cubit/socket_cubit.dart';
import 'package:obdii_scanner/packages/socket_io/repository.dart';
import 'pages/dashboard.dart';

class App extends StatelessWidget {
  const App({Key? key, required Repository repository}) 
  : super(key: key);
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => App(repository: Repository(),));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Socket Test",      
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: BlocProvider(
          create: (_) => SocketCubit(
            repository: Repository()
          )..initialize(),
          child: const Dashboard(),
        ),
      ),
      // theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
      // theme: ThemeData(primaryColor: Colors.lightGreen),
    );
  }
}
