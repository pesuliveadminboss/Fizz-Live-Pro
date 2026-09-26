import 'package:flutter/material.dart';

class ProfileInteractionHandler {
  static void toggleLike(BuildContext context, dynamic streamer, VoidCallback onUpdate) {
    streamer.isLiked = !streamer.isLiked;
    onUpdate();

    String message = streamer.isLiked ? 'Following' : 'Unfollowing';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF1D1B36),
      ),
    );
  }

  static void startVideoCall(BuildContext context, String streamerName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1D1B36),
        title: Text('1-to-1 Video Call with $streamerName', style: const TextStyle(color: Colors.white, fontSize: 16)),
        content: const Text(
          'Video call rate: 1800 coins / min.\nConnecting to secure ZegoCloud stream...',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF97316)),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Connecting video call...')),
              );
            },
            child: const Text('Start Call', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
