class AppConstants {
  // MQTT Configuration
  static const String mqttBrokerIp = '192.168.43.210';
  static const int mqttPort = 1883;
  static const String mqttClientId = 'flutter_client';

  // MQTT Topics
  static const String topicStudents = 'smartclassroom/students';
  static const String topicTemp = 'smartclassroom/temp';
  static const String topicHumidity = 'smartclassroom/humidity';
  static const String topicCurrentMode = 'smartclassroom/current_mode';
  static const String topicLightStatus = 'smartclassroom/light_status';

  // Publish Topics
  static const String topicModeControl = 'smartclassroom/mode';
  static const String topicLightControl = 'smartclassroom/light';

  // Topic Filter (Subscription)
  static const String topicFilter = 'smartclassroom/#';
}
