import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models_and_state.dart';

class EntryPopupsHelper {
  static void showDailyRewardsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Consumer<AppState>(
        builder: (context, appState, child) {
          final dayRewards = [
            {'day': 1, 'label': 'x 40', 'icon': Icons.diamond, 'color': Colors.amberAccent},
            {'day': 2, 'label': 'x 1', 'icon': Icons.credit_card, 'color': Colors.orangeAccent},
            {'day': 3, 'label': 'x 50', 'icon': Icons.diamond, 'color': Colors.amberAccent},
            {'day': 4, 'label': 'x 90', 'icon': Icons.diamond, 'color': Colors.amberAccent},
            {'day': 5, 'label': 'x 120', 'icon': Icons.diamond, 'color': Colors.amberAccent},
            {'day': 6, 'label': 'x 180', 'icon': Icons.diamond, 'color': Colors.amberAccent},
            {'day': 7, 'label': 'x 1 (🎁 200)', 'icon': Icons.card_giftcard, 'color': Colors.pinkAccent},
          ];
          return Dialog(
            backgroundColor: const Color(0xFF1E1E2C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Daily rewards', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                          SizedBox(height: 4),
                          Text('Sign in for 7 days to get a surprise', style: TextStyle(fontSize: 12, color: Colors.white70)),
                        ],
                      ),
                      IconButton(icon: const Icon(Icons.close, color: Colors.white70), onPressed: () => Navigator.pop(ctx)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.85,
                    ),
                    itemCount: dayRewards.length,
                    itemBuilder: (context, index) {
                      final item = dayRewards[index];
                      final dayNum = item['day'] as int;
                      final isSelected = dayNum == appState.currentStreakDay;
                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFE94057).withOpacity(0.25) : const Color(0xFF151522),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isSelected ? const Color(0xFFE94057) : Colors.white10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('day $dayNum', style: const TextStyle(fontSize: 10, color: Colors.white60)),
                            const Spacer(),
                            Icon(item['icon'] as IconData, size: 24, color: item['color'] as Color),
                            const Spacer(),
                            Text(item['label'] as String, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity, height: 48,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFE94057), Color(0xFFFF8E53)]),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                        onPressed: () {
                          appState.claimDailyReward();
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Daily reward claimed successfully! 🎁')));
                        },
                        child: Text(appState.claimedToday ? 'Claimed Today ✓' : 'Check-in', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static void showAuthorizationSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(icon: const Icon(Icons.close, color: Colors.white54, size: 20), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const Text('Authorization Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            const Text('Please open authorization setting for better experience', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.white70)),
            const SizedBox(height: 20),
            _buildAuthItem(Icons.camera_alt_outlined, 'Camera', Colors.pinkAccent),
            const SizedBox(height: 10),
            _buildAuthItem(Icons.phone_outlined, 'Phone', Colors.orangeAccent),
            const SizedBox(height: 10),
            _buildAuthItem(Icons.mic_none, 'Microphone', Colors.redAccent),
            const SizedBox(height: 10),
            _buildAuthItem(Icons.notifications_none, 'Notification', Colors.purpleAccent),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity, height: 48,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFE94057), Color(0xFFFF6B8B)]),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All permissions allowed (Camera, Phone, Mic, Notification) ✓')));
                  },
                  child: const Text('Allow all', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildAuthItem(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: const Color(0xFF151522), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white10)),
      child: Row(children: [Icon(icon, color: color, size: 20), const SizedBox(width: 14), Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500))]),
    );
  }

  static void showCallReminderDialog(BuildContext context) {
    bool callReminderOn = true;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateModal) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity, padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFE94057), Color(0xFFFF416C)]), borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    const CircleAvatar(radius: 28, backgroundColor: Colors.green, child: Icon(Icons.phone, color: Colors.white, size: 28)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Users call reminder', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        Switch(value: callReminderOn, activeColor: Colors.white, activeTrackColor: Colors.green, onChanged: (val) => setStateModal(() => callReminderOn = val)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('Turn on the call reminder and don\'t miss any call from users', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.white70)),
              const SizedBox(height: 20),
              const Row(children: [Icon(Icons.star_outline, color: Colors.amberAccent, size: 20), SizedBox(width: 10), Text('Received evaluation', style: TextStyle(color: Colors.white, fontSize: 14))]),
              const SizedBox(height: 14),
              const Row(children: [Icon(Icons.notifications_active_outlined, color: Colors.pinkAccent, size: 20), SizedBox(width: 10), Text('New message', style: TextStyle(color: Colors.white, fontSize: 14))]),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 48,
                child: DecoratedBox(
                  decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFE94057), Color(0xFFFF6B8B)]), borderRadius: BorderRadius.circular(24)),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                    onPressed: () { Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notifications & Call reminder turned on! 🔔'))); },
                    child: const Text('Turn on notifications', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showVideoCall1to1Dialog(BuildContext context, StreamerItem streamer) {
  showDialog(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.black,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: streamer.color.withOpacity(0.3),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 50, backgroundColor: streamer.color, child: Text(streamer.name[0], style: const TextStyle(fontSize: 40, color: Colors.white))),
                  const SizedBox(height: 16),
                  Text('1-to-1 Video Call with ${streamer.name}', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('${streamer.flag} ${streamer.country} • Age ${streamer.age}', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 24),
                  const Text('Connecting secure audio/video channel...', style: TextStyle(color: Colors.greenAccent, fontSize: 12)),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 40, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Video call ended')));
                  },
                  child: const Icon(Icons.call_end, color: Colors.white),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40, right: 20,
            child: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(ctx)),
          ),
        ],
      ),
    ),
  );
}
