import 'package:flutter/services.dart';

class GameSoundHelper {
  // Play subtle haptic feedback and sound triggers for clicks, spins, and wins
  static void playClickSound() {
    HapticFeedback.lightImpact();
  }

  static void playSpinSound() {
    HapticFeedback.mediumImpact();
  }

  static void playWinSound() {
    HapticFeedback.heavyImpact();
  }

  static void playLossSound() {
    HapticFeedback.vibrate();
  }
}
