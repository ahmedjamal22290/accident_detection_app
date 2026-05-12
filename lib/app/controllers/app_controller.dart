import 'package:accident_detection/database/hive_database.dart';
import 'package:accident_detection/services/accident_detection_service.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  RxList accidents = [].obs;

  RxBool isAccidentDetected = false.obs;

  AccidentDetectionService accidentDetectionService =
      AccidentDetectionService();

  RxDouble xValue = 0.0.obs;
  RxDouble yValue = 0.0.obs;
  RxDouble zValue = 0.0.obs;

  RxDouble gForce = 0.0.obs;

  RxDouble speed = 0.0.obs;
  @override
  void onInit() {
    super.onInit();

    loadAccidents();
  }

  /// LOAD
  Future<void> loadAccidents() async {
    accidents.value = await HiveDatabase.getAccidents();
  }

  /// ADD
  Future<void> addAccident(Map<String, dynamic> accident) async {
    await HiveDatabase.addToDatabase(
      accident['type'],

      DateTime.parse(accident['time']),

      accident['force'],

      accident['speed'],

      accident['latitude'],

      accident['longitude'],
    );

    await loadAccidents();
  }

  /// DELETE
  Future<void> deleteAccident(int index) async {
    await HiveDatabase.deleteAccident(index);

    await loadAccidents();
  }

  /// TOGGLE
  void toggleAccidentDetection(bool value) {
    isAccidentDetected.value = value;
    if (value) {
      accidentDetectionService.startDetection();
    } else {
      accidentDetectionService.stopDetection();
    }
  }
}
