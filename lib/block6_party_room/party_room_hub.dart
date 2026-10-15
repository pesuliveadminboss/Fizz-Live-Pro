import 'package:flutter/material.dart';
import 'party_room_list_screen.dart';

class PartyRoomHub extends StatefulWidget {
  const PartyRoomHub({super.key});

  @override
  State<PartyRoomHub> createState() => _PartyRoomHubState();
}

class _PartyRoomHubState extends State<PartyRoomHub> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      body: Column(
        children: [
          Container(
            height: 35,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1738),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.white10),
            ),
            child: const Center(
              child: Text(
                "AdMob Hub Banner Slot [Button Size]",
                style: TextStyle(color: Colors.white38, fontSize: 10),
              ),
            ),
          ),
          const Expanded(
            child: PartyRoomListScreen(),
          ),
        ],
      ),
    );
  }
}
