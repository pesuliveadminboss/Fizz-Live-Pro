import 'package:flutter/material.dart';
import 'party_room_model.dart';
import 'party_room_screen.dart';
import 'party_room_creator_screen.dart';

class PartyRoomListScreen extends StatefulWidget {
  const PartyRoomListScreen({super.key});

  @override
  State<PartyRoomListScreen> createState() => _PartyRoomListScreenState();
}

class _PartyRoomListScreenState extends State<PartyRoomListScreen> {
  final List<Map<String, dynamic>> sampleRooms = [
    {
      'roomID': 'room_101',
      'roomName': 'Party Ship Cinematic Voyage 🚢',
      'hostName': 'Captain Chandran',
      'onlineCount': 25,
      'theme': 'party_ship_cinematic',
    },
    {
      'roomID': 'room_102',
      'roomName': 'Royal Night Celebration 👑',
      'hostName': 'Aisha Live',
      'onlineCount': 14,
      'theme': 'royal_night',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      body: Stack(
        children: [
          Column(
            children: [
              // AdMob Banner Slot
              Container(
                height: 35,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D1B36),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.white10),
                ),
                child: const Center(
                  child: Text(
                    "AdMob Hub Banner Slot",
                    style: TextStyle(color: Colors.white54, fontSize: 10),
                  ),
                ),
              ),
              // Rooms List directly without tabs
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  itemCount: sampleRooms.length,
                  itemBuilder: (context, index) {
                    final roomMap = sampleRooms[index];
                    final room = PartyRoomModel.fromJson(roomMap);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2A1B4E), Color(0xFF1D1B36)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.pinkAccent.withOpacity(0.3), width: 1),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        leading: const CircleAvatar(
                          backgroundColor: Colors.pinkAccent,
                          radius: 24,
                          child: Icon(Icons.directions_boat, color: Colors.white, size: 22),
                        ),
                        title: Text(
                          room.roomName,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Host: ${room.hostName}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.person, color: Colors.cyanAccent, size: 14),
                                  const SizedBox(width: 4),
                                  Text("${room.onlineCount} Online", style: const TextStyle(color: Colors.cyanAccent, fontSize: 11)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PartyRoomScreen(room: room),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // Start Party Floating Button at bottom
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF2E93), Color(0xFFFF8A00)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pinkAccent.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PartyRoomCreatorScreen()),
                    );
                    if (result != null && result is Map<String, dynamic>) {
                      setState(() {
                        sampleRooms.insert(0, {
                          'roomID': 'room_${DateTime.now().millisecondsSinceEpoch}',
                          'roomName': result['roomName'],
                          'hostName': 'Chandran S',
                          'onlineCount': 1,
                          'theme': result['theme'],
                        });
                      });
                    }
                  },
                  icon: const Icon(Icons.celebration, color: Colors.white),
                  label: const Text(
                    'Start Party 🎉',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
