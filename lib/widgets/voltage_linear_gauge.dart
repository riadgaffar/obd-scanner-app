import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obdii_scanner/packages/socket_io/cubit/socket_cubit.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class VoltageLinearGauge extends StatelessWidget {
  const VoltageLinearGauge({
    Key? key,
    required this.label,
    required this.actualValue,
    required this.interval,
    required this.min,
    required this.max,
  }) : super(key: key);

  final String label;
  final double actualValue;
  final double interval;
  final double min;
  final double max;

  @override
  Widget build(BuildContext context) {
    const double _minimum = 0;
    const double _maximum = 100;
    final Brightness _brightness = Theme.of(context).brightness;
    final double _batteryPercentage = ((actualValue / max) * 100);

    final Color? _fillColor = _batteryPercentage <= 40
        ? const Color(0xffF45656)
        : _batteryPercentage <= 80
            ? const Color(0xffFFC93E)
            : Colors.green[400];
    return BlocBuilder<SocketCubit, SocketState>(
      builder: (context, state) {
        return Center(
          child: SizedBox(
            width: 165,
            child: SfLinearGauge(
              minimum: _minimum,
              maximum: _maximum,
              showLabels: false,
              showTicks: false,
              tickPosition: LinearElementPosition.cross,
              majorTickStyle:
                  const LinearTickStyle(color: Colors.green, length: 20),
              minorTickStyle:
                  const LinearTickStyle(color: Colors.red, length: 10),
              axisTrackStyle: const LinearAxisTrackStyle(
                  thickness: 1, color: Colors.transparent),
              ranges: <LinearGaugeRange>[
                LinearGaugeRange(
                  startValue: _minimum,
                  startWidth: 70,
                  endWidth: 70,
                  color: Colors.transparent,
                  endValue: _maximum - 2,
                  position: LinearElementPosition.cross,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.rectangle,
                      border: Border.all(
                          color: _brightness == Brightness.light
                              ? const Color(0xffAAAAAA)
                              : const Color(0xff4D4D4D),
                          width: 4),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                  ),
                ),
                LinearGaugeRange(
                  startValue: _minimum + 5,
                  startWidth: 55,
                  endWidth: 55,
                  endValue: _batteryPercentage < _maximum / 4
                      ? _batteryPercentage
                      : _maximum / 4,
                  position: LinearElementPosition.cross,
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: _fillColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                LinearGaugeRange(
                  startValue: _batteryPercentage >= (_maximum / 4 + 2)
                      ? (_maximum / 4 + 2)
                      : _minimum + 5,
                  endValue: _batteryPercentage < (_maximum / 4 + 2)
                      ? _minimum + 5
                      : _batteryPercentage <= _maximum / 2
                          ? _batteryPercentage
                          : _maximum / 2,
                  startWidth: 55,
                  endWidth: 55,
                  position: LinearElementPosition.cross,
                  edgeStyle: LinearEdgeStyle.bothFlat,
                  rangeShapeType: LinearRangeShapeType.flat,
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: _fillColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                LinearGaugeRange(
                  startValue: _batteryPercentage >= (_maximum / 2 + 2)
                      ? (_maximum / 2 + 2)
                      : _minimum + 5,
                  endValue: _batteryPercentage < (_maximum / 2 + 2)
                      ? _minimum + 5
                      : _batteryPercentage <= (_maximum * 3 / 4)
                          ? _batteryPercentage
                          : (_maximum * 3 / 4),
                  startWidth: 55,
                  endWidth: 55,
                  position: LinearElementPosition.cross,
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: _fillColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                LinearGaugeRange(
                  startValue: _batteryPercentage >= (_maximum * 3 / 4 + 2)
                      ? (_maximum * 3 / 4 + 2)
                      : _minimum + 5,
                  endValue: _batteryPercentage < (_maximum * 3 / 4 + 2)
                      ? _minimum + 5
                      : _batteryPercentage < _maximum
                          ? _batteryPercentage
                          : _maximum - 7,
                  startWidth: 55,
                  endWidth: 55,
                  position: LinearElementPosition.cross,
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: _fillColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
              markerPointers: <LinearMarkerPointer>[
                LinearWidgetPointer(
                  value: _maximum,
                  enableAnimation: false,
                  markerAlignment: LinearMarkerAlignment.start,
                  child: Container(
                    height: 38,
                    width: 16,
                    decoration: BoxDecoration(
                      color: _brightness == Brightness.light
                          ? Colors.transparent
                          : const Color(0xff232323),
                      shape: BoxShape.rectangle,
                      border: Border.all(
                          color: _brightness == Brightness.light
                              ? const Color(0xffAAAAAA)
                              : const Color(0xff4D4D4D),
                          width: 4),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(6),
                        bottomRight: Radius.circular(6),
                      ),
                    ),
                  ),
                )
              ],
              barPointers: <LinearBarPointer>[
                LinearBarPointer(
                  value: 100,
                  thickness: 30,
                  position: LinearElementPosition.outside,
                  offset: 35,
                  enableAnimation: false,
                  color: Colors.transparent,
                  child: Center(
                    child: Text(
                      ' '
                      '${actualValue}V : ${_batteryPercentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _fillColor
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
