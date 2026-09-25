import 'package:flutter/material.dart';

class AuthorizationSettingsDialog extends StatelessWidget {
  const AuthorizationSettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Authorization Settings', style: TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Please open Authorization setting for better experience.', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 12),
          _authRow(Icons.camera_alt, 'Camera'),
          _authRow(Icons.phone, 'Phone'),
          _authRow(Icons.mic, 'Microphone'),
          _authRow(Icons.notifications, 'Notification'),
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE94057)),
          onPressed: () => Navigator.pop(context),
          child: const Text('Allow All', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _authRow(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.pinkAccent, size: 18),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 13)),
          const Spacer(),
          const Icon(Icons.check_circle, color: Colors.green, size: 16),
        ],
      ),
    );
  }
}
