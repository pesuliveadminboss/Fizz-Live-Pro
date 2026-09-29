import 'package:flutter/material.dart';
import 'live_streamer_model.dart';

class StreamerProfilePopup extends StatelessWidget {
  final LiveStreamer streamer;

  const StreamerProfilePopup({super.key, required this.streamer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF1D1B36),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundColor: Colors.pinkAccent,
            child: Icon(Icons.person, size: 45, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            streamer.name,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            streamer.bio,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Following ${streamer.name}'), duration: const Duration(seconds: 1)),
                  );
                },
                icon: const Icon(Icons.favorite, color: Colors.white),
                label: const Text('Follow', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.pinkAccent)),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.card_giftcard, color: Colors.pinkAccent),
                label: const Text('Send Gift', style: TextStyle(color: Colors.pinkAccent)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
