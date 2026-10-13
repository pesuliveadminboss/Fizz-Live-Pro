import 'package:flutter/material.dart';
import 'party_room_model.dart';

class PartyRoomListScreen extends StatelessWidget {
  const PartyRoomListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> sampleRooms = [
      {
        'roomID': 'room_101',
        'roomName': 'Party Ship Cinematic Voyage 🚢✨',
        'hostName': 'Captain Chandran',
        'onlineCount': 25,
        'theme': 'party_ship_cinematic',
      },
      {
        'roomID': 'room_102',
        'roomName': 'Royal Night Celebration 🌙🎉',
        'hostName': 'Aisha Live',
        'onlineCount': 14,
        'theme': 'royal_night',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      body: Column(
        children: [
          Container(
            height: 35,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1D1B36),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.white10),
            ),
            child: const Center(
              child: Text(
                "AdMob Safe Banner Slot [Button Size]",
                style: TextStyle(color: Colors.white54, fontSize: 10),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              itemCount: sampleRooms.length,
              itemBuilder: (context, index) {
                final room = sampleRooms[index];
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
                      room['roomName'],
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Host: ${room['hostName']}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.person, color: Colors.cyanAccent, size: 14),
                              const SizedBox(width: 4),
                              Text("${room['onlineCount']} Online", style: const TextStyle(color: Colors.cyanAccent, fontSize: 11)),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.pinkAccent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text("Theme: ${room['theme']}", style: const TextStyle(color: Colors.pinkAccent, fontSize: 10)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening Party Room Details...')),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
