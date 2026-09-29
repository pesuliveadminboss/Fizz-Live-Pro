import 'package:flutter/material.dart';
import 'live_streamer_model.dart';
import 'live_room_screen.dart';

class LiveStreamerGridCard extends StatelessWidget {
  final LiveStreamer streamer;

  const LiveStreamerGridCard({super.key, required this.streamer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LiveRoomScreen(streamer: streamer),
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
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    streamer.name,
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '👁️ ${streamer.viewers}',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
