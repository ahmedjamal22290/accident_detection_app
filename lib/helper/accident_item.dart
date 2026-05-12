import 'package:accident_detection/pages/accident_details_page.dart';
import 'package:accident_detection/themes/app_colors.dart';
import 'package:accident_detection/themes/font_themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccidentItem extends StatelessWidget {
  const AccidentItem({
    super.key,
    required this.accident,
  });
  final Map<String, dynamic> accident;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
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
      child: ListTile(
        onTap: () {
          Get.to(() => AccidentDetailsPage(), arguments: accident);
        },
        minVerticalPadding: 10,
        title: Text(accident['type'], style: FontThemes.bodyStyle),
        subtitle: Text(accident['time'], style: FontThemes.subtitleStyle),
        trailing: Text(
          "longitude: ${accident['longitude']}\nlatitude: ${accident['latitude']}",
          style: FontThemes.subtitleStyle,
        ),
      ),
    );
  }
}
