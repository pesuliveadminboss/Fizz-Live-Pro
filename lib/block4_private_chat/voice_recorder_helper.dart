import 'package:flutter/material.dart';

class VoiceRecorderHelper {
  // Real voice recording simulation dialog or feedback
  static void startRecording(BuildContext context, Function(String) onVoiceRecorded) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1D1B36),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.mic, color: Colors.redAccent, size: 48),
              SizedBox(height: 16),
              Text(
                'Recording Voice Note...',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Speak now, recording in progress 🎙️',
                style: TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );

    // Simulate 3 seconds of recording and automatically send the voice note
    Future.delayed(const Duration(seconds: 3), () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context); // Close recording dialog
      }
      onVoiceRecorded('Voice Message 🎤 [0:03]');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Voice note recorded and sent successfully!'),
          backgroundColor: Color(0xFF1D1B36),
        ),
      );
    });
  }
}

