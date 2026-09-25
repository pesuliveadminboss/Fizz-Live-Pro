import 'package:flutter/material.dart';

class CallReminderDialog extends StatefulWidget {
  const CallReminderDialog({super.key});

  @override
  State<CallReminderDialog> createState() => _CallReminderDialogState();
}

class _CallReminderDialogState extends State<CallReminderDialog> {
  bool _isCallReminderOn = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2C),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header Graphic / Illustration Simulation matching Screenshot 13
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE94057), Color(0xFF8A2387)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.phone_in_talk, color: Colors.white, size: 28),
                  const Text(
                    'Users call reminder',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Switch(
                    value: _isCallReminderOn,
                    activeColor: Colors.white,
                    activeTrackColor: Colors.green,
                    onChanged: (val) {
                      setState(() {
                        _isCallReminderOn = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Description matching Screenshot 13
            const Text(
              'Turn on the call reminder and don\'t miss any call from users',
              style: TextStyle(fontSize: 13, color: Colors.white70),
            ),
            const SizedBox(height: 16),

            // Received evaluation & New message items matching Screenshot 13
            Row(
              children: const [
                Icon(Icons.star, color: Colors.amber, size: 18),
                SizedBox(width: 10),
                Text('Received evaluation', style: TextStyle(fontSize: 13, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Icon(Icons.notifications_active, color: Colors.pinkAccent, size: 18),
                SizedBox(width: 10),
                Text('New message', style: TextStyle(fontSize: 13, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 24),

            // Turn on notifications Button matching Screenshot 13
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE94057),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Call reminders enabled successfully! 🔔')),
                  );
                  Navigator.pop(context);
                },
                child: const Text(
                  'Turn on notifications',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
