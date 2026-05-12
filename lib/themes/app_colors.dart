import 'package:flutter/material.dart';

class AppColors {
  // Main Colors
  static const Color primary = Color(0xFF1565C0);
  static const Color secondary = Color(0xFF42A5F5);

  // Backgrounds
  static const Color scaffoldBackground = Color(0xFFF5F7FA);
  static const Color cardBackground = Colors.white;

  // Status Colors
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFFFA000);
  static const Color danger = Color(0xFFD32F2F);

  // Monitoring States
  static const Color monitoringOn = Color(0xFF00C853);
  static const Color monitoringOff = Color(0xFFB0BEC5);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textWhite = Colors.white;

  // Drawer
  static const Color drawerBackground = Color(0xFF0D47A1);
  static const Color drawerIcon = Colors.white;

  // Buttons
  static const Color buttonPrimary = Color(0xFF1976D2);
  static const Color buttonDanger = Color(0xFFE53935);

  // Borders & Shadows
  static const Color border = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1A000000);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
