import 'package:flutter/material.dart';
import '../1_core/core_data.dart';

class PostLoginPopupManager {
  static void showSequentialPopups(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const AuthorizationSettingsDialog(),
    );
  }
}

class AuthorizationSettingsDialog extends StatelessWidget {
  const AuthorizationSettingsDialog({super.key});
  @override
  Widget build(context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _showDailyRewards(context);
                },
                child: const Icon(Icons.close, color: Colors.grey),
              ),
            ),
            const Text('Authorization Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 6),
            const Text('Please open authorization setting for better experience', style: TextStyle(fontSize: 12, color: Colors.black54), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            _buildAuthRow(Icons.camera_alt_outlined, Colors.pink, 'Camera'),
            const Divider(),
            _buildAuthRow(Icons.phone_outlined, Colors.redAccent, 'Phone'),
            const Divider(),
            _buildAuthRow(Icons.mic_none, Colors.pinkAccent, 'Microphone'),
            const Divider(),
            _buildAuthRow(Icons.notifications_none, Colors.pinkAccent, 'Notification'),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                _showDailyRewards(context);
              },
              child: Container(
                width: double.infinity, height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.purpleAccent]),
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.center,
                child: const Text('Allow all', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthRow(IconData icon, Color color, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 14),
          Text(title, style: const TextStyle(color: Colors.black87, fontSize: 14)),
        ],
      ),
    );
  }
}

void _showDailyRewards(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => const DailyRewardsDialog(),
  );
}

class DailyRewardsDialog extends StatefulWidget {
  const DailyRewardsDialog({super.key});
  @override
  State<DailyRewardsDialog> createState() => _DailyRewardsDialogState();
}

class _DailyRewardsDialogState extends State<DailyRewardsDialog> {
  int checkedDay = 1;
  @override
  Widget build(context) {
    final items = [
      {'day': 'day 1', 'reward': 'x40 gems'},
      {'day': 'day 2', 'reward': '30m free call card'},
      {'day': 'day 3', 'reward': 'x50 gems'},
      {'day': 'day 4', 'reward': 'x90 gems'},
      {'day': 'day 5', 'reward': 'x120 gems'},
      {'day': 'day 6', 'reward': 'x180 gems'},
      {'day': 'day 7', 'reward': 'mystery box 200 gems'},
    ];
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Daily rewards', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                    Text('Sign in for 7 days to get a surprise', style: TextStyle(fontSize: 11, color: Colors.black54)),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _showTimelyAlerts(context);
                  },
                  child: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: items.map((item) {
                final idx = items.indexOf(item) + 1;
                final isSelected = idx == checkedDay;
                return Container(
                  width: 95, height: 75,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.amber.withOpacity(0.15) : Colors.grey[100],
                    border: Border.all(color: isSelected ? Colors.amber : Colors.transparent, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item['day'] as String, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      const SizedBox(height: 4),
                      const Icon(Icons.diamond, color: Colors.amber, size: 22),
                      const SizedBox(height: 4),
                      Text(item['reward'] as String, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black87), textAlign: TextAlign.center),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  checkedDay = checkedDay < 7 ? checkedDay + 1 : 1;
                });
                Navigator.pop(context);
                _showTimelyAlerts(context);
              },
              child: Container(
                width: double.infinity, height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.amber, Colors.orangeAccent]),
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.center,
                child: const Text('Check-in', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showTimelyAlerts(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _showCallReminders(context);
                },
                child: const Icon(Icons.close, color: Colors.grey),
              ),
            ),
            const Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.card_giftcard, size: 80, color: Colors.purpleAccent),
                Positioned(top: 15, child: Icon(Icons.diamond, color: Colors.amber, size: 28)),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Get timely alerts so you don\'t miss', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                _showCallReminders(context);
              },
              child: Container(
                width: double.infinity, height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.purpleAccent]),
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.center,
                child: const Text('Allow notification', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showCallReminders(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => const CallRemindersDialog(),
  );
}

class CallRemindersDialog extends StatefulWidget {
  const CallRemindersDialog({super.key});
  @override
  State<CallRemindersDialog> createState() => _CallRemindersDialogState();
}

class _CallRemindersDialogState extends State<CallRemindersDialog> {
  bool reminderEnabled = true;
  @override
  Widget build(context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, color: Colors.grey),
              ),
            ),
            Container(
              width: 65, height: 65,
              decoration: BoxDecoration(
                color: Colors.pinkAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.phone_android, size: 32, color: Colors.pinkAccent),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Users call reminder', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                const SizedBox(width: 8),
                Switch(
                  value: reminderEnabled,
                  activeColor: Colors.green,
                  onChanged: (val) => setState(() => reminderEnabled = val),
                ),
              ],
            ),
            const Text('Turn on the call reminder and don\'t miss any call from users', style: TextStyle(fontSize: 12, color: Colors.black54), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  SizedBox(width: 10),
                  Text('Received evaluation', style: TextStyle(fontSize: 13, color: Colors.black87)),
                ],
              ),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Icon(Icons.notifications_active, color: Colors.pinkAccent, size: 20),
                  SizedBox(width: 10),
                  Text('New message', style: TextStyle(fontSize: 13, color: Colors.black87)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity, height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.purpleAccent]),
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.center,
                child: const Text('Turn on notifications', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
