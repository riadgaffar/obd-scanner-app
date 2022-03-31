final List<String> resetScanToolCommands = [
  "ATSP0",
  "ATWS",
  "ATE0",
  "ATH1",
  "ATDPN"	
];

final List<String> sensorCommands = [
  "0104", // Calculated Engine Load (%)
	"0105", // Engine Coolant Temperature (C)
	"0106", // Short Term Fuel Trim (%)
	"0107", // Long  Term Fuel Trim (%)
	"010C", // RPM (revolutions per minute)
  "010D", // SPeed in kPh
  "012F", // Fuel Level (%)
	"0133", // Barometric Pressure (kPa)
	"0146", // Ambient Temperature (C)
	"015E", // Fuel Rate (L/h)
	"0163", // Torque (Nm)
  "ATRV" // Voltage
];