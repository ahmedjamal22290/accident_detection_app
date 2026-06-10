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
      print("DB: box 'accidents' opened successfully");

      Map<String, dynamic> data = {
        "type": type,
        "time": dateTime.toString(),
        "latitude": latitude,
        "longitude": longitude,
        "speed": speed,
        "force": force,
      };

      await box.add(data);
      print("DB: box.add() succeeded");
      print("ACCIDENT SAVED");
    } catch (e) {
      print("DB ERROR in addToDatabase: $e");
    }
  }

  static Future<List> getAccidents() async {
    try {
      Box box = Hive.box('accidents');
      print("DB: getAccidents - box opened, count=${box.length}");
      List result = box.values.toList();
      print("DB: getAccidents returning ${result.length} items");
      return result;
    } catch (e) {
      print("DB ERROR in getAccidents: $e");
      return [];
    }
  }

  static Future<void> deleteAccident(int index) async {
    try {
      Box box = Hive.box('accidents');
      await box.deleteAt(index);
      print("DB: deleted accident at index $index");
    } catch (e) {
      print("DB ERROR in deleteAccident: $e");
    }
  }
}
