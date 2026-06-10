import 'package:accident_detection/database/hive_database.dart';
import 'package:accident_detection/services/accident_detection_service.dart';
import 'package:flutter/material.dart';
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

  Future<void> addAccident(Map<String, dynamic> accident) async {
    DateTime time;
    try {
      time = DateTime.parse(accident['time']?.toString() ?? '');
    } catch (e) {
      time = DateTime.now();
    }
    await HiveDatabase.addToDatabase(
      accident['type'],
      time,
      (accident['force'] as num?)?.toDouble() ?? 0,
      (accident['speed'] as num?)?.toDouble() ?? 0,
      (accident['latitude'] as num?)?.toDouble() ?? 0,
      (accident['longitude'] as num?)?.toDouble() ?? 0,
    );
    await loadAccidents();
  }

  /// DELETE
  Future<void> deleteAccident(int index) async {
    await HiveDatabase.deleteAccident(index);

    await loadAccidents();
  }

  void toggleAccidentDetection(bool value) async {
    isAccidentDetected.value = value;
    if (value) {
      try {
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
      } catch (e) {
        print("Location check error: $e");
      }
      accidentDetectionService.startDetection();
    } else {
      accidentDetectionService.stopDetection();
    }
  }
}
