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

  DateTime? _lastLocationCheck;
  static const Duration _locationThrottle = Duration(seconds: 30);
  bool _processing = false;

  AccidentDetectionService({this.uiController});

  void startDetection() {
    stopDetection();

    try {
      gyroscopeSubscription = gyroscopeEvents.listen((event) {
        double rotation = event.x.abs() + event.y.abs() + event.z.abs();
        if (rotation > 2) {
          phoneRotated = true;
        }
      });
    } catch (e) {
      print("Gyroscope unavailable: $e");
    }

    try {
      accelerometerSubscription = accelerometerEvents.listen((
        AccelerometerEvent event,
      ) async {
        if (_processing) return;
        _processing = true;
        try {
          await _handleAccelerometerEvent(event);
        } finally {
          _processing = false;
        }
      });
    } catch (e) {
      print("Accelerometer unavailable: $e");
    }
  }

  Future<void> _handleAccelerometerEvent(AccelerometerEvent event) async {
    double x = event.x;
    double y = event.y;
    double z = event.z;

    double gForce = sqrt(x * x + y * y + z * z);

    uiController?.xValue.value = x;
    uiController?.yValue.value = y;
    uiController?.zValue.value = z;
    uiController?.gForce.value = gForce;
    lastGForce = gForce;

    Position? position;
    if (_lastLocationCheck == null ||
        DateTime.now().difference(_lastLocationCheck!) >= _locationThrottle) {
      position = await _getLocation();
      if (position != null) {
        _lastLocationCheck = DateTime.now();
      }
    }

    double speed = (position?.speed ?? 0) * 3.6;
    uiController?.speed.value = speed;

    if (gForce > 6) {
      if (lastAccidentTime != null &&
          DateTime.now().difference(lastAccidentTime!).inMinutes <
              cooldownMinutes) {
        print("SKIPPED: cooldown active");
      } else {
        print("CAR CRASH DETECTED");
        highImpactDetected = true;
        lastAccidentTime = DateTime.now();

        position ??= await _getLocation();

        await saveAccident(
          type: "Car Crash",
          force: gForce,
          speed: speed,
          position: position,
        );

        resetStates();
      }
      return;
    }

    if (gForce < 3) {
      double capturedGForce = lastGForce;
      await Future.delayed(const Duration(seconds: 1));

      if (capturedGForce > 5) {
        if (lastAccidentTime != null &&
            DateTime.now().difference(lastAccidentTime!).inMinutes <
                cooldownMinutes) {
          print("SKIPPED: cooldown active");
        } else {
          print("FALL DETECTED");
          lastAccidentTime = DateTime.now();

          position ??= await _getLocation();

          await saveAccident(
            type: "Fall Down",
            force: capturedGForce,
            speed: speed,
            position: position,
          );

          resetStates();
        }
      }
    }
  }

  Future<Position?> _getLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      }
    } catch (e) {
      print("Location unavailable: $e");
    }
    return null;
  }

  void stopDetection() {
    _processing = false;
    accelerometerSubscription?.cancel();
    accelerometerSubscription = null;
    gyroscopeSubscription?.cancel();
    gyroscopeSubscription = null;
  }

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

    if (uiController != null && !uiController!.isClosed) {
      await uiController!.loadAccidents();
    }
  }

  void resetStates() {
    phoneRotated = false;
    highImpactDetected = false;
  }
}
