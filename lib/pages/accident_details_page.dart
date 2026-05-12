import 'package:accident_detection/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccidentDetailsPage extends StatelessWidget {
  AccidentDetailsPage({super.key});

  Map<String, dynamic> get accident => Get.arguments;

  @override
  Widget build(BuildContext context) {
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
                    Icons.warning_rounded,
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
              value:
                  "${accident['latitude'] ?? "?"} , ${accident['longitude'] ?? "?"}",
              color: AppColors.monitoringOn,
            ),

            const SizedBox(height: 15),

            /// TYPE CARD
            buildInfoCard(
              icon: accident['type'] == "Car Crash"
                  ? Icons.car_crash
                  : Icons.warning_rounded,
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

            /// MAP PLACEHOLDER
            Container(
              height: 220,
              width: double.infinity,

              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(20),
              ),

              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Icon(Icons.map, size: 70, color: AppColors.textSecondary),

                    SizedBox(height: 10),

                    Text(
                      "Map Preview",
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textSecondary,
                      ),
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
                    onPressed: () {},

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
                    onPressed: () {},

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
