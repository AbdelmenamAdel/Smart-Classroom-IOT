import 'package:firebase_database/firebase_database.dart';
import '../models/classroom_model.dart';

class DashboardRepository {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Stream<ClassroomModel> classroomStream() {
    return _database.ref('classroom').onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null || data is! Map) {
        return const ClassroomModel(
          temp: 0.0,
          humidity: 0,
          light: false,
          students: 0,
        );
      }
      return ClassroomModel.fromJson(data);
    });
  }

  Future<void> updateLight(bool status) async {
    await _database.ref('classroom/light').set(status);
  }

  Future<void> recordHistory(ClassroomModel data) async {
    final historyRef = _database.ref('history').push();
    await historyRef.set({
      ...data.toMap(),
      'timestamp': ServerValue.timestamp,
    });
  }

  Stream<List<Map<dynamic, dynamic>>> historyStream() {
    return _database.ref('history').limitToLast(20).onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null || data is! Map) return [];
      
      final list = <Map<dynamic, dynamic>>[];
      data.forEach((key, value) {
        if (value is Map) {
          list.add(value);
        }
      });
      
      // Sort by timestamp
      list.sort((a, b) => (a['timestamp'] ?? 0).compareTo(b['timestamp'] ?? 0));
      return list;
    });
  }
}
