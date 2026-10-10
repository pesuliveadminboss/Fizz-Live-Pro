import 'package:flutter/material.dart';
import 'live_streamer_model.dart';
import 'live_room_header.dart';
import 'live_room_bottom_toolbar.dart';
import 'live_tools_and_gifts_helper.dart';
import 'live_ads_integration_helper.dart';
import 'streamer_follow_manager.dart';
import 'live_streamer_overlay_manager.dart';

class LiveRoomScreen extends StatefulWidget {
  final LiveStreamer streamer;
  const LiveRoomScreen({super.key, required this.streamer});

  @override
  State<LiveRoomScreen> createState() => _LiveRoomScreenState();
}

class _LiveRoomScreenState extends State<LiveRoomScreen> {
  int _currentIndex = 0;
  bool _isKeyboardOpen = false;

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

                  // Top Header Bar: Minimize triggers floating mini player & pops room
                  Positioned(
                    top: 40,
                    left: 16,
                    right: 16,
                    child: LiveRoomHeader(
                      streamer: streamerItem,
                      onMinimize: () {
                        LiveStreamerOverlayManager.showFloatingMiniPlayer(
                          context: context,
                          streamer: streamerItem,
                        );
                        Navigator.pop(context);
                      },
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
        ],
      ),
    );
  }
}
