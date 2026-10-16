import 'package:flutter/material.dart';
import 'dart:ui';

class StreamerBlurOverlay extends StatelessWidget {
  final String streamerName;
  final String avatarUrl;

  const StreamerBlurOverlay({
    super.key,
    required this.streamerName,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blurred background effect for busy status
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
            child: Container(
              color: Colors.black.withOpacity(0.65),
            ),
          ),
        ),
        // Center circular avatar and status badge
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.pinkAccent, width: 3),
                ),
                child: const CircleAvatar(
                  radius: 38,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 45, color: Colors.white),
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Text(
                  "I'll back soon...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
