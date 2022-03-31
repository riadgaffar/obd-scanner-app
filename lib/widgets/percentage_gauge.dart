import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obdii_scanner/packages/socket_io/cubit/socket_cubit.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class PercentageGauge extends StatelessWidget {
  const PercentageGauge({
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
    return BlocBuilder<SocketCubit, SocketState>(
      builder: (context, state) {
        return SfRadialGauge(
          enableLoadingAnimation: true,
          animationDuration: 2000,
          axes: <RadialAxis>[
            RadialAxis(
              startAngle: 180,
              endAngle: 360,
              canScaleToFit: true,
              interval: interval,
              radiusFactor: 0.95,
              labelFormat: '{value}%',
              labelsPosition: ElementsPosition.outside,
              ticksPosition: ElementsPosition.inside,
              labelOffset: 15,
              minorTickStyle: const MinorTickStyle(
                length: 0.05,
                lengthUnit: GaugeSizeUnit.factor,
                thickness: 1.5,
              ),
              majorTickStyle: const MajorTickStyle(
                length: 0.1,
                lengthUnit: GaugeSizeUnit.factor,
                thickness: 1.5,
              ),
              minorTicksPerInterval: 5,
              pointers: <GaugePointer>[
                NeedlePointer(
                  animationType: AnimationType.ease,
                  enableAnimation: true,
                  animationDuration: 800,
                  value: actualValue,
                  needleStartWidth: 1,
                  needleEndWidth: 3,
                  needleLength: 0.8,
                  needleColor: Colors.blueAccent,
                  lengthUnit: GaugeSizeUnit.factor,
                  knobStyle: const KnobStyle(
                    knobRadius: 8,
                    sizeUnit: GaugeSizeUnit.logicalPixel,
                  ),
                  tailStyle: const TailStyle(
                    width: 3,
                    lengthUnit: GaugeSizeUnit.logicalPixel,
                    length: 20,
                  ),
                )
              ],
              axisLabelStyle: const GaugeTextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              axisLineStyle: const AxisLineStyle(
                thickness: 3,
                color: Color(0xFF00A8B5),
              ),
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  widget: Text(
                    '$label: ${actualValue.toInt()}%',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
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
