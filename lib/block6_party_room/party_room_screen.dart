import 'package:flutter/material.dart';
import '../block3_hot_tab/streamer_profile_screen.dart';
import '../block3_hot_tab/streamer_profile_model.dart';
import '../block4_private_chat/private_chat_screen.dart';
import 'room_viewers_screen.dart';

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

  bool isFollowing = false;
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
    setState(() {
      isFollowing = !isFollowing;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isFollowing ? 'Following Alsha Live ❤' : 'Unfollowed Alsha Live'),
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
    final List<Map<String, dynamic>> gifts = [
      {'name': 'Rocket 🚀', 'icon': Icons.rocket_launch, 'color': Colors.orangeAccent},
      {'name': 'Airplane ✈️', 'icon': Icons.flight, 'color': Colors.lightBlueAccent},
      {'name': 'Cruise Ship 🚢', 'icon': Icons.directions_boat, 'color': Colors.cyanAccent},
      {'name': 'Bomb 💣', 'icon': Icons.local_fire_department, 'color': Colors.redAccent},
      {'name': 'Kiss 😘', 'icon': Icons.favorite_border, 'color': Colors.pinkAccent},
      {'name': 'Heart ❤', 'icon': Icons.favorite, 'color': Colors.pink},
      {'name': 'Handshake 🤝', 'icon': Icons.handshake, 'color': Colors.amberAccent},
      {'name': 'Red Rose 🌹', 'icon': Icons.local_florist, 'color': Colors.red},
      {'name': 'Smiley 😊', 'icon': Icons.emoji_emotions, 'color': Colors.yellowAccent},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A0B2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 280,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Send Special Gifts 🎁',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.5,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: gifts.length,
                  itemBuilder: (context, index) {
                    final gift = gifts[index];
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        _triggerGiftEffect(gift['name']);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: (gift['color'] as Color).withOpacity(0.4)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(gift['icon'] as IconData, color: gift['color'] as Color, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              gift['name'].toString().split(' ')[0],
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
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
              Positioned(
                left: floatingOffset.dx,
                top: floatingOffset.dy,
                child: GestureDetector(
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
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.cyanAccent, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withOpacity(0.8),
                          blurRadius: 10,
                          spreadRadius: _glowAnimation.value,
                        )
                      ],
                      color: Colors.black87,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(Icons.mic, color: Colors.cyanAccent, size: 26),
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.play_arrow, size: 8, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _openFullHostProfile(context),
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
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
                        InkWell(
                          onTap: _toggleFollow,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: () => _openViewersScreen(context),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: EdgeInsets.all(4.0),
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
                      padding: EdgeInsets.all(12),
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
                              padding: EdgeInsets.all(2),
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
                    padding: EdgeInsets.all(8),
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
                          padding: EdgeInsets.symmetric(vertical: 2),
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
                    padding: EdgeInsets.all(8.0),
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
                              contentPadding: EdgeInsets.symmetric(horizontal: 14,
