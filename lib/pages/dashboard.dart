import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:obdii_scanner/packages/icons/custom_icons_icons.dart';
import 'package:obdii_scanner/packages/socket_io/cubit/socket_cubit.dart';
import 'package:obdii_scanner/packages/socket_io/widgets/dialogs/dialogs.dart';
import 'package:obdii_scanner/widgets/dynamic_radial_gauge.dart';
import 'package:obdii_scanner/widgets/percentage_gauge.dart';
import 'package:obdii_scanner/widgets/temperature_linear_gauge.dart';
import 'package:obdii_scanner/widgets/voltage_linear_gauge.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _timersStarted = false;
    late Timer _executionTimer;

    void _startScanTimer(int milliseconds) {
      _executionTimer = Timer.periodic(
        Duration(milliseconds: milliseconds),
        (timer) async {
          await context.read<SocketCubit>().refreshInstrumentCluster();
        },
      );
      _timersStarted = true;
    }

    void _stopScanTimer() {
      if (_timersStarted) {
        _executionTimer.cancel();
        _timersStarted = false;
      }
    }

    MaterialColor _getColor(double startValue, double endValue, double max) {
      double greenValue = max * 0.25; // 25%
      double orageValue = max * 0.75; // 75%
      MaterialColor color = Colors.red; // 100%

      if (startValue < greenValue) {
        color = Colors.green;
      } else if (endValue > greenValue && endValue < orageValue) {
        color = Colors.orange;
      }

      return color;
    }

    List<GaugeRange> _createGaugeRange(double min, double max) {
      double start = 0, increment = max < 1000 ? 50 : 500;
      dynamic ranges = max / increment;
      List<GaugeRange> gaugeRange = [];

      for (int gr = 0; gr < ranges; gr++) {
        double endVal = start < increment ? increment : start + increment;
        gaugeRange.add(
          GaugeRange(
              startValue: start,
              endValue: endVal,
              color: _getColor(start, endVal, max),
              startWidth: 3,
              endWidth: 3),
        );
        start += increment;
      }

      return gaugeRange;
    }

    Widget _getActionableButton(
        {required String label, required IconData iconData}) {
      return GFButton(
        onPressed: () {},
        icon: Icon(iconData, size: 46),
        buttonBoxShadow: false,
        text: label,
        size: GFSize.SMALL,
        type: GFButtonType.transparent,
        shape: GFButtonShape.pills,
      );
    }

    return BlocBuilder<SocketCubit, SocketState>(
      builder: (context, state) {
        Icon connectionIcon =
            state.connectionStatus == ConnectionStatus.connected
                ? const Icon(Icons.wifi_tethering, color: Colors.blueAccent)
                : const Icon(Icons.portable_wifi_off, color: Colors.blueGrey);
        if (state.connectionStatus == ConnectionStatus.connectionFailed) {
          Future.delayed(Duration.zero, () {
            showDialog(
                context: context,
                builder: (BuildContext context) => const ErrorDialog());
          });
        }
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(40.0),
            child: AppBar(
              leading: connectionIcon,
              backgroundColor: Colors.black87,
              // backgroundColor: Colors.red.withOpacity(0), // transprent
              elevation: 0.0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.blueAccent),
                  onPressed: () {
                    final socketCubit = context.read<SocketCubit>();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return BlocProvider<SocketCubit>.value(
                          value: socketCubit,
                          child: SettingsDialog(
                            startTimerHandler: _startScanTimer,
                            stopTimerHandler: _stopScanTimer,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: GridView(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  children: [
                    DynamicRadialGauge(
                      label: 'MPH',
                      actualValue: state.message.speed,
                      interval: 20,
                      min: 0,
                      max: 200,
                      createGaugeRange: _createGaugeRange,
                    ),
                    DynamicRadialGauge(
                      label: 'RPM',
                      actualValue: state.message.rpm,
                      interval: 1000,
                      min: 0,
                      max: 9000,
                      createGaugeRange: _createGaugeRange,
                    ),
                    PercentageGauge(
                      label: 'FUEL LEVEL',
                      actualValue: state.message.fuelLevel,
                      interval: 20,
                      min: 0,
                      max: 100.0,
                    ),
                    PercentageGauge(
                      label: 'ENGINE LOAD',
                      actualValue: state.message.engineLoad,
                      interval: 20,
                      min: 0,
                      max: 100.0,
                    ),
                    RotatedBox(
                      quarterTurns: 3,
                      child: VoltageLinearGauge(
                          label: 'VOLT',
                          actualValue: double.parse(state.message.voltage
                              .substring(0, state.message.voltage.length - 1)),
                          interval: 10,
                          min: 0,
                          max: 14.9,),
                    ),
                    TemperatureLinearGauge(
                      label: 'TEMP',
                      actualValue: state.message.temperature,
                      interval: 40,
                      min: -20,
                      max: 180.0,
                    ),
                    _getActionableButton(
                        label: 'DTC', iconData: CustomIcons.check_engine),
                    _getActionableButton(
                        label: 'Sensors', iconData: Icons.sensors),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
