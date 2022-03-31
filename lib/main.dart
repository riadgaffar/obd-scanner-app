import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obdii_scanner/app.dart';
import 'package:obdii_scanner/packages/socket_io/repository.dart';
import 'package:flutter/services.dart';

import 'simple_bloc_observer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => BlocOverrides.runZoned(
      () => runApp(App(repository: Repository())),
      blocObserver: SimpleBlocObserver(),
    ),
  );
}
