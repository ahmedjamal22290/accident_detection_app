import 'dart:async';
import 'dart:math';

import 'package:accident_detection/app/controllers/app_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccidentDetectionService {
  StreamSubscription? accelerometerSubscription;
  StreamSubscription? gyroscopeSubscription;

  bool phoneRotated = false;
  bool highImpactDetected = false;

  double lastGForce = 0;
  AppController get appController => Get.find<AppController>();

  /// START
  void startDetection() {
    /// Listen to gyroscope
    gyroscopeSubscription = gyroscopeEvents.listen((event) {
      double rotation = event.x.abs() + event.y.abs() + event.z.abs();

      /// Phone rotated strongly
      if (rotation > 10) {
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

      appController.xValue.value = x;
      appController.yValue.value = y;
      appController.zValue.value = z;

      appController.gForce.value = gForce;
      lastGForce = gForce;

      print("GForce: $gForce");

      /// Get speed
      Position? position;
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

      double speed = (position?.speed ?? 0) * 3.6;
      appController.speed.value = speed;

      print("Speed: $speed km/h");

      /// ---------------------------
      /// CAR CRASH DETECTION
      /// ---------------------------

      if (gForce > 25 && speed > 20 && phoneRotated) {
        print("CAR CRASH DETECTED");

        highImpactDetected = true;

        if (position != null) {
          await saveAccident(
            type: "Car Crash",
            force: gForce,
            speed: speed,
            position: position,
          );
        }

        resetStates();
      }

      /// ---------------------------
      /// FALL DETECTION
      /// ---------------------------

      if (gForce < 1) {
        /// Possible free fall
        print("Free Fall Detected");

        await Future.delayed(const Duration(seconds: 1));

        if (lastGForce > 18) {
          print("FALL DETECTED");

          if (position != null) {
            await saveAccident(
              type: "Fall Down",
              force: lastGForce,
              speed: speed,
              position: position,
            );
          }

          resetStates();
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
    required Position position,
  }) async {
    Map<String, dynamic> accident = {
      "type": type,
      "time": DateTime.now().toString(),
      "latitude": position.latitude,
      "longitude": position.longitude,
      "speed": speed,
      "force": force,
    };
    await appController.addAccident(accident);

    await appController.loadAccidents();

    print("ACCIDENT SAVED");
  }

  /// RESET FLAGS
  void resetStates() {
    phoneRotated = false;
    highImpactDetected = false;
  }
}
