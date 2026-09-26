import 'package:flutter/material.dart';

class DribbbleThemeColors {
  // Exact colors from the GoLive Dribbble UI reference screenshot
  static const Color backgroundDark = Color(0xFF121026);     // Deep Purple/Indigo background
  static const Color surfaceCard = Color(0xFF1D1B36);        // Card / Container dark purple color
  static const Color primaryPurple = Color(0xFF6366F1);      // Electric Violet / Purple buttons
  static const Color accentOrange = Color(0xFFF97316);       // Vibrant Orange accents (like Go Live / Check-in)
  static const Color accentPink = Color(0xFFEC4899);         // Neon Pink tags
  static const Color textWhite = Colors.white;
  static const Color textMuted = Colors.white60;
}

class DribbbleThemeWidgetHelper {
  // Reusable styled container matching the screenshot card design
  static BoxDecoration cardDecoration() {
    return BoxDecoration(
      color: DribbbleThemeColors.surfaceCard,
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

  // Styled Elevated Button matching Dribbble concept
  static Widget customButton({
    required String text,
    required VoidCallback onPressed,
    Color backgroundColor = DribbbleThemeColors.primaryPurple,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: DribbbleThemeColors.textWhite,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 4,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }
}

