
import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String voltage;
  final double speed;
  final double rpm;
  final double engineLoad;
  final double temparature;
  final double fuelLevel;  

  const Message({
    this.voltage = '1.0V',
    this.speed = 0.0,
    this.rpm = 0.0,
    this.engineLoad = 0.0,    
    this.fuelLevel = 0.0, 
    this.temparature = -17.7,   
  });

  @override  
  List<Object?> get props => [voltage, speed, rpm, engineLoad, fuelLevel, temparature];

  Message copyWith({
    String? voltage,
    double? speed,
    double? rpm,
    double? engineLoad,
    double? temparature,
    double? fuelLevel,
  }) {
    return Message(
      voltage: voltage ?? this.voltage,
      speed: speed ?? this.speed,
      rpm: rpm ?? this.rpm,
      engineLoad: engineLoad ?? this.engineLoad,
      fuelLevel: fuelLevel ?? this.fuelLevel,
      temparature: temparature ?? this.temparature,
    );
  }
}
