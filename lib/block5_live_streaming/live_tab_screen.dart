import 'package:flutter/material.dart';
import 'live_room_screen.dart';

class LiveTabScreen extends StatelessWidget {
  const LiveTabScreen({super.key});

  final List<Map<String, String>> liveStreamers = const [
    {'name': 'sara', 'viewers': '1.2k', 'tag': 'Live', 'image': 'assets/sara.png'},
    {'name': 'niki', 'viewers': '850', 'tag': 'Live', 'image': 'assets/niki.png'},
    {'name': 'tasty', 'viewers': '3.4k', 'tag': 'Live', 'image': 'assets/tasty.png'},
    {'name': 'duniya', 'viewers': '2.1k', 'tag': 'Live', 'image': 'assets/duniya.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemCount: liveStreamers.length,
          itemBuilder: (context, index) {
            final streamer = liveStreamers[index];
            return GestureDetector(
              onTap: () {
                // Clicking any live card opens the Live Room Screen directly
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LiveRoomScreen(streamerName: streamer['name']!),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1D1B36),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Stack(
                  children: [
                    // Streamer Photo Placeholder
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          color: Colors.white10,
                          child: const Center(
                            child: Icon(Icons.person, size: 60, color: Colors.white24),
                          ),
                        ),
                      ),
                    ),
                    // Live Tag & Viewers Count
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('🔴 LIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    // Streamer Name & Info at Bottom
                    Positioned(
                      bottom: 8,
                      left: 8,
                      right: 8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            streamer['name']!,
                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '👁️ ${streamer['viewers']}',
                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
