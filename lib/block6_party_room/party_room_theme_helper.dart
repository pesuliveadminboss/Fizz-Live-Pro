import 'package:flutter/material.dart';

class PartyRoomThemeHelper {
  static final List<String> partyThemes = [
    'Candy Fiesta',
    'CashMania',
    'GoldCity',
    'Teen Patti Gold',
    'Greedy King',
    'Fruit Machine',
    'Fortune Gems',
    'Fishing Star2',
    'Zeus Slot',
    'Teen Patti',
    'Super Ace',
    'Slots',
    'Lucky 777',
    'Rocket',
    'Roulette',
    'Dice',
    'Black Jack',
    'Air Force Star',
    'Pinata',
    'Joker Fortune',
    'Golden Palace',
    'Chicken Plinko',
    'Mega Jackpot',
    'Fly Crash',
    'Three Clover Pots',
    'Alibaba\'s Fortune',
    'Avia masters',
    'Magic Gems',
    'Money Pot',
    'Reel Of Ra',
    'Gates of Olympus',
    'Fishing Jackpot Pro',
    'Pirate'
  ];

  static void showRoomTitleDialog(BuildContext context, String currentTitle, ValueChanged<String> onSaved) {
    TextEditingController controller = TextEditingController(text: currentTitle);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D1B36),
        title: const Text('Room Title', style: TextStyle(color: Colors.white, fontSize: 16)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter room title',
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.pinkAccent)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
            onPressed: () {
              onSaved(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  static void showAudienceMicDialog(BuildContext context, ValueChanged<String> onSelected) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1D1B36),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Audience Take Mic', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ListTile(
                title: const Text('Free', style: TextStyle(color: Colors.white)),
                onTap: () {
                  onSelected('Free');
                  Navigator.pop(context);
                },
              ),
              const Divider(color: Colors.white24),
              ListTile(
                title: const Text('Consent is required', style: TextStyle(color: Colors.white)),
                onTap: () {
                  onSelected('Consent is required');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static void showCloseRoomDialog(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D1B36),
        title: const Text('Are you sure to close your live room?', style: TextStyle(color: Colors.white, fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.pinkAccent)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  static Widget buildRoomTypeSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.pinkAccent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        'Party-Chat',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }
}
