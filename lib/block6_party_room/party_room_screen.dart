import 'package:flutter/material.dart';
import '../block3_hot_tab/streamer_profile_screen.dart';
import '../block3_hot_tab/streamer_profile_model.dart';
import '../block5_live_streaming/streamer_follow_manager.dart';
import '../block5_live_streaming/live_streamer_overlay_manager.dart';
import 'room_viewers_screen.dart';
import 'gift_bottom_sheet.dart';
import 'party_room_overlay_manager.dart';
import 'party_room_model.dart';
import 'party_room_seat_profile_sheet.dart';

class PartyRoomScreen extends StatefulWidget {
  final dynamic room;
  final String roomTitle;
  final String selectedTheme;
  final String audienceMicMode;

  const PartyRoomScreen({
    super.key,
    this.room,
    this.roomTitle = 'Alsha Party Room',
    this.selectedTheme = 'Candy Fiesta',
    this.audienceMicMode = 'Free',
  });

  @override
  State<PartyRoomScreen> createState() => _PartyRoomScreenState();
}

class _PartyRoomScreenState extends State<PartyRoomScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final String streamerKey = 'Alsha Live';

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

  // 10 Seats configuration (Indices 0, 1, 4 have active users, others are empty/locked)
  final List<Map<String, dynamic>> voiceSeats = [
    {'index': 1, 'name': 'Host', 'isOccupied': true, 'isSpeaking': false},
    {'index': 2, 'name': 'User 2', 'isOccupied': true, 'isSpeaking': true},
    {'index': 3, 'name': 'Empty Seat', 'isOccupied': false, 'isSpeaking': false},
    {'index': 4, 'name': 'Empty Seat', 'isOccupied': false, 'isSpeaking': false},
    {'index': 5, 'name': 'User 5', 'isOccupied': true, 'isSpeaking': true},
    {'index': 6, 'name': 'Empty Seat', 'isOccupied': false, 'isSpeaking': false},
    {'index': 7, 'name': 'Empty Seat', 'isOccupied': false, 'isSpeaking': false},
    {'index': 8, 'name': 'Empty Seat', 'isOccupied': false, 'isSpeaking': false},
    {'index': 9, 'name': 'Empty Seat', 'isOccupied': false, 'isSpeaking': false},
    {'index': 10, 'name': 'Empty Seat', 'isOccupied': false, 'isSpeaking': false},
  ];

  @override
  void initState() {
    super.initState();
    PartyRoomOverlayManager.hideOverlay();
    LiveStreamerOverlayManager.hideOverlay();

    _animController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animProgress = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
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

  void _showSeatProfile(BuildContext context, String seatName, String role) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return PartyRoomSeatProfileSheet(userName: seatName, role: role);
      },
    );
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
    
    final String hostName = widget.room is PartyRoomModel 
        ? (widget.room as PartyRoomModel).hostName 
        : 'Alsha Live';
        
    final String activeTheme = widget.room is PartyRoomModel 
        ? (widget.room as PartyRoomModel).theme 
        : widget.selectedTheme;

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
                  // Top Header
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
                                      Text(
                                        hostName,
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
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
                          valueListenable: followNotifier,
                          builder: (context, isFollowing, child) {
                            return GestureDetector(
                              onTap: () => StreamerFollowManager().toggleFollow(streamerKey),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isFollowing ? Colors.grey.shade800 : Colors.pinkAccent,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  isFollowing ? 'Following' : 'Follow',
                                  style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () => _openViewersScreen(context),
                          child: Row(
                            children: [
                              const Icon(Icons.remove_red_eye, color: Colors.cyanAccent, size: 14),
                              const SizedBox(width: 3),
                              Text('${roomViewers.length}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                          onPressed: () {
                            Navigator.pop(context);
                            PartyRoomOverlayManager.showFloatingMiniPlayer(
                              context: context,
                              room: widget.room,
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Voice Seats Grid (10 Seats) - Clickable only if occupied
                  Expanded(
                    flex: 4,
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
                        final bool isOccupied = seat['isOccupied'] ?? false;
                        final bool isSpeaking = seat['isSpeaking'] ?? false;
                        final String seatUserName = seat['name'];
                        final String roleDesc = index == 0 ? 'Room Host' : 'Party Participant';

                        return GestureDetector(
                          onTap: isOccupied 
                              ? () => _showSeatProfile(context, seatUserName, roleDesc) 
                              : null, // Empty seats will not trigger popup
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSpeaking ? Colors.cyanAccent : (isOccupied ? Colors.white38 : Colors.white12),
                                    width: isSpeaking ? 2.5 : 1.0,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: isOccupied ? Colors.purple.withOpacity(0.4) : Colors.white.withOpacity(0.05),
                                  child: Icon(
                                    isOccupied ? Icons.mic : Icons.mic_off, 
                                    size: 16, 
                                    color: isOccupied ? Colors.white : Colors.white24,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                seatUserName,
                                style: TextStyle(
                                  color: isSpeaking ? Colors.cyanAccent : (isOccupied ? Colors.white70 : Colors.white30),
                                  fontSize: 9,
                                  fontWeight: isSpeaking ? FontWeight.bold : FontWeight.normal,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Center Theme Graphic / Animation View
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.celebration,
                            size: 60,
                            color: Colors.pinkAccent.withOpacity(0.5),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Active Theme: $activeTheme',
                            style: const TextStyle(color: Colors.amberAccent, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Chat Messages Box
                  Container(
                    height: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListView.builder(
                      itemCount: chatMessages.length,
                      itemBuilder: (context, index) {
                        final currentMsg = chatMessages[index];
                        bool isSystem = currentMsg['user'] == "System";
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            isSystem ? "${currentMsg['text']}" : "${currentMsg['user']} : ${currentMsg['text']}",
                            style: TextStyle(
                              color: isSystem ? Colors.amberAccent : Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Bottom Input & Toolbar
                  Padding(
                    padding: const EdgeInsets.all(12.0),
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
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.send, color: Colors.cyanAccent, size: 18),
                          onPressed: _sendMessage,
                        ),
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
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.amberAccent, width: 2.5),
                ),
                child: Text(
                  activeGiftEffect!,
                  style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
