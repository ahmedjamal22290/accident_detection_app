import 'package:accident_detection/database/hive_database.dart';
import 'package:accident_detection/services/accident_detection_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  RxList accidents = [].obs;

  RxBool isAccidentDetected = false.obs;

  late final AccidentDetectionService accidentDetectionService =
      AccidentDetectionService(uiController: this);

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

  final service = FlutterBackgroundService();

  /// TOGGLE
  void toggleAccidentDetection(bool value) async {
    isAccidentDetected.value = value;
    if (value) {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (!await Geolocator.isLocationServiceEnabled()) {
        Get.snackbar(
          "Location Required",
          "Enable GPS to capture accident locations",
          mainButton: TextButton(
            onPressed: () => Geolocator.openLocationSettings(),
            child: const Text("Open Settings"),
          ),
          duration: const Duration(seconds: 10),
        );
      }
      accidentDetectionService.startDetection();
      service.startService();
    } else {
      accidentDetectionService.stopDetection();
      service.invoke("stopService");
    }
  }
}
