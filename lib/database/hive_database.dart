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
    Box box = Hive.box('accidents');

    Map<String, dynamic> data = {
      "type": type,

      "time": dateTime.toString(),

      "latitude": latitude,

      "longitude": longitude,

      "speed": speed,

      "force": force,
    };

    await box.add(data);

    print("ACCIDENT SAVED");
  }

  static Future<List> getAccidents() async {
    Box box = Hive.box('accidents');

    return box.values.toList();
  }

  static Future<void> deleteAccident(int index) async {
    Box box = Hive.box('accidents');

    await box.deleteAt(index);
  }
}
