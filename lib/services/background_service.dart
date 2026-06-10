import 'dart:async';
import 'dart:developer';

import 'package:flutter_background_service/flutter_background_service.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
      initialNotificationTitle: "Accident Detection",
      initialNotificationContent: "Monitoring sensors",
      foregroundServiceNotificationId: 1,
      foregroundServiceTypes: [AndroidForegroundType.health],
    ),
  );
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance serviceInstance) async {
  Timer.periodic(const Duration(seconds: 5), (timer) {
    log("Background Service Running");
  });
}
