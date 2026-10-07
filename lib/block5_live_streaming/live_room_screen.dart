import 'package:flutter/material.dart';
import 'live_streamer_model.dart';
import 'live_room_header.dart';
import 'live_room_bottom_toolbar.dart';
import 'live_tools_and_gifts_helper.dart';
import 'live_ads_integration_helper.dart';
import 'streamer_follow_manager.dart';

class LiveRoomScreen extends StatefulWidget {
  final LiveStreamer streamer;
  const LiveRoomScreen({super.key, required this.streamer});

  @override
  State<LiveRoomScreen> createState() => _LiveRoomScreenState();
}

class _LiveRoomScreenState extends State<LiveRoomScreen> {
  bool _isMiniScreen = false;
  Offset _miniScreenPosition = const Offset(20, 100);
  int _currentIndex = 0;
  bool _isKeyboardOpen = false;
  bool _showFollowPopup = true;

  // Dynamic Viewers List mapping for live rooms
  final Map<int, List<String>> _roomViewersMap = {
    0: ['Guest_Llw6JP', 'PariUser_99'],
    1: ['User_TamilNadu', 'Rahul_Live', 'Anitha_2026'],
    2: ['Kavi_Speaker', 'Deepak_Raj'],
  };

  final TextEditingController _chatController = TextEditingController();

  final List<Map<String, String>> _liveChats = [
    {
      'user': 'System',
      'message': 'pornographic, vulgar, violent and under age is forbidden to appear in the live. You\'ll be punished seriously once you violate the rules!',
      'type': 'warning'
    },
    {'user': 'PARIHUB', 'message': '❤️ Stay and chat with me!'},
    {'user': 'Guest_Llw6JP', 'message': 'joined the room'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _showFollowPopup = true;
      });
    });
  }

  void _handleNewMessage(String msg) {
    if (msg.trim().isEmpty) return;
    setState(() {
      _liveChats.add({'user': 'You', 'message': msg, 'type': 'chat'});
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
    final currentStreamer = LiveStreamer.dummyStreamers[_currentIndex];
    final currentViewers = _roomViewersMap[_currentIndex] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      body: Stack(
        children: [
          PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: LiveStreamer.dummyStreamers.length,
            controller: PageController(
              initialPage: LiveStreamer.dummyStreamers
                  .indexWhere((s) => s.id == widget.streamer.id)
                  .clamp(0, LiveStreamer.dummyStreamers.length - 1),
            ),
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final streamerItem = LiveStreamer.dummyStreamers[index];
              final roomViewers = _roomViewersMap[index] ?? [];
              final followNotifier = StreamerFollowManager().getFollowNotifier(streamerItem.name);

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
                            Text('Live: ${streamerItem.name}', style: const TextStyle(color: Colors.white38, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Top Header Bar with Dynamic Viewers Count & List Popup
                  Positioned(
                    top: 40,
                    left: 16,
                    right: 16,
                    child: LiveRoomHeader(
                      streamer: streamerItem,
                      onMinimize: () => setState(() => _isMiniScreen = true),
                      onClose: () => Navigator.pop(context),
                      viewerCount: roomViewers.length,
                      viewersList: roomViewers,
                    ),
                  ),

                  // Bottom Scrollable Live Chat Feed
                  Positioned(
                    bottom: 70,
                    left: 16,
                    right: 150,
                    child: SizedBox(
                      height: 130,
                      child: ListView.builder(
                        reverse: false,
                        itemCount: _liveChats.length,
                        itemBuilder: (context, chatIndex) {
                          final chat = _liveChats[chatIndex];
                          final isWarning = chat['type'] == 'warning';

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              decoration: BoxDecoration(
                                color: isWarning ? Colors.amber.withOpacity(0.2) : Colors.black26,
                                borderRadius: BorderRadius.circular(10),
                                border: isWarning ? Border.all(color: Colors.amber.withOpacity(0.5)) : null,
                              ),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: isWarning ? 'Room: ' : '${chat['user']}: ',
                                      style: TextStyle(
                                        color: isWarning ? Colors.amberAccent : Colors.amber,
                                        fontSize: isWarning ? 8 : 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: chat['message'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isWarning ? 8 : 11,
                                      ),
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

                  // Left Side Bottom Toolbar
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: LiveRoomBottomToolbar(
                      onOpenTools: () {},
                      onVideoCall: () {},
                      onGiftTap: () {},
                      onLikeTap: () {},
                      onSendMessage: _handleNewMessage,
                    ),
                  ),

                  // Right Side Bottom Toolbar
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
                              StreamerFollowManager().toggleFollow(streamerItem.name);
                              final status = StreamerFollowManager().isFollowing(streamerItem.name);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(status ? 'Successfully Followed Streamer ❤️' : 'Unfollowed Streamer'),
                                  duration: const Duration(milliseconds: 500),
                                ),
                              );
                            },
                            child: ValueListenableBuilder<bool>(
                              valueListenable: followNotifier,
                              builder: (context, isFollowing, child) {
                                return CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.pinkAccent,
                                  child: Icon(
                                    isFollowing ? Icons.favorite : Icons.favorite_border,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                );
                              },
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

          // Follow & Gift Popup Card
          if (_showFollowPopup)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _showFollowPopup = false),
                child: Container(
                  color: Colors.black54,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 280,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E2C),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.pinkAccent.withOpacity(0.5)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.pinkAccent,
                            child: Icon(Icons.person, size: 40, color: Colors.white),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Follow ${currentStreamer.name} and Send Free Gift',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pinkAccent,
                              minimumSize: const Size(double.infinity, 44),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                            ),
                            onPressed: () {
                              StreamerFollowManager().setFollowing(currentStreamer.name, true);
                              setState(() {
                                _showFollowPopup = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Successfully Followed & Gift Sent!')),
                              );
                            },
                            child: const Text('Follow and send gifts', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Floating & Draggable Mini-Screen Overlay
          if (_isMiniScreen)
            Positioned(
              left: _miniScreenPosition.dx,
              top: _miniScreenPosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _miniScreenPosition += details.delta;
                  });
                },
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 140,
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.pinkAccent, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: () => setState(() => _isMiniScreen = false),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.person, color: Colors.white54, size: 40),
                                const SizedBox(height: 8),
                                Text(
                                  currentStreamer.name,
                                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                const Text('Tap to Expand', style: TextStyle(color: Colors.white70, fontSize: 9)),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.black54,
                              child: Icon(Icons.close, color: Colors.white, size: 14),
                            ),
                          ),
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
