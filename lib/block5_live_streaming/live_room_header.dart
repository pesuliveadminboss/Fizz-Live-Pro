import 'package:flutter/material.dart';
import 'live_streamer_model.dart';
import 'streamer_profile_popup.dart';

class LiveRoomHeader extends StatelessWidget {
  final LiveStreamer streamer;
  final VoidCallback onMinimize;
  final VoidCallback onClose;

  const LiveRoomHeader({
    super.key,
    required this.streamer,
    required this.onMinimize,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (_) => StreamerProfilePopup(streamer: streamer),
            );
          },
          child: const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.pinkAccent,
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              streamer.name,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const Text(
              '24.8k 👁️',
              style: TextStyle(color: Colors.white60, fontSize: 10),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          icon: const Text('2x', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          onPressed: onMinimize,
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: onClose,
        ),
      ],
    );
  }
}
