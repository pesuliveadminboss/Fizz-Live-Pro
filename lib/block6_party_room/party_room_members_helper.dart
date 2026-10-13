import 'package:flutter/material.dart';

class PartyRoomMembersHelper {
  static void showMembersListDialog(BuildContext context, int onlineCount) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1D1B36),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  Text(
                    'Online Members ($onlineCount) 🚢',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(color: Colors.white12),
              Expanded(
                child: ListView.builder(
                  itemCount: onlineCount > 5 ? 5 : onlineCount,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.pinkAccent,
                        radius: 18,
                        child: Icon(Icons.person, color: Colors.white, size: 16),
                      ),
                      title: Text(
                        'Party Member ${index + 1}',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      subtitle: const Text(
                        'Active on Party Ship 🌊',
                        style: TextStyle(color: Colors.cyanAccent, fontSize: 11),
                      ),
                      trailing: const Icon(Icons.mic, color: Colors.greenAccent, size: 16),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
