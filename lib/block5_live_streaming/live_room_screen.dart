import 'package:flutter/material.dart';
import 'live_streamer_model.dart';
import 'live_room_header.dart';
import 'live_room_bottom_toolbar.dart';
import 'live_tools_and_gifts_helper.dart';
import 'live_ads_integration_helper.dart';
import 'streamer_follow_manager.dart';
import 'live_streamer_overlay_manager.dart';
import '../block6_party_room/party_room_overlay_manager.dart';
import 'gift_bottom_sheet.dart';
import '../block7_zego_integration/zego_video_call_service.dart'; // 👉 Correct Import Path for Zego Video Call Service

class LiveRoomScreen extends StatefulWidget {
  final LiveStreamer streamer;
  const LiveRoomScreen({super.key, required this.streamer});

  @override
  State<LiveRoomScreen> createState() => _LiveRoomScreenState();
}

class _LiveRoomScreenState extends State<LiveRoomScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isKeyboardOpen = false;
  String? activeGiftEffect;

  late AnimationController _animController;
  late Animation<double> _animProgress;

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
    LiveStreamerOverlayManager.hideOverlay();
    PartyRoomOverlayManager.hideOverlay();

    _animController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animProgress = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
  }

  void _handleNewMessage(String msg) {
    if (msg.trim().isEmpty) return;
    setState(() {
      _liveChats.add({'user': 'You', 'message': msg, 'type': 'chat'});
      _chatController.clear();
      _isKeyboardOpen = false;
    });
  }

  void _triggerGiftEffect(String giftName, int quantity) {
    setState(() {
      activeGiftEffect = '$giftName x$quantity';
    });
    _animController.forward(from: 0.0);

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          activeGiftEffect = null;
        });
      }
    });
  }

  void _showGiftBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GiftBottomSheet(
          onSendGift: (giftName, quantity) {
            _triggerGiftEffect(giftName, quantity);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _chatController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

                  // Top Header Bar
                  Positioned(
                    top: 40,
                    left: 16,
                    right: 16,
                    child: LiveRoomHeader(
                      streamer: streamerItem,
                      onMinimize: () {
                        Navigator.pop(context);
                        LiveStreamerOverlayManager.showFloatingMiniPlayer(
                          context: context,
                          streamer: streamerItem,
                        );
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
                                      text: chat['message'] ?? '',
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
                      onVideoCall: () {
                        ZegoVideoCallService.startRealTimeVideoCall(
                          context,
                          receiverName: streamerItem.name,
                        );
                      },
                      onGiftTap: () => _showGiftBottomSheet(context),
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
                            onTap: () => _showGiftBottomSheet(context),
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
                              ZegoVideoCallService.startRealTimeVideoCall(
                                context,
                                receiverName: streamerItem.name,
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

          // 👉 Cinematic Gift Animation Overlay Renderer (Perfect Center)
          if (activeGiftEffect != null)
            AnimatedBuilder(
              animation: _animProgress,
              builder: (context, child) {
                final String nameLower = activeGiftEffect!.toLowerCase();
                IconData giftIcon = Icons.card_giftcard;

                if (nameLower.contains('rocket') || nameLower.contains('starship') || nameLower.contains('jet')) {
                  giftIcon = Icons.rocket_launch;
                } else if (nameLower.contains('car') || nameLower.contains('exclusive') || nameLower.contains('cruise')) {
                  giftIcon = Icons.directions_car;
                } else if (nameLower.contains('flower') || nameLower.contains('rose') || nameLower.contains('ring')) {
                  giftIcon = Icons.local_florist;
                } else if (nameLower.contains('airplane') || nameLower.contains('air travel')) {
                  giftIcon = Icons.airplanemode_active;
                }

                return Center(
                  child: Transform.scale(
                    scale: 0.6 + (_animProgress.value * 0.8),
                    child: Opacity(
                      opacity: (1.0 - _animProgress.value).clamp(0.2, 1.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.amberAccent, width: 2.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amberAccent.withOpacity(0.8),
                              blurRadius: 30,
                              spreadRadius: 10,
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(giftIcon, color: Colors.amberAccent, size: 40),
                            const SizedBox(width: 14),
                            Text(
                              activeGiftEffect!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
