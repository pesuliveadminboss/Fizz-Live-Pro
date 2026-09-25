import 'package:flutter/material.dart';

class CallReminderDialog extends StatelessWidget {
  const CallReminderDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Users call reminder', style: TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Turn on the call reminder and don\'t miss any call from users.', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 14),
          Row(children: const [Icon(Icons.star, color: Colors.amber, size: 16), SizedBox(width: 8), Text('Received evaluation', style: TextStyle(color: Colors.white, fontSize: 12))]),
          const SizedBox(height: 8),
          Row(children: const [Icon(Icons.notifications_active, color: Colors.pink, size: 16), SizedBox(width: 8), Text('New message', style: TextStyle(color: Colors.white, fontSize: 12))]),
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE94057)),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Call reminders enabled successfully! 🔔')));
            Navigator.pop(context);
          },
          child: const Text('Turn on notifications', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

