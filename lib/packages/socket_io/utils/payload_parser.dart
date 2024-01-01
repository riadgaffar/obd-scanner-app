import 'package:obdii_scanner/packages/socket_io/model/message.dart';

enum PIDs {
  rpm('410C'),
  speed('410D'),
  engineLoad('4104'),
  temperature('4105'),
  fuelLevel('412F');

  final String value;
  const PIDs(this.value);
}

class PayloadParser {
  /*
  Use a more modular approach to use a Map or Dictionary to associate each PID
  (Parameter ID) with a specific parsing extension function.
  */
  final Map<String, Function(String)> _parsers = {
    PIDs.speed.value: (String data) => data.toMiles(),
    PIDs.rpm.value: (String data) => data.toRPM(),
    PIDs.engineLoad.value: (String data) => data.toPercentage(),
    PIDs.temperature.value: (String data) => data.toTemperature(),
    PIDs.fuelLevel.value: (String data) => data.toPercentage(),
  };

  Message parsePayload(Message message, String payload) {
    if (payload.isNotEmpty && payload.length > 4) {
      if (RegExp(r'^.*?\.\d+?V$').hasMatch(payload)) {
        /// voltage
        var distilledPayload = payload.replaceAll(RegExp(r'ATRV'), '');
        if (distilledPayload.isNotEmpty) {
          message = message.copyWith(voltage: distilledPayload);
        }
      } else {
        var segments = RegExp(r'7E[89A-F0-9]{2}')
            .allMatches(payload)
            .map((m) => m.start)
            .toList().reversed.toList();


        for (var i = 0; i < segments.length; i++) {
          // Calculate the start and end positions of each segment
          var start = segments[i];
          var end = i == 0 ? payload.length : segments[i - 1];
          var segment = payload.substring(start, end);

          if (segment.length >= 6) {
            // var pid = segment.substring(2, 6);
            var pid = segment.substring(5, 9);
            var data = segment.substring(9);
            // Use the map to find the appropriate parsing function
            var parser = _parsers[pid];
            if (parser != null) {
              var parsedValue = parser(data);
              // Update the message object based on the PID
              switch (pid) {
                case '410D':
                  message = message.copyWith(speed: parsedValue!);
                  break;
                case '410C':
                  message = message.copyWith(rpm: parsedValue!);
                  break;
                case '4104':
                  message = message.copyWith(engineLoad: parsedValue!);
                  break;
                case '4105':
                  message = message.copyWith(temperature: parsedValue!);
                  break;
                case '412F':
                  message = message.copyWith(fuelLevel: parsedValue!);
                  break;
              }
            }
          }
        }
      }
    }

    return message;
  }
}

extension on String {
  double? toMiles() {
    var km = int.tryParse(this, radix: 16)!.toDouble();
    var miles = (km * 0.621371);
    return miles.roundToDouble();
  }

  double toRPM() => (int.parse(this, radix: 16) / 4);

  double toTemperature() => (int.parse(this, radix: 16) - 40);

  double toPercentage() => ((int.parse(this, radix: 16) / 255) * 100);
}
