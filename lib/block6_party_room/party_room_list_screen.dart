import 'package:flutter/material.dart';
import 'party_room_model.dart';
import 'party_room_screen.dart';

class PartyRoomListScreen extends StatefulWidget {
  const PartyRoomListScreen({super.key});

  @override
  State<PartyRoomListScreen> createState() => _PartyRoomListScreenState();
}

class _PartyRoomListScreenState extends State<PartyRoomListScreen> {
  @override
  Widget build(BuildContext context) {
    final rooms = PartyRoom.dummyRooms;

    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1B36),
        title: const Text('Party Rooms', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // ListView with interleaved Banner Ads after every 2 Party Rooms
          ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: rooms.length + (rooms.length / 2).floor(),
            itemBuilder: (context, index) {
              // Check if this index should be an Ad Banner (every 3rd item after 2 rooms)
              if ((index + 1) % 3 == 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF9C27B0), Color(0xFFE91E63), Color(0xFFFF9800)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        '✨ Monthly CP & Special Event Banner Ad ✨',
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              }

              // Calculate actual room index
              int roomIndex = index - (index / 3).floor();
              if (roomIndex >= rooms.length) return const SizedBox.shrink();
              
              final room = rooms[roomIndex];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PartyRoomScreen(room: room),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D1B36),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.purpleAccent.withOpacity(0.3), width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.purple]),
                          ),
                          child: const Icon(Icons.mic, color: Colors.white, size: 30),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(room.roomName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('Host: ${room.hostName}', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.person, color: Colors.cyanAccent, size: 14),
                                  const SizedBox(width: 4),
                                  Text('${room.onlineCount} Online', style: const TextStyle(color: Colors.cyanAccent, fontSize: 12)),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.pinkAccent.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text('Theme: ${room.themeType}', style: const TextStyle(color: Colors.pinkAccent, fontSize: 10)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 16),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Bottom Center Floating "Start Party Room" Button
          Positioned(
            bottom: 20,
            left: 40,
            right: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 6,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening Party Room Creator...'), duration: Duration(seconds: 1)),
                );
              },
              child: const Text(
                '🚀 Start Party Room',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
