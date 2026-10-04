import 'package:flutter/material.dart';
import 'live_streamer_model.dart';
import '../block4_private_chat/profile_navigation_bridge.dart';

class LiveRoomHeader extends StatefulWidget {
  final LiveStreamer streamer;
  final VoidCallback onMinimize;
  final VoidCallback onClose;
  final bool isFollowing;
  final VoidCallback onToggleFollow;

  const LiveRoomHeader({
    super.key,
    required this.streamer,
    required this.onMinimize,
    required this.onClose,
    required this.isFollowing,
    required this.onToggleFollow,
  });

  @override
  State<LiveRoomHeader> createState() => _LiveRoomHeaderState();
}

class _LiveRoomHeaderState extends State<LiveRoomHeader> {
  final int _viewerCount = 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                ProfileNavigationBridge.openStreamerProfile(
                  context: context,
                  streamerId: '340301087',
                  streamerName: widget.streamer.name,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.pinkAccent,
                      child: Icon(Icons.person, color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.streamer.name,
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: widget.onToggleFollow,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.black54,
                        child: Icon(
                          widget.isFollowing ? Icons.favorite : Icons.favorite_border,
                          color: widget.isFollowing ? Colors.pinkAccent : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
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
      ],
    );
  }
}
