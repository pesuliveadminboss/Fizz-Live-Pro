import 'package:flutter/material.dart';

class AppThemeColors {
  // GoLive Dribbble Reference Theme (Deep Purple & Dark Indigo)
  static const Color backgroundDark = Color(0xFF121026);
  static const Color surfaceCard = Color(0xFF1D1B36);
  static const Color primaryPurple = Color(0xFF6366F1);
  static const Color accentOrange = Color(0xFFF97316);
  static const Color textWhite = Colors.white;
  static const Color textMuted = Colors.white60;
}

ThemeData buildAppTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppThemeColors.backgroundDark,
    primaryColor: AppThemeColors.primaryPurple,
    colorScheme: const ColorScheme.dark(
      primary: AppThemeColors.primaryPurple,
      secondary: AppThemeColors.accentOrange,
      surface: AppThemeColors.surfaceCard,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppThemeColors.primaryPurple,
        foregroundColor: AppThemeColors.textWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    ),
  );
}
