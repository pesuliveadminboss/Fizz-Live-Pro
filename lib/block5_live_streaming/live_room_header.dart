import 'package:flutter/material.dart';
import 'live_streamer_model.dart';
import 'streamer_profile_popup.dart';

class LiveRoomHeader extends StatefulWidget {
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
  State<LiveRoomHeader> createState() => _LiveRoomHeaderState();
}

class _LiveRoomHeaderState extends State<LiveRoomHeader> {
  int _viewerCount = 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            // Profile Capsule with Follow Heart inside
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (_) => StreamerProfilePopup(streamer: widget.streamer),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.pinkAccent,
                      backgroundImage: widget.streamer.imageUrl.isNotEmpty ? NetworkImage(widget.streamer.imageUrl) : null,
                      child: widget.streamer.imageUrl.isEmpty ? const Icon(Icons.person, color: Colors.white, size: 14) : null,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.streamer.name,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.favorite, color: Colors.pinkAccent, size: 14),
                  ],
                ),
              ),
            ),
            const Spacer(),
            // Viewer Count and 'X' Minimize/Close Button
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$_viewerCount',
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: widget.onMinimize,
                  child: const Text(
                    '×',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('Lv7', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.withOpacity(0.6)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.local_fire_department, color: Colors.amber, size: 10),
                  SizedBox(width: 2),
                  Text('21 Hourly Rank', style: TextStyle(color: Colors.white, fontSize: 9)),
                ],
              ),
            ),
            const Spacer(),
            const Text('More L...', style: TextStyle(color: Colors.white70, fontSize: 10)),
          ],
        ),
      ],
    );
  }
}
