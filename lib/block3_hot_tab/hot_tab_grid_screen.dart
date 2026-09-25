import 'package:flutter/material.dart';
import 'core_data.dart';
import 'streamer_profile_screen.dart';

class HotTabGridScreen extends StatelessWidget {
  const HotTabGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.78,
      ),
      itemCount: kMockStreamers.length,
      itemBuilder: (context, index) {
        final streamer = kMockStreamers[index];
        Color statusBg = Colors.green;
        String statusText = 'Online';
        if (streamer.status == 'live') {
          statusBg = const Color(0xFFE94057);
          statusText = 'Live';
        } else if (streamer.status == 'party') {
          statusBg = Colors.blueAccent;
          statusText = 'Party';
        }

        return GestureDetector(
          onTap: () {
            // Clicking streamer box opens Streamer Profile Page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => StreamerProfileScreen(streamer: streamer)),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFF1E1E2C),
              border: Border.all(color: Colors.white12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: streamer.color.withOpacity(0.4),
                    child: Center(
                      child: Text(
                        streamer.name[0],
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white24),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(10)),
                          child: Text(statusText, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                        const SizedBox(width: 4),
                        Text(streamer.flag, style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(streamer.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
                          Text('${streamer.country} • ${streamer.age}', style: const TextStyle(color: Colors.white70, fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
