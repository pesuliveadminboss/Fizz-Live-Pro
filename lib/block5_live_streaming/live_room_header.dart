import 'package:flutter/material.dart';
import 'live_streamer_model.dart';
import 'streamer_profile_popup.dart';

class LiveRoomHeader extends StatefulWidget {
  final LiveStreamer streamer;
  final VoidCallback onClose;

  const LiveRoomHeader({
    super.key,
    required this.streamer,
    required this.onClose,
  });

  @override
  State<LiveRoomHeader> createState() => _LiveRoomHeaderState();
}

class _LiveRoomHeaderState extends State<LiveRoomHeader> {
  int _viewerCount = 1;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _viewerCount = 5);
    });
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) setState(() => _viewerCount = 14);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
                const SizedBox(width: 8),
                const Icon(Icons.remove_red_eye_outlined, color: Colors.white70, size: 12),
                const SizedBox(width: 2),
                Text(
                  '$_viewerCount',
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 20),
          onPressed: widget.onClose,
        ),
      ],
    );
  }
}
