import 'package:flutter/material.dart';
// Import Block 3 Full Streamer Profile Screen & Model
import '../block3_hot_tab/streamer_profile_screen.dart';
import '../block3_hot_tab/streamer_profile_model.dart';
import '../block4_private_chat/private_chat_screen.dart';

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

  // Follow State Synchronization Variable
  bool isFollowing = false;

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

  // Function to toggle Follow state synchronized with Profile & Show Popup
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
      // Refresh state when returning from profile page in case follow changed there
      setState(() {});
    });
  }

  // Send message action
  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
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
                      isMinimized = false; // Restore full screen
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
              // 1. Top Header with Clickable Host Profile, Capsule Heart Follow Button, Viewer Count & Square Minimize ('X')
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
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Alsha Live',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  Text(
                                    '14 Online • Party Room',
                                    style: TextStyle(color: Colors.white60, fontSize: 10),
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
                    // Viewer Count (Eye Icon + Count)
                    const Row(
                      children: [
                        Icon(Icons.remove_red_eye, color: Colors.white60, size: 14),
                        SizedBox(width: 3),
                        Text('14', style: TextStyle(color: Colors.white, fontSize: 11)),
                      ],
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

              // 4. Live Chat & Rules Area
              Container(
                height: 100,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView(
                  children: const [
                    Text(
                      "Welcome to Party Room! Keep it clean and respectful.",
                      style: TextStyle(color: Colors.amberAccent, fontSize: 11),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Raj Shukla : Nice to meet you! Grab the mic.",
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),

              // 5. Bottom Message Input Bar with Send Button & Toolbar
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
                          // SEND BUTTON INSIDE MESSAGE BAR
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send, color: Colors.cyanAccent, size: 18),
                            onPressed: _sendMessage,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.card_giftcard, color: Colors.pinkAccent),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.mic_off, color: Colors.white70),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
