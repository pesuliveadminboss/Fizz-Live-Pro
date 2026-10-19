import 'dart:math';
import 'package:flutter/material.dart';
import '../block3_hot_tab/streamer_profile_screen.dart';
import '../block3_hot_tab/streamer_profile_model.dart';
import '../block5_live_streaming/streamer_follow_manager.dart';
import '../block5_live_streaming/live_streamer_overlay_manager.dart';
import '../block7_zego_integration/zego_party_room_service.dart';
import 'room_viewers_screen.dart';
import 'gift_bottom_sheet.dart';
import 'party_room_overlay_manager.dart';
import 'party_room_model.dart';
import 'party_room_seat_profile_sheet.dart';
import 'party_room_audio_manager.dart';
import 'party_gift_animation_helper.dart';
import 'party_room_members_helper.dart';

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

class _PartyRoomScreenState extends State<PartyRoomScreen> {
  final PageController _pageController = PageController();

  // ரேண்டமாக ரூம்களை மாற்றுவதற்காக சில சாம்பிள் ஹோஸ்ட் மற்றும் தீம் டேட்டா
  final List<Map<String, String>> _randomRoomsPool = [
    {"host": "Alsha Live", "theme": "Candy Fiesta", "id": "room_101"},
    {"host": "Priya Sharma", "theme": "Midnight Neon", "id": "room_102"},
    {"host": "Kavitha Raj", "theme": "Royal Palace", "id": "room_103"},
    {"host": "Deepika Sen", "theme": "Cyberpunk Beats", "id": "room_104"},
    {"host": "Ananya Roy", "theme": "Sunset Beach", "id": "room_105"},
    {"host": "Sneha Reddy", "theme": "Galaxy Dream", "id": "room_106"},
  ];

  late String currentHost;
  late String currentTheme;
  late String currentRoomId;

  @override
  void initState() {
    super.initState();
    final initialRoom = widget.room is PartyRoomModel ? (widget.room as PartyRoomModel) : null;
    currentHost = initialRoom?.hostName ?? widget.roomTitle;
    currentTheme = initialRoom?.theme ?? widget.selectedTheme;
    currentRoomId = initialRoom?.roomID ?? 'room_101';
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ஸ்க்ரோல் செய்யும்போது அடுத்த ரூம்காக ரேண்டமாக ஒரு ரூமைத் தேர்ந்தெடுக்கும் முறை
  void _loadRandomRoom(int index) {
    final random = Random();
    // தற்போதைய ஹோஸ்ட் அல்லாத வேறு ஒருவரை ரேண்டமாகத் தேர்ந்தெடுக்கிறோம்
    List<Map<String, String>> availableRooms = _randomRoomsPool.where((r) => r['host'] != currentHost).toList();
    if (availableRooms.isEmpty) availableRooms = _randomRoomsPool;

    final selected = availableRooms[random.nextInt(availableRooms.length)];

    setState(() {
      currentHost = selected['host']!;
      currentTheme = selected['theme']!;
      currentRoomId = selected['id']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: (index) {
          _loadRandomRoom(index);
        },
        itemBuilder: (context, index) {
          return SinglePartyRoomInstance(
            hostName: currentHost,
            selectedTheme: currentTheme,
            roomId: currentRoomId,
            originalWidgetRoom: widget.room,
          );
        },
      ),
    );
  }
}

// தனிப்பட்ட ஒரு பார்ட்டி ரூம் இன்ஸ்டன்ஸ் (UI மற்றும் லாஜிக்)
class SinglePartyRoomInstance extends StatefulWidget {
  final String hostName;
  final String selectedTheme;
  final String roomId;
  final dynamic originalWidgetRoom;

  const SinglePartyRoomInstance({
    super.key,
    required this.hostName,
    required this.selectedTheme,
    required this.roomId,
    this.originalWidgetRoom,
  });

  @override
  State<SinglePartyRoomInstance> createState() => _SinglePartyRoomInstanceState();
}

class _SinglePartyRoomInstanceState extends State<SinglePartyRoomInstance> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  
  final PartyRoomAudioManager _audioManager = PartyRoomAudioManager();
  final PartyRoomMembersHelper _membersHelper = PartyRoomMembersHelper();

  bool isMuted = false;
  String? activeGiftEffect;
  late AnimationController _animController;

  final List<Map<String, String>> chatMessages = [
    {"user": "System", "text": "Welcome to Party Room! Keep it clean and respectful. 🎙️"},
    {"user": "Raj Shukla", "text": "Nice to meet you! Grab the mic."},
    {"user": "System", "text": "Karthik Kumar joined the Party Ship 🚀"},
  ];

  final List<Map<String, String>> roomViewers = [
    {"name": "Raj Shukla", "status": "Active Listener"},
    {"name": "Karthik Kumar", "status": "Active Listener"},
    {"name": "Priya Ramesh", "status": "Active Listener"},
    {"name": "Suresh Babu", "status": "Active Listener"},
  ];

