import 'package:flutter/material.dart';
import '../block3_hot_tab/streamer_profile_screen.dart';
import '../block3_hot_tab/streamer_profile_model.dart';
import '../block4_private_chat/private_chat_screen.dart';
import 'room_viewers_screen.dart';
import 'gift_bottom_sheet.dart';
import 'party_room_follow_manager.dart';
import 'party_room_minimize_helper.dart';

class PartyRoomScreen extends StatefulWidget {
  final dynamic room;

  const PartyRoomScreen({
    super.key,
    this.room,
  });

  @override
  State<PartyRoomScreen> createState() => _PartyRoomScreenState();
}

class _PartyRoomScreenState extends State<PartyRoomScreen> with SingleTickerProviderStateMixin {
  bool isMinimized = false;
  Offset floatingOffset = const Offset(20, 100);
  final TextEditingController _messageController = TextEditingController();

  bool isMuted = false;
  String? activeGiftEffect;

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
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 2.0, end: 6.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _toggleFollow() {
    PartyRoomFollowManager().toggleFollow();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(PartyRoomFollowManager().isFollowing ? 'Following Alsha Live ❤' : 'Unfollowed Alsha Live'),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.pinkAccent,
      ),
    );
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
      id: 'alsha_live_007',
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

  void _triggerGiftEffect(String giftName) {
    setState(() {
      activeGiftEffect = giftName;
    });
    Future.delayed(const Duration(seconds: 3), () {
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
            _triggerGiftEffect('$giftName x$quantity');
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isMinimized) {
      return AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Stack(
            children: [
              PartyRoomMinimizeHelper.buildMinimizedFloatingWidget(
                offset: floatingOffset,
                onPanUpdate: (details) {
                  setState(() {
                    floatingOffset += details.delta;
                  });
                },
                onTap: () {
                  setState(() {
                    isMinimized = false;
                  });
                },
                glowAnimation: _glowAnimation,
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A0B2E), Color(0xFF0F051D), Color(0xFF05020A)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
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
                                      const Text(
                                        'Alsha Live',
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
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
                        ValueListenableBuilder<bool>(
                          valueListenable: PartyRoomFollowManager().isFollowingNotifier,
                          builder: (context, isFollowing, child) {
                            return InkWell(
                              onTap: _toggleFollow,
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
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
                              ),
                            );
                          },
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
                            setState(() {
                              isMinimized = true;
                            });
                          },
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
                    flex: 3,
                    child: Center(
                      child: Icon(
                        Icons.directions_boat,
                        size: 90,
                        color: Colors.purpleAccent.withOpacity(0.3),
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
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
                            isSystem ? "${msg['text']}" : "${msg['user']} :${msg['text']}",
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
                        const SizedBox(width: 8),
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
              if (activeGiftEffect != null)
                Center(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.2, end: 1.2),
                    duration: const Duration(milliseconds: 600),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.amberAccent, width: 2),
                            boxShadow: [
                              BoxShadow(color: Colors.amberAccent.withOpacity(0.6), blurRadius: 20, spreadRadius: 5)
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.local_fire_department, color: Colors.amberAccent, size: 32),
                              const SizedBox(width: 12),
                              Text(
                                activeGiftEffect!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                ),
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
      ),
    );
  }
}
                            
