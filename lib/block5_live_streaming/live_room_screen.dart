import 'package:flutter/material.dart';
import 'live_streamer_model.dart';
import 'live_room_header.dart';
import 'live_room_bottom_toolbar.dart';
import 'live_tools_and_gifts_helper.dart';
import 'live_ads_integration_helper.dart';

class LiveRoomScreen extends StatefulWidget {
  final LiveStreamer streamer;
  const LiveRoomScreen({super.key, required this.streamer});

  @override
  State<LiveRoomScreen> createState() => _LiveRoomScreenState();
}

class _LiveRoomScreenState extends State<LiveRoomScreen> {
  bool _isMiniScreen = false;
  int _currentIndex = 0;
  bool _isKeyboardOpen = false;
  final TextEditingController _chatController = TextEditingController();

  final List<Map<String, String>> _liveChats = [
    {'user': 'Kamyla', 'message': 'Hello! Stay and enjoy the live with me!'},
    {'user': 'guest', 'message': 'joined the room'},
  ];

  void _handleNewMessage(String msg) {
    if (msg.trim().isEmpty) return;
    setState(() {
      _liveChats.add({'user': 'You', 'message': msg});
      _chatController.clear();
      _isKeyboardOpen = false;
    });
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isMiniScreen) {
      return Stack(
        children: [
          Positioned(
            top: 80,
            right: 20,
            child: GestureDetector(
              onTap: () => setState(() => _isMiniScreen = false),
              child: Container(
                width: 130,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.pinkAccent, width: 2),
                ),
                child: Stack(
                  children: [
                    const Center(child: Icon(Icons.person, color: Colors.white54, size: 50)),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.black54,
                          child: Icon(Icons.close, color: Colors.white, size: 12),
                        ),
                      ),
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 120),
                        child: Text('Tap to Expand', style: TextStyle(color: Colors.white70, fontSize: 10)),
                      ),
                    ),
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
          PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: LiveStreamer.dummyStreamers.length,
            controller: PageController(initialPage: LiveStreamer.dummyStreamers.indexWhere((s) => s.id == widget.streamer.id).clamp(0, LiveStreamer.dummyStreamers.length - 1)),
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final currentStreamer = LiveStreamer.dummyStreamers[index];

              return Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: const Color(0xFF1D1B36),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.person, size: 150, color: Colors.white10),
                            const SizedBox(height: 10),
                            Text('Live: ${currentStreamer.name}', style: const TextStyle(color: Colors.white38, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Top Header Bar
                  Positioned(
                    top: 40,
                    left: 16,
                    right: 16,
                    child: LiveRoomHeader(
                      streamer: currentStreamer,
                      onMinimize: () => setState(() => _isMiniScreen = true),
                      onClose: () => Navigator.pop(context),
                    ),
                  ),

                  // Bottom Live Chat Feed (Strictly on the left corner with scrollable history)
                  Positioned(
                    bottom: 70,
                    left: 16,
                    right: 150,
                    child: SizedBox(
                      height: 120,
                      child: ShaderMask(
                        shaderCallback: (Rect rect) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.white],
                            stops: [0.0, 0.2],
                          ).createShader(rect);
                        },
                        blendMode: BlendMode.dstIn,
                        child: ListView.builder(
                          reverse: true,
                          itemCount: _liveChats.length,
                          itemBuilder: (context, chatIndex) {
                            final chat = _liveChats[_liveChats.length - 1 - chatIndex];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${chat['user']}: ',
                                        style: const TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: chat['message'],
                                        style: const TextStyle(color: Colors.white, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // Left Side Bottom Toolbar (Chat & Grid Menu buttons)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isKeyboardOpen = true;
                            });
                          },
                          child: Container(
                            height: 38,
                            width: 38,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(19),
                            ),
                            child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 18),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 38,
                            width: 38,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(19),
                            ),
                            child: const Icon(Icons.grid_view, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right Side Bottom Toolbar (Like, Gift, Video Call buttons)
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: SizedBox(
                      width: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Liked Streamer ❤️'), duration: Duration(milliseconds: 500)),
                              );
                            },
                            child: const CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.pinkAccent,
                              child: Icon(Icons.favorite, color: Colors.white, size: 18),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Opening Gift Panel...'), duration: Duration(seconds: 1)),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.purpleAccent]),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Icon(Icons.card_giftcard, color: Colors.white, size: 18),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Initiating Video Call...'), duration: Duration(seconds: 1)),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Icon(Icons.videocam, color: Colors.white, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Right Side Vertical Ads
                  Positioned(
                    bottom: 80,
                    right: 16,
                    child: LiveAdsIntegrationHelper.buildRightSideVerticalAds(),
                  ),
                ],
              );
            },
          ),

          // Keyboard Overlay when chat button is tapped (Matching Screenshot 2)
          if (_isKeyboardOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _isKeyboardOpen = false),
                child: Container(
                  color: Colors.black54,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    color: const Color(0xFF1E1E2C),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _chatController,
                            autofocus: true,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: 'Enter something...',
                              hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                              border: InputBorder.none,
                            ),
                            onSubmitted: _handleNewMessage,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send, color: Colors.pinkAccent),
                          onPressed: () => _handleNewMessage(_chatController.text),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
