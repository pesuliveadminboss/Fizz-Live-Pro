import 'package:flutter/material.dart';
import '../block3_hot_tab/core_data.dart';

void showVideoCall1to1Dialog(BuildContext context, StreamerItem? streamer) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF1E1E2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: const [
          Icon(Icons.videocam, color: Colors.pinkAccent),
          SizedBox(width: 8),
          Text('1-to-1 Video Call', style: TextStyle(color: Colors.white, fontSize: 18)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Color(0xFFE94057),
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            'Connecting to ${streamer?.name ?? "Streamer"}...',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Rate: 1800 Gems / min',
            style: TextStyle(color: Colors.amber, fontSize: 12),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(ctx),
                icon: const CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.call_end, color: Colors.white),
                ),
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Video call connected via ZegoCloud! 📹')),
                  );
                  Navigator.pop(ctx);
                },
                icon: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.call, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
