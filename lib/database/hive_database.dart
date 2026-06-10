import 'package:hive/hive.dart';

class HiveDatabase {
  static Future<void> addToDatabase(
    String type,
    DateTime dateTime,
    double force,
    double speed,
    double latitude,
    double longitude,
  ) async {
    try {
      Box box = Hive.box('accidents');

      Map<String, dynamic> data = {
        "type": type,
        "time": dateTime.toString(),
        "latitude": latitude,
        "longitude": longitude,
        "speed": speed,
        "force": force,
      };

      int key = await box.add(data);
      data['hiveKey'] = key;
      await box.put(key, data);
    } catch (e) {
      print("DB ERROR in addToDatabase: $e");
    }
  }

  static Future<List> getAccidents() async {
    try {
      Box box = Hive.box('accidents');
      return box.values.toList();
    } catch (e) {
      print("DB ERROR in getAccidents: $e");
      return [];
    }
  }

  static Future<void> deleteAccident(int index) async {
    try {
      Box box = Hive.box('accidents');
      final values = box.values.toList();
      if (index < 0 || index >= values.length) {
        print("DB ERROR: index $index out of range (length ${values.length})");
        return;
      }
      final accident = values[index] as Map;
      final key = accident['hiveKey'];
      if (key != null) {
        await box.delete(key);
      } else {
        await box.deleteAt(index);
      }
    } catch (e) {
      print("DB ERROR in deleteAccident: $e");
    }
  }
}
