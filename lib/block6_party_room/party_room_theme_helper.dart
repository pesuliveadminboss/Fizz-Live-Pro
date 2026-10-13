import 'package:flutter/material.dart';

class PartyRoomThemeHelper {
  static BoxDecoration getThemeBackground(String themeKey) {
    switch (themeKey) {
      case 'royal_night':
        return const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3A1C71), Color(0xFFD76D77), Color(0xFFAFA7F8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        );
      case 'dj_club':
        return const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        );
      case 'party_ship_cinematic':
      default:
        return const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2A1B4E), Color(0xFF121026), Color(0xFF0B0919)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        );
    }
  }

  static Color getThemeAccentColor(String themeKey) {
    switch (themeKey) {
      case 'royal_night':
        return Colors.amberAccent;
      case 'dj_club':
        return Colors.cyanAccent;
      case 'party_ship_cinematic':
      default:
        return Colors.pinkAccent;
    }
  }
}
