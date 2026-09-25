import 'package:flutter/material.dart';

class AppThemeColors {
  // Deep Dark & Electric Blue Theme inspired by the Dribbble UI Reference[span_1](start_span)[span_1](end_span)
  static const Color backgroundDark = Color(0xFF070710);
  static const Color surfaceCard = Color(0xFF131322);
  static const Color electricBlue = Color(0xFF2563EB);
  static const Color neonBlueAccent = Color(0xFF3B82F6);
  static const Color textWhite = Colors.white;
  static const Color textMuted = Colors.white60;
}

ThemeData buildAppTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppThemeColors.backgroundDark,
    primaryColor: AppThemeColors.electricBlue,
    colorScheme: const ColorScheme.dark(
      primary: AppThemeColors.electricBlue,
      secondary: AppThemeColors.neonBlueAccent,
      surface: AppThemeColors.surfaceCard,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppThemeColors.electricBlue,
        foregroundColor: AppThemeColors.textWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    ),
  );
}

