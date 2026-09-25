import 'package:flutter/material.dart';
import 'core_data.dart';
import 'streamer_profile_screen.dart';

class HotTabGridScreen extends StatelessWidget {
  const HotTabGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Hide offline streamers from Hot Tab grid
    final activeStreamers = kAllStreamers.where((s) => s.status != 'offline').toList();

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: activeStreamers.length,
      itemBuilder: (context, index) {
        final streamer = activeStreamers[index];
        Color statusColor = streamer.status == 'live' ? const Color(0xFFE94057) : (streamer.status == 'party' ? Colors.blue : Colors.green);
        String statusText = streamer.status.toUpperCase();

        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => StreamerProfileScreen(streamer: streamer)));
          },
          child: Container(
            decoration: BoxDecoration(color: const Color(0xFF1E1E2C), borderRadius: BorderRadius.circular(16)),
            child: Stack(
              children: [
                const Center(child: Icon(Icons.person, size: 60, color: Colors.white24)),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(8)),
                    child: Text(statusText, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(streamer.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                          Text('${streamer.flag} ${streamer.country}', style: const TextStyle(color: Colors.white70, fontSize: 10)),
                        ],
                      ),
                      const CircleAvatar(radius: 14, backgroundColor: Color(0xFFE94057), child: Icon(Icons.videocam, size: 14, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
