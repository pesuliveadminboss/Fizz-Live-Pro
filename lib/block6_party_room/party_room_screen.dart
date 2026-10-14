import 'package:flutter/material.dart';

class PartyRoomScreen extends StatefulWidget {
  final dynamic room; // Can accept room model or roomID

  const PartyRoomScreen({
    super.key,
    this.room,
  });

  @override
  State<PartyRoomScreen> createState() => _PartyRoomScreenState();
}

class _PartyRoomScreenState extends State<PartyRoomScreen> {
  bool isMinimized = false;
  Offset floatingOffset = const Offset(20, 100);
  final TextEditingController _messageController = TextEditingController();

  // Simulated 10 Voice Seats Data
  final List<Map<String, dynamic>> voiceSeats = List.generate(10, (index) => {
        'index': index + 1,
        'name': index == 0 ? 'Host' : 'User ${index + 1}',
        'isSpeaking': index == 1 || index == 4, // Simulated speaking glow
        'isMuted': false,
      });

  @override
  Widget build(BuildContext context) {
    if (isMinimized) {
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
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.cyanAccent, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                  color: Colors.black87,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.pinkAccent,
                      child: Icon(Icons.mic, color: Colors.white, size: 24),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow, size: 12, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
              // 1. Top Header with Follow Button & Minimize ('X')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.pinkAccent.withOpacity(0.3),
                      child: const Icon(Icons.person, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Column(
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
                    ),
                    // Follow Button (+)
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add, size: 14, color: Colors.white),
                      label: const Text('Follow', style: TextStyle(fontSize: 12, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        minimumSize: const Size(60, 28),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Minimize / Floating Button ('X')
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () {
                        setState(() {
                          isMinimized = true; // Switch to floating widget
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

              // 5. Bottom Message Input Bar & Toolbar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
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
