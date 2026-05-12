import 'package:accident_detection/app/controllers/app_controller.dart';
import 'package:accident_detection/helper/sensor_row.dart';
import 'package:accident_detection/pages/accidents_history_page.dart';
import 'package:accident_detection/themes/app_colors.dart';
import 'package:accident_detection/themes/font_themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';

class HomePage extends GetView<AppController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Home', style: FontThemes.headersStyle),
      ),
      drawer: Drawer(
        backgroundColor: AppColors.drawerBackground,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // DrawerHeader(child: Text('Home Page')),
              const SizedBox(height: 20),
              const ListTile(
                title: Text('HomePage', style: FontThemes.headersStyle),
              ),
              ListTile(
                onTap: () {
                  Get.to(const AccidentsHistoryPage());
                },
                title: const Text(
                  'Accidents history',
                  style: FontThemes.headersStyle,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Obx(() {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: AppColors.cardBackground,

                borderRadius: BorderRadius.circular(20),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Sensor Data",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  buildSensorRow(
                    "X Axis",
                    controller.xValue.value.toStringAsFixed(2),
                  ),

                  buildSensorRow(
                    "Y Axis",
                    controller.yValue.value.toStringAsFixed(2),
                  ),

                  buildSensorRow(
                    "Z Axis",
                    controller.zValue.value.toStringAsFixed(2),
                  ),

                  buildSensorRow(
                    "G-Force",
                    controller.gForce.value.toStringAsFixed(2),
                  ),

                  buildSensorRow(
                    "Speed",
                    "${controller.speed.value.toStringAsFixed(2)} km/h",
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                height: 450,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: controller.isAccidentDetected.value
                      ? AppColors.monitoringOn.withOpacity(0.3)
                      : AppColors.monitoringOff.withOpacity(0.3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurStyle: BlurStyle.outer,
                      spreadRadius: 10,
                      blurRadius: 7,
                    ),
                  ],
                ),
                child: Transform.scale(
                  scale: 2,
                  child: Switch(
                    padding: EdgeInsets.all(50),
                    value: controller.isAccidentDetected.value,

                    onChanged: (Value) {
                      controller.toggleAccidentDetection(Value);
                    },
                    inactiveThumbColor: Colors.white,
                    activeThumbColor: Colors.green[200],
                    activeTrackColor: Colors.green[600],
                    inactiveTrackColor: Colors.red[600],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              controller.isAccidentDetected.value
                  ? 'Accident Detected ON'
                  : 'Accident Detected OFF',
              style: FontThemes.headersStyle,
            ),
          ],
        );
      }),
    );
  }
}
