import 'package:flutter/material.dart';

class PartyRoomAudioManager {
  // Map to track mute/unmute state of each seat/user
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

  // Widget builder for mic control button on seat
  Widget buildMicButton(int seatIndex, VoidCallback onStateChanged) {
    final muted = isMuted(seatIndex);
    return GestureDetector(
      onTap: () {
        toggleMute(seatIndex);
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

  // Widget builder for speaking wave/animation indicator around seat
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

