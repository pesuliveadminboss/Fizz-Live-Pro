import 'package:flutter/material.dart';
import 'live_streamer_model.dart';
import '../block4_private_chat/profile_navigation_bridge.dart';

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
  bool _isFollowing = false;
  final int _viewerCount = 2;

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFollowing ? 'Following ${widget.streamer.name}' : 'Unfollowed ${widget.streamer.name}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            // Profile Capsule: Navigates using ProfileNavigationBridge to Full Profile & Private Chat
            GestureDetector(
              onTap: () {
                ProfileNavigationBridge.openStreamerProfile(
                  context: context,
                  streamerId: '340301087',
                  streamerName: widget.streamer.name,
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
                    const CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.pinkAccent,
                      child: Icon(Icons.person, color: Colors.white, size: 14),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.streamer.name,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: _toggleFollow,
                      child: Icon(
                        _isFollowing ? Icons.favorite : Icons.favorite_border,
                        color: _isFollowing ? Colors.pinkAccent : Colors.white70,
                        size: 16,
                      ),
                    ),
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
