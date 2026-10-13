import 'package:flutter/material.dart';
import 'party_room_model.dart';
import 'party_room_screen.dart';
import 'party_room_creator_screen.dart';

class PartyRoomNavigationBridge {
  static void navigateToRoom(BuildContext context, PartyRoomModel room) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PartyRoomScreen(room: room),
      ),
    );
  }

  static Future<Map<String, dynamic>?> navigateToCreator(BuildContext context) async {
    return await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => const PartyRoomCreatorScreen(),
      ),
    );
  }
}