  @override
  void initState() {
    super.initState();
    PartyRoomOverlayManager.hideOverlay();
    LiveStreamerOverlayManager.hideOverlay();

    _initializeZegoPartySession();

    _animController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  Future<void> _initializeZegoPartySession() async {
    await ZegoPartyRoomService.initZegoEngine(
      userID: 'user_${DateTime.now().millisecondsSinceEpoch}',
      userName: 'Chandran S',
    );
    await ZegoPartyRoomService.joinRoom(widget.roomId);
  }

  @override
  void dispose() {
    ZegoPartyRoomService.leaveRoom();
    _animController.dispose();
    _messageController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  void _toggleAudioMute() {
    setState(() {
      isMuted = !isMuted;
    });
    _audioManager.toggleMute(0);
    ZegoPartyRoomService.setMicrophoneMute(isMuted);
    PartyRoomAudioManager.showAudioStatus(context, isMuted);
  }

  void _openFullHostProfile(BuildContext context) async {
    final streamerModel = StreamerProfileModel(
      name: widget.hostName,
      id: widget.roomId,
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

  void _showSeatProfile(BuildContext context, int seatIndex, String seatName, String role) {
    _membersHelper.showSeatManagementDialog(context, seatIndex, () {
      setState(() {});
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        chatMessages.add({
          "user": "Chandran S",
          "text": text,
        });
      });
      _messageController.clear();
      FocusScope.of(context).unfocus();

      Future.delayed(const Duration(milliseconds: 100), () {
        if (_chatScrollController.hasClients) {
          _chatScrollController.animateTo(
            _chatScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _triggerGiftEffect(String giftName, int quantity) {
    if (mounted) {
      setState(() {
        activeGiftEffect = '$giftName x$quantity';
      });
      _animController.forward(from: 0.0);

      PartyGiftAnimationHelper.showPartyGiftAnimation(context, giftName, 'Chandran S');

      Future.delayed(const Duration(milliseconds: 2500), () {
        if (mounted) {
          setState(() {
            activeGiftEffect = null;
          });
        }
      });
    }
  }

  void _showGiftBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return GiftBottomSheet(
          onSendGift: (giftName, quantity) {
            Navigator.of(sheetContext).pop();
            _triggerGiftEffect(giftName, quantity);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final followNotifier = StreamerFollowManager().getFollowNotifier(widget.hostName);

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
                                        widget.hostName,
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                      Text(
                                        '${roomViewers.length} Online • Zego Live',
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
                              onTap: () => StreamerFollowManager().toggleFollow(widget.hostName),
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
                          onTap: () => PartyRoomMembersHelper.showMembersListDialog(context, roomViewers.length),
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
                              room: widget.originalWidgetRoom,
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Voice Seats Grid (10 Seats)
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
                        final occupant = _membersHelper.getOccupant(index);
                        final bool isOccupied = occupant != null || index == 0;
                        final String seatUserName = occupant ?? (index == 0 ? widget.hostName : 'Empty Seat');
                        final bool seatMuted = _audioManager.isMuted(index);

                        return GestureDetector(
                          onTap: () => _showSeatProfile(context, index, seatUserName, index == 0 ? 'Room Host' : 'Party Participant'),
                          child: _audioManager.buildSpeakingIndicator(
                            index,
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: isOccupied ? Colors.purple.withOpacity(0.4) : Colors.white.withOpacity(0.05),
                                      child: Icon(
                                        isOccupied ? Icons.person : Icons.event_seat, 
                                        size: 16, 
                                        color: isOccupied ? Colors.white : Colors.white24,
                                      ),
                                    ),
                                    if (isOccupied)
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Icon(
                                          seatMuted ? Icons.mic_off : Icons.mic,
                                          size: 12,
                                          color: seatMuted ? Colors.redAccent : Colors.greenAccent,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  seatUserName,
                                  style: TextStyle(
                                    color: isOccupied ? Colors.white70 : Colors.white30,
                                    fontSize: 9,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
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
                            'Active Theme: ${widget.selectedTheme}',
                            style: const TextStyle(color: Colors.amberAccent, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '👆 Swipe up/down for random rooms',
                            style: TextStyle(color: Colors.white38, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Live Chat & Joining Scrollable Box
                  Container(
                    height: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: ListView.builder(
                      controller: _chatScrollController,
                      itemCount: chatMessages.length,
                      itemBuilder: (context, index) {
                        final currentMsg = chatMessages[index];
                        bool isSystem = currentMsg['user'] == "System";
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: isSystem ? "📢 " : "${currentMsg['user']}: ",
                                  style: TextStyle(
                                    color: isSystem ? Colors.cyanAccent : Colors.pinkAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                                TextSpan(
                                  text: "${currentMsg['text']}",
                                  style: TextStyle(
                                    color: isSystem ? Colors.amberAccent : Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
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
                              hintText: 'Say something to party...',
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
                          onPressed: _toggleAudioMute,
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
