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
  int _viewerCount = 3;
  final List<Map<String, String>> _viewersList = [
    {'name': 'Rahul Sharma', 'age': '24', 'country': 'India'},
    {'name': 'Pooja Verma', 'age': '22', 'country': 'India'},
    {'name': 'John Doe', 'age': '27', 'country': 'USA'},
  ];

  void _showViewersPopup() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color(0xFF1D1B36),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Live Viewers List',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: _viewersList.length,
                  itemBuilder: (context, index) {
                    final viewer = _viewersList[index];
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.pinkAccent,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(viewer['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text('Age: ${viewer['age']} | ${viewer['country']}', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                      trailing: const Icon(Icons.favorite, color: Colors.pinkAccent, size: 16),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
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
                GestureDetector(
                  onTap: _showViewersPopup,
                  child: Row(
                    children: [
                      const Icon(Icons.remove_red_eye_outlined, color: Colors.white70, size: 12),
                      const SizedBox(width: 2),
                      Text(
                        '$_viewerCount',
                        style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.picture_in_picture_outlined, color: Colors.white, size: 20),
          onPressed: widget.onMinimize,
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 20),
          onPressed: widget.onClose,
        ),
      ],
    );
  }
}
