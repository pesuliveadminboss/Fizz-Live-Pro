import 'package:flutter/material.dart';
import 'party_room_model.dart';
import 'party_room_detail_screen.dart';

class PartyRoomListScreen extends StatelessWidget {
  const PartyRoomListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<PartyRoomModel> sampleRooms = [
      PartyRoomModel(
        roomID: "room_101",
        roomName: "Sweet Couple Ceremony ❤️",
        hostName: "PariHub Star",
        onlineCount: 11,
        theme: "cruise",
      ),
      PartyRoomModel(
        roomID: "room_102",
        roomName: "Mahfil a Isha 🌙",
        hostName: "Aisha Live",
        onlineCount: 8,
        theme: "couple",
      ),
      PartyRoomModel(
        roomID: "room_103",
        roomName: "Super Party TV 🎉",
        hostName: "DJ Rahul",
        onlineCount: 15,
        theme: "dj",
      ),
      PartyRoomModel(
        roomID: "room_104",
        roomName: "Night Vibes & Chill ✨",
        hostName: "Kavi Speaker",
        onlineCount: 6,
        theme: "retro",
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              leading: CircleAvatar(
                backgroundColor: Colors.pinkAccent,
                radius: 24,
                child: const Icon(Icons.mic, color: Colors.white, size: 22),
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
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.pinkAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text("Theme: ${room.theme}", style: const TextStyle(color: Colors.pinkAccent, fontSize: 10)),
                        ),
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
                    builder: (context) => PartyRoomDetailScreen(room: room),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
