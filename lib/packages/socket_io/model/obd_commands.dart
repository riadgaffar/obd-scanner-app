/// Legacy
final List<String> resetScanToolCommands = [
  "ATSP0",
  "ATWS",
  "ATE0",
  "ATH1",
  "ATDPN"	
];

/// Legacy
final List<String> sensorCommands = [  
  "0104", // Calculated Engine Load (%)
	"0105", // Engine Coolant Temperature (C)
	"0106", // Short Term Fuel Trim (%)
	"0107", // Long  Term Fuel Trim (%)
	"010C", // RPM (revolutions per minute)
  "010D", // Speed in kPh
  "012F", // Fuel Level (%)
	"0133", // Barometric Pressure (kPa)
	"0146", // Ambient Temperature (C)
	"015E", // Fuel Rate (L/h)
	"0163", // Torque (Nm)
  "ATRV"  // Voltage
];

/// Legacy
final List<String> dtcCommands = [
  "03",   // Get Diagnostic Trouble Codes
  "04",   // Clear Diagnostic Trouble Codes
  "07",   // Get Pending Diagnostic Trouble Codes
];

enum Command {
  dtc("03\r"),                  // Get Diagnostic Trouble Codes
  clearDtc("04\r"),             // Clear Diagnostic Trouble Codes
  pendingDtc("07\r"),           // Get Pending Diagnostic Trouble Codes
  engineLoad("0104\r"),         // Calculated Engine Load (%)
	coolantTemp("0105\r"),        // Engine Coolant Temperature (C)
	shortFuelTrim("0106\r"),      // Short Term Fuel Trim (%)
	longFuelTrim("0107\r"),       // Long  Term Fuel Trim (%)
	rpm("010C\r"),                // RPM (revolutions per minute)
  speed("010D\r"),              // Speed in kPh
  fuelLevel("012F\r"),          // Fuel Level (%)
	barometricPressure("0133\r"), // Barometric Pressure (kPa)
	ambientTemp("0146\r"),        // Ambient Temperature (C)
	fuelRate("015E\r"),           // Fuel Rate (L/h)
	torque("0163\r"),             // Torque (Nm)
  voltage("ATRV\r"),            // Voltage
  protolDetection("ATSP0\r"),   // Auto protocol detection
  softReset("ATWS\r"),          // Perform soft reset or warm start
  displayHeaderOff("ATE0\r"),   // Data output with display headers turned off
  displayHeaderOn("ATH1\r"),    // Data output with display headers turned on
  protocolInNumber("ATDPN\n");  // Describes the protocol by number

  
  final String value;
  const Command(this.value);
}

class OBDResponse {
  final String responseString;
  OBDResponse(this.responseString);
}

class OBDCommand {
  final String commandString;
  OBDCommand(this.commandString);
}

class OBDDiagnosticTroubleCodesCommand extends OBDCommand {
  OBDDiagnosticTroubleCodesCommand() : super(Command.dtc.value);
}

class OBDDiagnosticClearTroubleCodesCommand extends OBDCommand {
  OBDDiagnosticClearTroubleCodesCommand() : super(Command.clearDtc.value);
}

class OBDDiagnosticPendingTroubleCodesCommand extends OBDCommand {
  OBDDiagnosticPendingTroubleCodesCommand() : super(Command.pendingDtc.value);
}

class OBDDiagnosticEngineLoadCommand extends OBDCommand {
  OBDDiagnosticEngineLoadCommand() : super(Command.engineLoad.value);
}

class OBDDiagnosticCoolantTempCommand extends OBDCommand {
  OBDDiagnosticCoolantTempCommand() : super(Command.coolantTemp.value);
}

class OBDDiagnosticShortTermFuelTrimCommand extends OBDCommand {
  OBDDiagnosticShortTermFuelTrimCommand() : super(Command.shortFuelTrim.value);
}

class OBDDiagnosticLongTermFuelTrimCommand extends OBDCommand {
  OBDDiagnosticLongTermFuelTrimCommand() : super(Command.longFuelTrim.value);
}

class OBDDiagnosticEngineRpmCommand extends OBDCommand {
  OBDDiagnosticEngineRpmCommand() : super(Command.rpm.value);
}

class OBDDiagnosticVehicleSpeedCommand extends OBDCommand {
  OBDDiagnosticVehicleSpeedCommand() : super(Command.speed.value);
}

class OBDDiagnosticFuelLevelCommand extends OBDCommand {
  OBDDiagnosticFuelLevelCommand() : super(Command.fuelLevel.value);
}

class OBDDiagnosticBarometricPressureCommand extends OBDCommand {
  OBDDiagnosticBarometricPressureCommand() : super(Command.barometricPressure.value);
}

class OBDDiagnosticAmbientTempCommand extends OBDCommand {
  OBDDiagnosticAmbientTempCommand() : super(Command.ambientTemp.value);
}

class OBDDiagnosticFuelRateCommand extends OBDCommand {
  OBDDiagnosticFuelRateCommand() : super(Command.fuelRate.value);
}

class OBDDiagnosticTorqueCommand extends OBDCommand {
  OBDDiagnosticTorqueCommand() : super(Command.torque.value);
}

class OBDDiagnosticVoltageCommand extends OBDCommand {
  OBDDiagnosticVoltageCommand() : super(Command.voltage.value);
}

class OBDAutoProtoclDetectionCommand extends OBDCommand {
  OBDAutoProtoclDetectionCommand() : super(Command.protolDetection.value);
}

class OBDSoftRestCommand extends OBDCommand {
  OBDSoftRestCommand() : super(Command.softReset.value);
}

class OBDDisplayHeaderOffCommand extends OBDCommand {
  OBDDisplayHeaderOffCommand() : super(Command.displayHeaderOff.value);
}

class OBDDisplayHeaderOnCommand extends OBDCommand {
  OBDDisplayHeaderOnCommand() : super(Command.displayHeaderOn.value);
}

class OBDDescribeProtocolInNumberCommand extends OBDCommand {
  OBDDescribeProtocolInNumberCommand() : super(Command.protocolInNumber.value);
}

