import 'package:flutter/material.dart';

class PartyRoomAudioManager {
  final Map<int, bool> _mutedSeats = {};
  final Map<int, bool> _speakingSeats = {};

  bool isMuted(int seatIndex) {
    return _mutedSeats[seatIndex] ?? false;
  }

  void toggleMute(int seatIndex) {
    final currentState = _mutedSeats[seatIndex] ?? false;
    _mutedSeats[seatIndex] = !currentState;
  }

  bool isSpeaking(int seatIndex) {
    return _speakingSeats[seatIndex] ?? false;
  }

  void setSpeaking(int seatIndex, bool speaking) {
    _speakingSeats[seatIndex] = speaking;
  }

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

  Widget buildMicButton(BuildContext context, int seatIndex, VoidCallback onStateChanged) {
    final muted = isMuted(seatIndex);
    return GestureDetector(
      onTap: () {
        toggleMute(seatIndex);
        showAudioStatus(context, !muted);
        onStateChanged();
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: muted ? Colors.red.withOpacity(0.8) : Colors.green.withOpacity(0.8),
          shape: BoxShape.circle,
        ),
        child: Icon(
          muted ? Icons.mic_off : Icons.mic,
          color: Colors.white,
          size: 14,
        ),
      ),
    );
  }

  Widget buildSpeakingIndicator(int seatIndex, Widget child) {
    final speaking = isSpeaking(seatIndex);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: speaking ? Colors.cyanAccent : Colors.transparent,
          width: 3,
        ),
      ),
      child: child,
    );
  }
}
