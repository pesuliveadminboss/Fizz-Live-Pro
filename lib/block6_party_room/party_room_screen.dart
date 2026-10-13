import 'package:flutter/material.dart';
import 'party_room_model.dart';
import 'party_room_detail_screen.dart';

class PartyRoomScreen extends StatelessWidget {
  final PartyRoomModel room;

  const PartyRoomScreen({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      body: Stack(
        children: [
          // Cinematic & Party Ship Theme Background Effect
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2A1B4E), Color(0xFF121026), Color(0xFF0B0919)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Compact AdMob Safe Slot
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
                      "AdMob Cinematic Slot [Button Size]",
                      style: TextStyle(color: Colors.white54, fontSize: 10),
                    ),
                  ),
                ),
                Expanded(
                  child: PartyRoomDetailScreen(room: room),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
