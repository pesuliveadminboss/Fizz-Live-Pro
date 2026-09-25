import 'package:flutter/material.dart';
import 'chat_and_warning_widget.dart';
import 'viewer_list_dialog.dart';
import 'zego_video_call.dart';

class LiveRoomScreen extends StatefulWidget {
  final String streamerName;

  const LiveRoomScreen({super.key, required this.streamerName});

  @override
  State<LiveRoomScreen> createState() => _LiveRoomScreenState();
}

class _LiveRoomScreenState extends State<LiveRoomScreen> {
  bool _isFollowing = false;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: 5, // Mock multiple live streams for vertical reels scrolling
        itemBuilder: (context, index) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Background Stream Video Simulation
              Container(
                color: Colors.primaries[index % Colors.primaries.length].withOpacity(0.3),
                child: Center(
                  child: Text(
                    '${widget.streamerName} Live #${index + 1}',
                    style: const TextStyle(color: Colors.white24, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // Gradient Overlay for readability
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black54, Colors.transparent, Colors.black87],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // UI Overlays
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top Header (Streamer Profile & Synced Hearts + Viewer Count + PiP Close X)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Streamer Profile & Synced Pink/Black Heart
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.pinkAccent,
                                  child: Icon(Icons.person, size: 18, color: Colors.white),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.streamerName,
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                    const Text(
                                      'ID: 7204742',
                                      style: TextStyle(color: Colors.white70, fontSize: 9),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isFollowing = !_isFollowing;
                                    });
                                  },
                                  child: Icon(
                                    _isFollowing ? Icons.favorite : Icons.favorite_border,
                                    color: _isFollowing ? Colors.pinkAccent : Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Top Right: Viewer Count & Close/PiP Button
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => showViewerListDialog(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.remove_red_eye, color: Colors.white70, size: 14),
                                      SizedBox(width: 4),
                                      Text('5', style: TextStyle(color: Colors.white, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.white),
                                onPressed: () {
                                  // PiP Minimize or Close Room
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Bottom Area (Warning banner, chat messages scrolling up, and action buttons)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ChatAndWarningWidget(),
                          const SizedBox(height: 12),
                          // Bottom Actions: Gift, Follow Heart, 1-to-1 Video Call
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FloatingActionButton(
                                mini: true,
                                backgroundColor: Colors.purpleAccent,
                                child: const Icon(Icons.card_giftcard, color: Colors.white),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Gift sent to streamer! 🎁')),
                                  );
                                },
                              ),
                              const SizedBox(width: 10),
                              FloatingActionButton(
                                mini: true,
                                backgroundColor: Colors.pinkAccent,
                                child: Icon(_isFollowing ? Icons.favorite : Icons.favorite_border, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    _isFollowing = !_isFollowing;
                                  });
                                },
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE94057),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                ),
                                icon: const Icon(Icons.videocam, color: Colors.white, size: 18),
                                label: const Text('Video Call', style: TextStyle(color: Colors.white, fontSize: 12)),
                                onPressed: () {
                                  showVideoCall1to1Dialog(context, null);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
