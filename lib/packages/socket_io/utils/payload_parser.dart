import 'package:obdii_scanner/packages/socket_io/model/message.dart';

enum PID {
  speed, // For 410D
  rpm, // For 410C
  engineLoad, // For 4104
  temperature, // For 4105
  fuelLevel, // For 412F
}

class PayloadParser {
  /*
  Use a more modular approach to use a Map or Dictionary to associate each PID
  (Parameter ID) with a specific parsing extension function.
  */
  final Map<PID, Function(String)> _parsers = {
    PID.speed: (String data) => data.toMiles(),
    PID.rpm: (String data) => data.toRPM(),
    PID.engineLoad: (String data) => data.toPercentage(),
    PID.temperature: (String data) => data.toTemperature(),
    PID.fuelLevel: (String data) => data.toPercentage(),
  };

  Message parsePayload(Message message, String payload) {
    if (payload.isEmpty) return message;

    if (RegExp(r'\.\d+V$').hasMatch(payload)) {
      return _parseVoltage(message, payload);
    } else {
      return _parsePIDData(message, payload);
    }
  }

  Message _parseVoltage(Message message, String payload) {
    var distilledPayload = payload.replaceAll('ATRV', '');
    return distilledPayload.isNotEmpty
        ? message.copyWith(voltage: distilledPayload)
        : message;
  }

  Message _parsePIDData(Message message, String payload) {
    var segments = RegExp(r'7E[89A-F0-9]{2}')
        .allMatches(payload)
        .map((m) => m.start)
        .toList()
        .reversed;

    for (var i = 0; i < segments.length; i++) {
      var end = i == 0 ? payload.length : segments.elementAt(i - 1);
      var segment = payload.substring(segments.elementAt(i), end);

      if (segment.length >= 9) {
        var pidString = segment.substring(5, 9);
        var data = segment.substring(9);
        var pid = PID.values.firstWhere((e) => e.pidString == pidString);
                
        var parsedValue = _parsers[pid]?.call(data);
        message = _updateMessage(message, pid, parsedValue);
      }
    }

    return message;
  }

  Message _updateMessage(Message message, PID pid, double? value) {
    switch (pid) {
      case PID.speed:
        message = message.copyWith(speed: value!);
        break;
      case PID.rpm:
        message = message.copyWith(rpm: value!);
        break;
      case PID.engineLoad:
        message = message.copyWith(engineLoad: value!);
        break;
      case PID.temperature:
        message = message.copyWith(temperature: value!);
        break;
      case PID.fuelLevel:
        message = message.copyWith(fuelLevel: value!);
        break;
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

extension PIDExtension on PID {
  String get pidString {
    switch (this) {
      case PID.speed:
        return '410D';
      case PID.rpm:
        return '410C';
      case PID.engineLoad:
        return '4104';
      case PID.temperature:
        return '4105';
      case PID.fuelLevel:
        return '412F';
    }
  }
}
