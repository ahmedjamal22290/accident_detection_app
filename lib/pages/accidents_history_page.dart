import 'package:accident_detection/app/controllers/app_controller.dart';
import 'package:accident_detection/helper/accident_item.dart';
import 'package:accident_detection/themes/app_colors.dart';
import 'package:accident_detection/themes/font_themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccidentsHistoryPage extends GetView<AppController> {
  const AccidentsHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Accidents History', style: FontThemes.headersStyle),
      ),
      body: Obx(() {
        final items = controller.accidents;
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            if (index >= items.length) return const SizedBox.shrink();
            final accident = items[index];
            if (accident is! Map<String, dynamic>) {
              return const SizedBox.shrink();
            }
            return AccidentItem(accident: accident, index: index);
          },
        );
      }),
    );
  }
}
