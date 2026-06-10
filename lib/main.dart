import 'package:accident_detection/app/controllers/app_controller.dart';
import 'package:accident_detection/pages/home_page.dart';
import 'package:accident_detection/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  try {
    await Hive.openBox('accidents');
  } catch (e) {
    print("Failed to open Hive box: $e");
    await Hive.openBox('accidents');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialBinding: BindingsBuilder(() {
        Get.put(AppController());
      }),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: AppColors.drawerIcon),
        ),
      ),
      home: const HomePage(),
    );
  }
}
