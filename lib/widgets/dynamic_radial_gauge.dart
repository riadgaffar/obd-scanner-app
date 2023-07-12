import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obdii_scanner/packages/socket_io/cubit/socket_cubit.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DynamicRadialGauge extends StatelessWidget {
  const DynamicRadialGauge({
    Key? key,
    required this.label,
    required this.actualValue,
    required this.interval,
    required this.min,
    required this.max,
    required this.createGaugeRange,
  }) : super(key: key);

  final String label;
  final double actualValue;
  final double interval;
  final double min;
  final double max;
  final Function createGaugeRange;

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    return BlocBuilder<SocketCubit, SocketState>(
      builder: (context, state) {
        return SfRadialGauge(
          enableLoadingAnimation: true,
          animationDuration: 2000,
          axes: <RadialAxis>[
            RadialAxis(
              interval: interval,
              minimum: min,
              maximum: max,
              axisLabelStyle: GaugeTextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: brightness == Brightness.dark
                                    ? Colors.white70
                                    : Colors.black26,
              ),
              axisLineStyle: const AxisLineStyle(
                thicknessUnit: GaugeSizeUnit.logicalPixel,
                thickness: 0.1,
              ),
              canScaleToFit: true,
              // radiusFactor: 0.9,
              labelOffset: 10,
              minorTickStyle: const MinorTickStyle(
                length: 0.1,
                lengthUnit: GaugeSizeUnit.factor,
                thickness: 1.0,
                color: Colors.white70,
              ),
              majorTickStyle: const MinorTickStyle(
                length: 0.15,
                lengthUnit: GaugeSizeUnit.factor,
                thickness: 1.0,
                color: Colors.white70,
              ),
              minorTicksPerInterval: 5,
              ranges: createGaugeRange(min, max),
              pointers: <GaugePointer>[
                NeedlePointer(
                  animationType: AnimationType.ease,
                  enableAnimation: true,
                  animationDuration: 800,
                  needleColor: Colors.blueAccent,
                  value: actualValue,
                  needleStartWidth: 1,
                  needleEndWidth: 3,
                  needleLength: 0.8,
                  lengthUnit: GaugeSizeUnit.factor,
                  knobStyle: const KnobStyle(
                    knobRadius: 8,
                    sizeUnit: GaugeSizeUnit.logicalPixel,
                  ),
                  tailStyle: const TailStyle(
                    width: 1,
                    lengthUnit: GaugeSizeUnit.logicalPixel,
                    length: 7,
                  ),
                )
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: Text(
                      actualValue.toInt().toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                    angle: 90,
                    positionFactor: 0.5),
                GaugeAnnotation(
                  widget: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  angle: 90,
                  positionFactor: 0.3,
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
