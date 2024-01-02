import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obdii_scanner/packages/socket_io/cubit/socket_cubit.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TemperatureLinearGauge extends StatelessWidget {
  const TemperatureLinearGauge({
    super.key,
    required this.label,
    required this.actualValue,
    required this.interval,
    required this.min,
    required this.max,
  });

  final String label;
  final double actualValue;
  final double interval;
  final double min;
  final double max;

  @override
  Widget build(BuildContext context) {
    const double maxNormalTemperature = 100.0;
    final Brightness brightness = Theme.of(context).brightness;
    final Color tempTextColor = brightness == Brightness.dark
                                    ? Colors.white70
                                    : Colors.black26;
    return BlocBuilder<SocketCubit, SocketState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: Center(
                child: SizedBox(
                  // height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 1, top: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          /// Linear gauge to display celsius scale.
                          SfLinearGauge(
                            axisLabelStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: brightness == Brightness.dark
                                    ? Colors.white70
                                    : Colors.black26,
                            ),
                            minimum: min,
                            maximum: max,
                            interval: interval,
                            minorTicksPerInterval: 5,
                            axisTrackExtent: 20,
                            axisTrackStyle: const LinearAxisTrackStyle(
                              thickness: 12,
                              color: Colors.white,
                              borderWidth: 1,
                              edgeStyle: LinearEdgeStyle.bothCurve,
                            ),
                            tickPosition: LinearElementPosition.outside,
                            labelPosition: LinearLabelPosition.outside,
                            orientation: LinearGaugeOrientation.vertical,
                            markerPointers: <LinearMarkerPointer>[
                              LinearWidgetPointer(                                
                                markerAlignment: LinearMarkerAlignment.end,
                                value: max, // celcius,
                                enableAnimation: false,
                                position: LinearElementPosition.outside,
                                offset: 8,
                                child: const SizedBox(
                                  height: 28,
                                  child: Text(
                                    '°C',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                              LinearShapePointer( // bottom circle
                                value: min,
                                markerAlignment: LinearMarkerAlignment.start,
                                shapeType: LinearShapePointerType.circle,
                                borderWidth: 1,
                                borderColor: brightness == Brightness.dark
                                    ? Colors.white70
                                    : Colors.black26,
                                color: Colors.white,
                                position: LinearElementPosition.cross,
                                width: 24,
                                height: 24,
                              ),
                              LinearShapePointer(
                                value: min,
                                markerAlignment: LinearMarkerAlignment.start,
                                shapeType: LinearShapePointerType.circle,
                                borderWidth: 6,
                                borderColor: Colors.transparent,
                                color: actualValue > maxNormalTemperature
                                    ? const Color(0xffFF7B7B)
                                    : const Color(0xff0074E3),
                                position: LinearElementPosition.cross,
                                width: 24,
                                height: 24,
                              ),
                              LinearWidgetPointer(
                                value: min,
                                markerAlignment: LinearMarkerAlignment.start,
                                child: Container(
                                  width: 10,
                                  height: 3.4,
                                  decoration: BoxDecoration(
                                    border: const Border(
                                      left: BorderSide(
                                        width: 2.0,
                                        color: Colors.white,
                                      ),
                                      right: BorderSide(
                                        width: 2.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    color: actualValue >
                                            maxNormalTemperature // celcius
                                        ? const Color(0xffFF7B7B)
                                        : const Color(0xff0074E3),
                                  ),
                                ),
                              ),
                              LinearWidgetPointer(
                                value: actualValue, //celsius
                                enableAnimation: true,
                                position: LinearElementPosition.outside,
                                child: Container(
                                  width: 16,
                                  height: 12,
                                  transform:
                                      Matrix4.translationValues(4, 0, 0.0),
                                  child: Image.asset(
                                    'assets/images/triangle_pointer.png',
                                    color: actualValue > max // celcius
                                        ? const Color(0xffFF7B7B)
                                        : const Color(0xff0074E3),
                                  ),
                                ),
                              ),
                              LinearShapePointer(
                                value: actualValue, // celsius
                                width: 20,
                                height: 20,
                                enableAnimation: false,
                                color: Colors.transparent,
                                position: LinearElementPosition.cross,
                              ),
                            ],
                            barPointers: <LinearBarPointer>[
                              LinearBarPointer(
                                value: actualValue, //celcius,
                                enableAnimation: true,
                                thickness: 6,
                                edgeStyle: LinearEdgeStyle.endCurve,
                                color: actualValue > maxNormalTemperature
                                    ? const Color(0xffFF7B7B)
                                    : const Color(0xff0074E3),
                              ),
                            ],
                          ),

                          /// Linear gauge to display Fahrenheit  scale.
                          Container(
                            transform: Matrix4.translationValues(-6, 0, 0.0),
                            child: SfLinearGauge(
                              axisLabelStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: brightness == Brightness.dark
                                    ? Colors.white70
                                    : Colors.black26,
                              ),
                              minimum: 0,
                              maximum: 356,
                              showAxisTrack: false,
                              interval: 75,
                              minorTicksPerInterval: 5,
                              axisTrackExtent: 24,
                              axisTrackStyle: const LinearAxisTrackStyle(
                                thickness: 0,
                              ),
                              orientation: LinearGaugeOrientation.vertical,
                              markerPointers: const <LinearMarkerPointer>[
                                LinearWidgetPointer(
                                  markerAlignment: LinearMarkerAlignment.end,
                                  value: 356,
                                  position: LinearElementPosition.inside,
                                  offset: 6,
                                  enableAnimation: false,
                                  child: SizedBox(
                                    height: 28,
                                    child: Text(
                                      '°F',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 23, 5),              
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    '${actualValue.roundToDouble()}°C : ',
                    style: TextStyle(
                      fontSize: 18,
                      color: tempTextColor, //Color(0xff0074E3),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Times',
                    ),
                  ),
                  Text(
                    '${actualValue.toFahrenheit().roundToDouble()}°F',
                    style: TextStyle(
                      fontSize: 18,
                      color: tempTextColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Times',
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

extension on double {
  double toFahrenheit() => ((this * 9 / 5) + 32);
  double toCelsius() => ((this - 32) * 5 / 9);
}
