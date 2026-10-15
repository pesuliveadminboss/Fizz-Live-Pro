import 'party_room_theme_helper.dart';
import 'package:flutter/material.dart';
import '../block3_hot_tab/streamer_profile_screen.dart';
import '../block3_hot_tab/streamer_profile_model.dart';
import '../block4_private_chat/private_chat_screen.dart';
import '../block5_live_streaming/streamer_follow_manager.dart';
import '../block5_live_streaming/live_streamer_overlay_manager.dart';
import 'room_viewers_screen.dart';
import 'gift_bottom_sheet.dart';
import 'party_room_minimize_helper.dart';
import 'party_room_overlay_manager.dart';

class PartyRoomScreen extends StatefulWidget {
  final dynamic room;

  const PartyRoomScreen({
    super.key,
    this.room,
  });

  @override
  State<PartyRoomScreen> createState() => _PartyRoomScreenState();
}

class _PartyRoomScreenState extends State<PartyRoomScreen> with TickerProviderStateMixin {
  bool isMinimized = false;
  Offset floatingOffset = const Offset(20, 100);
  final TextEditingController _messageController = TextEditingController();

  final String streamerKey = 'Alsha Live';
  String roomTitle = 'Alsha Party Room';
  String audienceMicMode = 'Free';
  String selectedTheme = 'Candy Fiesta';

  bool isMuted = false;
  String? activeGiftEffect;
  
  late AnimationController _animController;
  late Animation<double> _animProgress;

  final List<Map<String, String>> chatMessages = [
    {"user": "System", "text": "Welcome to Party Room! Keep it clean and respectful."},
    {"user": "Raj Shukla", "text": "Nice to meet you! Grab the mic."},
    {"user": "System", "text": "Karthik Kumar joined the Party Room 🚀"},
  ];

  final List<Map<String, String>> roomViewers = [
    {"name": "Raj Shukla", "status": "Active Listener"},
    {"name": "Alsha Live (Host)", "status": "Broadcaster"},
    {"name": "Karthik Kumar", "status": "Joined via For You"},
    {"name": "Priya Ramesh", "status": "Active Listener"},
    {"name": "Suresh Babu", "status": "Active Listener"},
  ];

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  final List<Map<String, dynamic>> voiceSeats = List.generate(10, (index) => {
        'index': index + 1,
        'name': index == 0 ? 'Host' : 'User ${index + 1}',
        'isSpeaking': index == 1 || index == 4,
        'isMuted': false,
      });

  @override
  void initState() {
    super.initState();
    PartyRoomOverlayManager.hideOverlay();
    LiveStreamerOverlayManager.hideOverlay();

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 2.0, end: 6.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _animController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animProgress = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _glowController.dispose();
    _animController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _toggleMute() {
    setState(() {
      isMuted = !isMuted;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isMuted ? 'Mic Muted 🔇' : 'Mic Unmuted 🎙️'),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  void _openViewersScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoomViewersScreen(viewers: roomViewers),
      ),
    );
    setState(() {});
  }

