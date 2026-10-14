import 'package:flutter/material.dart';
// Import Block 3 Full Streamer Profile Screen & Model
import '../block3_hot_tab/streamer_profile_screen.dart';
import '../block3_hot_tab/streamer_profile_model.dart';
import '../block4_private_chat/private_chat_screen.dart';

// ---------------------------------------------------------
// 1. DEDICATED ROOM VIEWERS SCREEN (Numbered Long Capsule List)
// ---------------------------------------------------------
class RoomViewersScreen extends StatefulWidget {
  final List<Map<String, String>> viewers;

  const RoomViewersScreen({super.key, required this.viewers});

  @override
  State<RoomViewersScreen> createState() => _RoomViewersScreenState();
}

class _RoomViewersScreenState extends State<RoomViewersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F051D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A0B2E),
        title: Text('Room Viewers (${widget.viewers.length})', style: const TextStyle(color: Colors.white, fontSize: 16)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: widget.viewers.isEmpty
          ? const Center(
              child: Text('No viewers in the room', style: TextStyle(color: Colors.white54, fontSize: 14)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.viewers.length,
              itemBuilder: (context, index) {
                final viewer = widget.viewers[index];
                final serialNumber = index + 1;

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: InkWell(
                    onTap: () {
                      final streamerModel = StreamerProfileModel(
                        name: viewer['name']!,
                        id: 'user_id_$serialNumber',
                        country: 'India',
                        flag: '🇮🇳',
                        age: 23,
                        status: viewer['status']!,
                        intro: 'Hello! Welcome to my profile.',
                        language: 'Tamil / English',
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StreamerProfileScreen(streamer: streamerModel),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3), width: 1),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '$serialNumber.',
                            style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(width: 12),
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.pinkAccent.withOpacity(0.4),
                            child: Text(viewer['name']![0], style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  viewer['name']!,
                                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  viewer['status']!,
                                  style: const TextStyle(color: Colors.white60, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 14),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ---------------------------------------------------------
// 2. MAIN PARTY ROOM SCREEN
// ---------------------------------------------------------
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

  // Follow State & Mic Mute State
  bool isFollowing = false;
  bool isMuted = false;

  // Live Chat Messages List
  final List<Map<String, String>> chatMessages = [
    {"user": "System", "text": "Welcome to Party Room! Keep it clean and respectful."},
    {"user": "Raj Shukla", "text": "Nice to meet you! Grab the mic."},
    {"user": "System", "text": "Karthik Kumar joined the Party Room 🚀"},
  ];

  // Dynamic Viewers List
  final List<Map<String, String>> roomViewers = [
    {"name": "Raj Shukla", "status": "Active Listener"},
    {"name": "Alsha Live (Host)", "status": "Broadcaster"},
    {"name": "Karthik Kumar", "status": "Joined via For You"},
    {"name": "Priya Ramesh", "status": "Active Listener"},
    {"name": "Suresh Babu", "status": "Active Listener"},
  ];

  // Animation Controller for Square Minimized Floating Bass Glow Effect
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  // Simulated 10 Voice Seats Data
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

  // Function to toggle Follow state synchronized
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

  // Function to toggle Mic Mute/Unmute
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

  // Function to navigate to the Dedicated Viewers List Screen
  void _openViewersScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoomViewersScreen(viewers: roomViewers),
      ),
    );
    setState(() {});
  }

  // Function to navigate to Full Streamer Profile Screen with synchronized follow state
  void _openFullHostProfile(BuildContext context) {
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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StreamerProfileScreen(streamer: streamerModel),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  // Send message action & display in live chat view
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

  @override
  Widget build(BuildContext context) {
    // 1. SQUARE FLOATING MINIMIZED WIDGET WITH BASS GLOW EFFECT
    if (isMinimized) {
      return AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
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
                        isMinimized = false; // Restore full screen party room
                      });
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), // Square box with smooth corners
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
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
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
            ),
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
          child: Column(
            children: [
              // 1. Top Header with Clickable Host Profile, Capsule Heart Follow Button, Dynamic Viewer Count, & Square Minimize ('X')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    // Clickable Host Profile Area -> Opens Full Profile Screen
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
                    // Capsule Heart Follow Button (Synced)
                    InkWell(
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
                    ),
                    const SizedBox(width: 6),
                    // Dynamic Viewer Count (Eye Icon + Count -> Opens Viewers Screen)
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
                    // Square Minimize / Floating Button ('X')
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                      onPressed: () {
                        setState(() {
                          isMinimized = true; // Switch to square bass-glow floating widget
                        });
                      },
                    ),
                  ],
                ),
              ),

              // 2. 10 Voice Seats Grid Layout
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

              // 3. Cinematic Graphic / Cruise Placeholder area
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

              // 4. Live Chat & Room Joining Notifications Area
              Container(
                height: 100,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                
