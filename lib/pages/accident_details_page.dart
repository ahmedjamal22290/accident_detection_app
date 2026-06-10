import 'package:accident_detection/app/controllers/app_controller.dart';
import 'package:accident_detection/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:share_plus/share_plus.dart';

class AccidentDetailsPage extends StatelessWidget {
  const AccidentDetailsPage({super.key});

  Map<String, dynamic> get accident => Get.arguments['accident'];
  int get index => Get.arguments['index'];

  @override
  Widget build(BuildContext context) {
    double lat = double.tryParse('${accident['latitude']}') ?? 29.3;
    double lng = double.tryParse('${accident['longitude']}') ?? 30.8;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,

      appBar: AppBar(
        title: const Text("Accident Details"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// STATUS CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: AppColors.danger.withOpacity(0.08),

                borderRadius: BorderRadius.circular(20),

                border: Border.all(color: AppColors.danger),
              ),

              child: Column(
                children: [
                  Icon(
                    accident['type'] == "Fall Down"
                        ? Icons.warning_rounded
                        : Icons.car_crash,
                    color: AppColors.danger,
                    size: 60,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    accident['type'] ?? "Accident Detected",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.danger,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "The system detected a possible accident or fall event.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// DETAILS TITLE
            const Text(
              "Accident Information",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 15),

            /// TIME CARD
            buildInfoCard(
              icon: Icons.access_time_filled,
              title: "Accident Time",
              value: accident['time'] ?? "Unknown",
              color: AppColors.primary,
            ),

            const SizedBox(height: 15),

            /// LOCATION CARD
            buildInfoCard(
              icon: Icons.location_on,
              title: "Location",
              value: "$lat , $lng",
              color: AppColors.monitoringOn,
            ),

            const SizedBox(height: 15),

            /// TYPE CARD
            buildInfoCard(
              icon: Icons.car_crash,
              title: "Accident Type",
              value: accident['type'] ?? "Unknown",
              color: AppColors.warning,
            ),

            const SizedBox(height: 15),

            /// FORCE CARD
            buildInfoCard(
              icon: Icons.speed,
              title: "Impact Force",
              value: "${accident['force']?.toStringAsFixed(2) ?? "?"} G",
              color: AppColors.danger,
            ),

            const SizedBox(height: 15),

            /// SPEED CARD
            buildInfoCard(
              icon: Icons.speed,
              title: "Speed",
              value: "${accident['speed']?.toStringAsFixed(2) ?? "?"} km/h",
              color: AppColors.monitoringOn,
            ),

            const SizedBox(height: 30),

            /// OFFLINE MAP
            SizedBox(
              height: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(lat, lng),
                    initialZoom: 14,
                    minZoom: 12,
                    maxZoom: 18,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'assets/GPS/Fayom/{z}/{x}/{y}.png',
                      tileProvider: AssetTileProvider(),
                      maxNativeZoom: 18,
                      minNativeZoom: 12,
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(lat, lng),
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// BUTTONS
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      String text =
                          "🚨 Accident Detected!\n"
                          "Type: ${accident['type']}\n"
                          "Time: ${accident['time']}\n"
                          "Location: $lat, $lng\n"
                          "Force: ${accident['force']?.toStringAsFixed(2) ?? "?"} G\n"
                          "Speed: ${accident['speed']?.toStringAsFixed(2) ?? "?"} km/h";
                      Share.share(text);
                    },

                    icon: const Icon(Icons.share),

                    label: const Text("Share"),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonPrimary,

                      foregroundColor: AppColors.textWhite,

                      padding: const EdgeInsets.symmetric(vertical: 15),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.find<AppController>().deleteAccident(index);
                      Get.back();
                    },

                    icon: const Icon(Icons.delete),

                    label: const Text("Delete"),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonDanger,

                      foregroundColor: AppColors.textWhite,

                      padding: const EdgeInsets.symmetric(vertical: 15),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: AppColors.cardBackground,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: color.withOpacity(0.1),

              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(icon, color: color, size: 30),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