  void _openFullHostProfile(BuildContext context) async {
    final streamerModel = StreamerProfileModel(
      name: 'Alsha Live',
      id: streamerKey,
      country: 'India',
      flag: '🇮🇳',
      age: 22,
      status: 'Online',
      intro: 'Welcome to my party room! Enjoy the music & vibes 🎉',
      language: 'Tamil / English',
    );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StreamerProfileScreen(streamer: streamerModel),
      ),
    );
    setState(() {});
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        chatMessages.add({
          "user": "You",
          "text": _messageController.text.trim(),
        });
      });
      _messageController.clear();
      FocusScope.of(context).unfocus();
    }
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
  Widget build(BuildContext context) {
    final followNotifier = StreamerFollowManager().getFollowNotifier(streamerKey);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1A0B2E), Color(0xFF0F051D), Color(0xFF05020A)],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _openFullHostProfile(context),
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.pinkAccent.withOpacity(0.3),
                                    child: const Icon(Icons.person, color: Colors.white, size: 20),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            roomTitle,
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                          ),
                                          const SizedBox(width: 4),
                                          GestureDetector(
                                            onTap: () {
                                              PartyRoomThemeHelper.showRoomTitleDialog(context, roomTitle, (newTitle) {
                                                setState(() {
                                                  roomTitle = newTitle;
                                                });
                                              });
                                            },
                                            child: const Icon(Icons.edit, color: Colors.pinkAccent, size: 14),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '${roomViewers.length} Online • Party Room',
                                        style: const TextStyle(color: Colors.white60, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            StreamerFollowManager().toggleFollow(streamerKey);
                            final status = StreamerFollowManager().isFollowing(streamerKey);
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
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isFollowing ? Colors.grey.shade800 : Colors.pinkAccent,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isFollowing ? Icons.check : Icons.favorite,
                                      size: 14,
                                      color: isFollowing ? Colors.white70 : Colors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      isFollowing ? 'Following' : 'Follow',
                                      style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: () => _openViewersScreen(context),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                const Icon(Icons.remove_red_eye, color: Colors.cyanAccent, size: 14),
                                const SizedBox(width: 3),
                                Text('${roomViewers.length}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                          onPressed: () {
                            PartyRoomThemeHelper.showCloseRoomDialog(context, () {
                              Navigator.pop(context);
                              PartyRoomOverlayManager.showFloatingMiniPlayer(
                                context: context,
                                room: widget.room,
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('Room Type: ', style: TextStyle(color: Colors.white60, fontSize: 11)),
                            PartyRoomThemeHelper.buildRoomTypeSelector(),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                PartyRoomThemeHelper.showAudienceMicDialog(context, (mode) {
                                  setState(() {
                                    audienceMicMode = mode;
                                  });
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.purple.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text('Mic: $audienceMicMode', style: const TextStyle(color: Colors.cyanAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text('Room Theme (33 Options):', style: TextStyle(color: Colors.white60, fontSize: 11)),
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 32,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: PartyRoomThemeHelper.partyThemes.length,
                            itemBuilder: (context, index) {
                              final theme = PartyRoomThemeHelper.partyThemes[index];
                              bool isSelected = selectedTheme == theme;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTheme = theme;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.pinkAccent : const Color(0xFF2C2445),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: isSelected ? Colors.white : Colors.white24),
                                  ),
                                  child: Center(
                                    child: Text(
                                      theme,
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : Colors.white70,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 3,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(12),
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        final seat = voiceSeats[index];
                        final bool isSpeaking = seat['isSpeaking'];
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSpeaking ? Colors.cyanAccent : Colors.white24,
                                  width: isSpeaking ? 2.5 : 1.0,
                                ),
                                boxShadow: isSpeaking
                                    ? [BoxShadow(color: Colors.cyanAccent.withOpacity(0.6), blurRadius: 8, spreadRadius: 1)]
                                    : [],
                              ),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.purple.withOpacity(0.4),
                                child: const Icon(Icons.mic, size: 16, color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              seat['name'],
                              style: TextStyle(
                                color: isSpeaking ? Colors.cyanAccent : Colors.white70,
                                fontSize: 9,
                                fontWeight: isSpeaking ? FontWeight.bold : FontWeight.normal,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.celebration,
                            size: 70,
                            color: Colors.pinkAccent.withOpacity(0.4),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Active Theme: $selectedTheme',
                                                        style: const TextStyle(color: Colors.amberAccent, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListView.builder(
                      itemCount: chatMessages.length,
                      itemBuilder: (context, index) {
                        final msg = chatMessages[index];
                        bool isSystem = msg['user'] == "System";
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            isSystem ? "${msg['text']}" : "${msg['user']} : ${msg['text']}",
                            style: TextStyle(
                              color: isSystem ? Colors.amberAccent : Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            onSubmitted: (_) => _sendMessage(),
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: const TextStyle(color: Colors.white54, fontSize: 13),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 2),
                        IconButton(
                          icon: const Icon(Icons.send, color: Colors.cyanAccent, size: 18),
                          onPressed: _sendMessage,
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.card_giftcard, color: Colors.pinkAccent),
                          onPressed: () => _showGiftBottomSheet(context),
                        ),
                        IconButton(
                          icon: Icon(
                            isMuted ? Icons.mic_off : Icons.mic,
                            color: isMuted ? Colors.redAccent : Colors.cyanAccent,
                          ),
                          onPressed: _toggleMute,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
