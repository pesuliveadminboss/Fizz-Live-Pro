import 'package:flutter/material.dart';
import 'party_room_list_screen.dart';
import 'party_room_creator_screen.dart';

class PartyRoomHub extends StatelessWidget {
  const PartyRoomHub({super.key});

  @override
  Widget build(BuildContext context) {
    return const PartyRoomListScreen();
  }

  // Helper method to navigate to Creator Screen from List Floating Button
  static void openCreator(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PartyRoomCreatorScreen(),
      ),
    );
  }
}
