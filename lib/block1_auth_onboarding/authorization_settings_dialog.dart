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
        children: [
          const Text('Please open authorization settings for better experience (Camera, Microphone, Phone, Notification).', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 16),
          SwitchListTile(title: const Text('Camera Access', style: TextStyle(color: Colors.white, fontSize: 13)), value: true, activeColor: Colors.pink, onChanged: (v) {}),
          SwitchListTile(title: const Text('Microphone Access', style: TextStyle(color: Colors.white, fontSize: 13)), value: true, activeColor: Colors.pink, onChanged: (v) {}),
          SwitchListTile(title: const Text('Notifications', style: TextStyle(color: Colors.white, fontSize: 13)), value: true, activeColor: Colors.pink, onChanged: (v) {}),
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
}
