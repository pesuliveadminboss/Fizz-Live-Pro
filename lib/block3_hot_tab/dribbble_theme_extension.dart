import 'package:flutter/material.dart';

class DribbbleTheme {
  // GoLive Dribbble UI Reference Exact Colors
  static const Color backgroundDark = Color(0xFF121026);     // Deep Purple / Indigo Background
  static const Color surfaceCard = Color(0xFF1D1B36);        // Card / Container Color
  static const Color primaryPurple = Color(0xFF6366F1);      // Electric Violet / Purple Button
  static const Color accentOrange = Color(0xFFF97316);       // Vibrant Orange Accent (Go Live / Check-in)
  static const Color accentPink = Color(0xFFEC4899);         // Neon Pink Tag Color
  static const Color textWhite = Colors.white;
  static const Color textMuted = Colors.white60;

  // Global ThemeData configuration to apply across the app
  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      primaryColor: primaryPurple,
      colorScheme: const ColorScheme.dark(
        primary: primaryPurple,
        secondary: accentOrange,
        surface: surfaceCard,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        elevation: 0,
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: textWhite,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 3,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceCard,
        hintStyle: const TextStyle(color: textMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryPurple, width: 1.5),
        ),
      ),
    );
  }

  // Reusable card decoration matching Dribbble concept
  static BoxDecoration cardDecoration() {
    return BoxDecoration(
      color: surfaceCard,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
