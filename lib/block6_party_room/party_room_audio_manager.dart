import 'package:flutter/material.dart';

class PartyRoomAudioManager {
  static void showAudioStatus(BuildContext context, bool isMuted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isMuted ? 'Microphone Muted 🔇' : 'Microphone Active 🎙️',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: isMuted ? Colors.redAccent.withOpacity(0.8) : Colors.green.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }
}
