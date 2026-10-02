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

  final List<Map<String, String>> _liveChats = [
    {'user': 'Cute Princess', 'message': '@mystery too.... Hey, glad you\'re here!'},
    {'user': 'guest', 'message': 'joined the room'},
  ];

  void _handleNewMessage(String msg) {
    setState(() {
      _liveChats.add({'user': 'You', 'message': msg});
    });
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
      body: PageView.builder(
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

              // Bottom Warning Box & Narrow Chat Feed strictly aligned to the left corner with reduced width
              Positioned(
                bottom: 20,
                left: 16,
                right: 180, // Narrowed further so warning and chat stay strictly on the left side
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.amber.withOpacity(0.5)),
                      ),
                      child: const Text(
                        'pornographic, vulgar, violent and under age is forbidden in live.',
                        style: TextStyle(color: Colors.amberAccent, fontSize: 7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 60,
                      child: ListView.builder(
                        itemCount: _liveChats.length,
                        itemBuilder: (context, chatIndex) {
                          final chat = _liveChats[chatIndex];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1.0),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${chat['user']}: ',
                                    style: const TextStyle(color: Colors.amber, fontSize: 9, fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: chat['message'],
                                    style: const TextStyle(color: Colors.white, fontSize: 9),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Left Side Bottom Toolbar (Chat & Grid Menu buttons aligned strictly to the left corner)
              Positioned(
                bottom: 20,
                left: 16,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Triggers chat input
                      },
                      child: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 16),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(Icons.grid_view, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),

              // Right Side Bottom Toolbar (Like, Gift, Video Call buttons strictly pinned to the right corner)
              Positioned(
                bottom: 20,
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
                          radius: 16,
                          backgroundColor: Colors.pinkAccent,
                          child: Icon(Icons.favorite, color: Colors.white, size: 16),
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
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.purpleAccent]),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.card_giftcard, color: Colors.white, size: 16),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.videocam, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Right Side Vertical Ads placed right above bottom area
              Positioned(
                bottom: 80,
                right: 16,
                child: LiveAdsIntegrationHelper.buildRightSideVerticalAds(),
              ),
            ],
          );
        },
      ),
    );
  }
}
