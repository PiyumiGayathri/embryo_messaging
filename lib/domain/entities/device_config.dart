class DeviceConfig {
  String deviceName;
  String location;
  List<String> mobileNumbers;
  String smsInterval;

  DeviceConfig({
    this.deviceName = '',
    this.location = '',
    List<String>? mobileNumbers,
    this.smsInterval = '1',
  }) : mobileNumbers = mobileNumbers ?? ['', '', '', '', ''];

  // Convert to Map for SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'deviceName': deviceName,
      'location': location,
      'mobileNumbers': mobileNumbers,
      'smsInterval': smsInterval,
    };
  }

  // Create from Map
  factory DeviceConfig.fromMap(Map<String, dynamic> map) {
    return DeviceConfig(
      deviceName: map['deviceName'] ?? '',
      location: map['location'] ?? '',
      mobileNumbers: List<String>.from(map['mobileNumbers'] ?? ['', '', '', '', '']),
      smsInterval: map['smsInterval'] ?? '1',
    );
  }
}

