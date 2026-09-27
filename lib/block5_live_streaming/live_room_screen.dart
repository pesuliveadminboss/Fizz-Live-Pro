import 'package:flutter/material.dart';

class LiveRoomScreen extends StatefulWidget {
  final String streamerName;
  const LiveRoomScreen({super.key, required this.streamerName});

  @override
  State<LiveRoomScreen> createState() => _LiveRoomScreenState();
}

class _LiveRoomScreenState extends State<LiveRoomScreen> {
  bool _isFollowing = false;
  bool _isMiniScreen = false;
  final List<Map<String, String>> _liveChats = [
    {'user': 'Maryam ❤️', 'message': 'Hi! Thanks for joining my live, feel free to talk with me'},
    {'user': 'guest', 'message': 'joined the room'},
  ];

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFollowing ? 'Following ${widget.streamerName}' : 'Unfollowed ${widget.streamerName}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isMiniScreen) {
      return Stack(
        children: [
          Positioned(
            top: 100,
            right: 20,
            child: GestureDetector(
              onTap: () => setState(() => _isMiniScreen = false),
              child: Container(
                width: 120,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.pinkAccent, width: 2),
                ),
                child: Stack(
                  children: [
                    const Center(child: Icon(Icons.person, color: Colors.white54, size: 40)),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, color: Colors.white, size: 16),
                      ),
                    ),
                    const Center(child: Text('Tap to Expand', style: TextStyle(color: Colors.white70, fontSize: 10))),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      body: Stack(
        children: [
          // Background Video / Streamer Placeholder
          Positioned.fill(
            child: Container(
              color: const Color(0xFF1D1B36),
              child: const Center(
                child: Icon(Icons.person, size: 150, color: Colors.white10),
              ),
            ),
          ),

          // Top Header Area
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.pinkAccent,
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.streamerName,
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
                  icon: const Text('2 x', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  onPressed: () => setState(() => _isMiniScreen = true),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Follow Banner Below Header
          Positioned(
            top: 100,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Text(
                    'Follow ${widget.streamerName} and Send Free Gift',
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _toggleFollow,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: _isFollowing ? Colors.black : Colors.pinkAccent,
                      child: Icon(
                        _isFollowing ? Icons.check : Icons.favorite,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Chat & Toolbar Area (Properly positioned at bottom)
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.withOpacity(0.5)),
                  ),
                  child: const Text(
                    'Pornographic, vulgar, violent and under age is forbidden to appear in the live. You\'ll be punished seriously once you violate the rules!',
                    style: TextStyle(color: Colors.amberAccent, fontSize: 10),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 90,
                  child: ListView.builder(
                    itemCount: _liveChats.length,
                    itemBuilder: (context, index) {
                      final chat = _liveChats[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${chat['user']}: ',
                                style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: chat['message'],
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Row(
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
                      onTap: _toggleFollow,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: _isFollowing ? Colors.black : Colors.pinkAccent,
                        child: Icon(
                          _isFollowing ? Icons.check : Icons.favorite,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEC4899),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('Video Call', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
