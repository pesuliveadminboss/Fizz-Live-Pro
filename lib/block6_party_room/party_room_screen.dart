import 'package:flutter/material.dart';
import 'party_room_model.dart';
import 'party_room_overlay_manager.dart';
import '../block5_live_streaming/streamer_follow_manager.dart';

class PartyRoomScreen extends StatefulWidget {
  final PartyRoom room;
  const PartyRoomScreen({super.key, required this.room});

  @override
  State<PartyRoomScreen> createState() => _PartyRoomScreenState();
}

class _PartyRoomScreenState extends State<PartyRoomScreen> {
  final TextEditingController _chatController = TextEditingController();
  final List<Map<String, String>> _partyChats = [
    {'user': 'System', 'message': 'Welcome to Party Room! Keep it respectful and enjoy the vibe.'},
    {'user': 'PariHub', 'message': '✨ Grab your mic and join the chat!'},
  ];

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  void _handleSendMessage(String msg) {
    if (msg.trim().isEmpty) return;
    setState(() {
      _partyChats.add({'user': 'You', 'message': msg});
      _chatController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final followNotifier = StreamerFollowManager().getFollowNotifier(widget.room.hostName);

    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      body: Stack(
        children: [
          // Cinematic Background Theme
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF2A1B4E), Color(0xFF121026), Color(0xFF0D0B1A)],
                ),
              ),
              child: Center(
                child: Opacity(
                  opacity: 0.15,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.nightlife, size: 180, color: Colors.cyanAccent),
                      const SizedBox(height: 10),
                      Text('Theme: ${widget.room.themeType.toUpperCase()}', style: const TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 2)),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Top Header Bar (Capsule Profile, Follow Sync, Minimize Button)
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Capsule Host Profile
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.pinkAccent.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.pinkAccent,
                        child: Icon(Icons.person, color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.room.hostName, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          Text('${widget.room.onlineCount} Online', style: const TextStyle(color: Colors.cyanAccent, fontSize: 10)),
                        ],
                      ),
                      const SizedBox(width: 10),
                      // Follow Sync Button
                      GestureDetector(
                        onTap: () {
                          StreamerFollowManager().toggleFollow(widget.room.hostName);
                          setState(() {});
                        },
                        child: ValueListenableBuilder<bool>(
                          valueListenable: followNotifier,
                          builder: (context, isFollowing, child) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isFollowing ? Colors.grey.withOpacity(0.4) : Colors.pinkAccent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isFollowing ? 'Following' : 'Follow',
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Right Icons: Online Count & Compact Mini-Player Minimize Button
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          const Icon(Icons.people, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text('${widget.room.onlineCount}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Minimize to Compact Audio Mini-Player
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        PartyRoomOverlayManager.showCompactAudioMiniPlayer(
                          context: context,
                          room: widget.room,
                        );
                      },
                      child: const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.black54,
                        child: Icon(Icons.minimize, color: Colors.white, size: 18),
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Close Room Button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.black54,
                        child: Icon(Icons.close, color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Multi-Seat Audio Grid (10 Seats for 10 Members)
          Positioned(
            top: 110,
            left: 16,
            right: 16,
            child: SizedBox(
              height: 220,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  bool isOccupied = index < widget.room.seats.length && widget.room.seats[index] != 'Empty';
                  String seatLabel = isOccupied ? widget.room.seats[index] : 'Seat ${index + 1}';

                  return Container(
                    decoration: BoxDecoration(
                      color: isOccupied ? const Color(0xFF1D1B36) : Colors.white10,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isOccupied ? Colors.cyanAccent : Colors.white24,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isOccupied ? Icons.mic : Icons.mic_none,
                          color: isOccupied ? Colors.cyanAccent : Colors.white38,
                          size: 20,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          seatLabel,
                          style: TextStyle(
                            color: isOccupied ? Colors.white : Colors.white38,
                            fontSize: 9,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // Bottom Scrollable Party Chat Feed
          Positioned(
            bottom: 70,
            left: 16,
            right: 80,
            child: SizedBox(
              height: 140,
              child: ListView.builder(
                itemCount: _partyChats.length,
                itemBuilder: (context, index) {
                  final chat = _partyChats[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${chat['user']}: ',
                              style: const TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: chat['message'],
                              style: const TextStyle(color: Colors.white, fontSize: 11),
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

          // Bottom Action Toolbar (Mic, Gift, Chat Input)
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _chatController,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: 'Say something to the party...',
                        hintStyle: TextStyle(color: Colors.white54, fontSize: 12),
                        border: InputBorder.none,
                      ),
                      onSubmitted: _handleSendMessage,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Mic Control Toggle
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.cyanAccent,
                  child: Icon(Icons.mic, color: Color(0xFF121026), size: 20),
                ),
                const SizedBox(width: 8),
                // Cinematic Gift Button
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('🎁 Sending Cinematic Gift Effect!'), duration: Duration(seconds: 1)),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.pinkAccent, Colors.purpleAccent]),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.card_giftcard, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

