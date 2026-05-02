import 'package:equatable/equatable.dart';

class ClassroomModel extends Equatable {
  final double temp;
  final int humidity;
  final bool light;
  final int students;

  const ClassroomModel({
    required this.temp,
    required this.humidity,
    required this.light,
    required this.students,
  });

  factory ClassroomModel.fromJson(Map<dynamic, dynamic> json) {
    return ClassroomModel(
      temp: (json['temp'] ?? 0.0).toDouble(),
      humidity: (json['humidity'] ?? 0).toInt(),
      light: json['light'] ?? false,
      students: (json['students'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'temp': temp,
      'humidity': humidity,
      'light': light,
      'students': students,
    };
  }

  @override
  List<Object?> get props => [temp, humidity, light, students];
}
