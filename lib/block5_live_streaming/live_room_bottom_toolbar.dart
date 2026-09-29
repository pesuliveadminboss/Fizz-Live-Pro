import 'package:flutter/material.dart';

class LiveRoomBottomToolbar extends StatelessWidget {
  final bool isFollowing;
  final VoidCallback onToggleFollow;
  final VoidCallback onOpenTools;
  final VoidCallback onVideoCall;

  const LiveRoomBottomToolbar({
    super.key,
    required this.isFollowing,
    required this.onToggleFollow,
    required this.onOpenTools,
    required this.onVideoCall,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('Say something...', style: TextStyle(color: Colors.white54, fontSize: 13)),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onToggleFollow,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: isFollowing ? Colors.black : Colors.pinkAccent,
            child: Icon(
              isFollowing ? Icons.check : Icons.favorite,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onOpenTools,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.menu, color: Colors.white, size: 20),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onVideoCall,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFEC4899),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('Video Call', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ),
      ],
    );
  }
}
