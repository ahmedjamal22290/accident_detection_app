import 'dart:async';
import 'dart:math';

import 'package:accident_detection/app/controllers/app_controller.dart';
import 'package:accident_detection/database/hive_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccidentDetectionService {
  StreamSubscription? accelerometerSubscription;
  StreamSubscription? gyroscopeSubscription;

  bool phoneRotated = false;
  bool highImpactDetected = false;

  double lastGForce = 0;
  final AppController? uiController;
  DateTime? lastAccidentTime;
  static const int cooldownMinutes = 5;

  AccidentDetectionService({this.uiController});

  /// START
  void startDetection() {
    /// Listen to gyroscope
    gyroscopeSubscription = gyroscopeEvents.listen((event) {
      double rotation = event.x.abs() + event.y.abs() + event.z.abs();

      /// Phone rotated strongly
      if (rotation > 2) {
        phoneRotated = true;
      }
    });

    /// Listen to accelerometer
    accelerometerSubscription = accelerometerEvents.listen((
      AccelerometerEvent event,
    ) async {
      double x = event.x;
      double y = event.y;
      double z = event.z;

      /// Calculate total force
      double gForce = sqrt(x * x + y * y + z * z);

      uiController?.xValue.value = x;
      uiController?.yValue.value = y;
      uiController?.zValue.value = z;

      uiController?.gForce.value = gForce;
      lastGForce = gForce;

      print("GForce: $gForce");

      /// Get speed
      Position? position;
      try {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
        }
      } catch (e) {
        print("Location unavailable: $e");
      }

      double speed = (position?.speed ?? 0) * 3.6;
      uiController?.speed.value = speed;

      print("Speed: $speed km/h");

      /// ---------------------------
      /// CAR CRASH DETECTION
      /// ---------------------------

      if (gForce > 6 && phoneRotated) {
        if (lastAccidentTime != null &&
            DateTime.now().difference(lastAccidentTime!).inMinutes <
                cooldownMinutes) {
          print("SKIPPED: cooldown active");
        } else {
          print("CAR CRASH DETECTED");

          highImpactDetected = true;
          lastAccidentTime = DateTime.now();

          await saveAccident(
            type: "Car Crash",
            force: gForce,
            speed: speed,
            position: position,
          );

          resetStates();
        }
      }
      if (gForce > 6) {
        if (lastAccidentTime != null &&
            DateTime.now().difference(lastAccidentTime!).inMinutes <
                cooldownMinutes) {
          print("SKIPPED: cooldown active");
        } else {
          print("CAR CRASH DETECTED");

          highImpactDetected = true;
          lastAccidentTime = DateTime.now();

          await saveAccident(
            type: "Car Crash",
            force: gForce,
            speed: speed,
            position: position,
          );

          resetStates();
        }
      }

      /// ---------------------------
      /// FALL DETECTION
      /// ---------------------------

      if (gForce < 3) {
        /// Possible free fall
        print("Free Fall Detected");

        await Future.delayed(const Duration(seconds: 1));

        if (lastGForce > 5) {
          if (lastAccidentTime != null &&
              DateTime.now().difference(lastAccidentTime!).inMinutes <
                  cooldownMinutes) {
            print("SKIPPED: cooldown active");
          } else {
            print("FALL DETECTED");

            lastAccidentTime = DateTime.now();

            await saveAccident(
              type: "Fall Down",
              force: lastGForce,
              speed: speed,
              position: position,
            );

            resetStates();
          }
        }
      }
    });
  }

  /// STOP
  void stopDetection() {
    accelerometerSubscription?.cancel();
    gyroscopeSubscription?.cancel();
  }

  /// SAVE ACCIDENT OFFLINE
  Future<void> saveAccident({
    required String type,
    required double force,
    required double speed,
    Position? position,
  }) async {
    await HiveDatabase.addToDatabase(
      type,
      DateTime.now(),
      force,
      speed,
      position?.latitude ?? 0,
      position?.longitude ?? 0,
    );

    if (uiController != null) {
      await uiController!.loadAccidents();
    }

    print("ACCIDENT SAVED");
  }

  /// RESET FLAGS
  void resetStates() {
    phoneRotated = false;
    highImpactDetected = false;
  }
}
