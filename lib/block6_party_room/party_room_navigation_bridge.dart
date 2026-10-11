import 'package:flutter/material.dart';
import 'party_room_hub.dart';

class PartyRoomNavigationBridge {
  static Widget getPartyRoomTab() {
    return const PartyRoomHub();
  }

  static void jumpToPartyRooms(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PartyRoomHub(),
      ),
    );
  }
}
