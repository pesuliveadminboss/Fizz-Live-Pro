import 'package:flutter/material.dart';
import 'party_room_model.dart';
import 'party_room_screen.dart';

class PartyRoomCreatorScreen extends StatefulWidget {
  const PartyRoomCreatorScreen({super.key});

  @override
  State<PartyRoomCreatorScreen> createState() => _PartyRoomCreatorScreenState();
}

class _PartyRoomCreatorScreenState extends State<PartyRoomCreatorScreen> {
  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _hostNameController = TextEditingController();
  String _selectedTheme = 'cruise';

  final List<Map<String, String>> _themes = [
    {'id': 'cruise', 'name': 'Luxury Cruise 🚢'},
    {'id': 'couple', 'name': 'Romantic Couple ❤️'},
    {'id': 'dj', 'name': 'DJ Night Party 🎉'},
    {'id': 'retro', 'name': '1980s Retro Vibe ✨'},
  ];

  @override
  void dispose() {
    _roomNameController.dispose();
    _hostNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1B36),
        title: const Text('Create Party Room', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Room Name', style: TextStyle(color: Colors.cyanAccent, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _roomNameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'e.g., Weekend Chill & Vibe',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF1D1B36),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Host Name', style: TextStyle(color: Colors.cyanAccent, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _hostNameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'e.g., Chandran S',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF1D1B36),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Select Initial Theme', style: TextStyle(color: Colors.cyanAccent, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedTheme,
              dropdownColor: const Color(0xFF1D1B36),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1D1B36),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              items: _themes.map((theme) {
                return DropdownMenuItem<String>(
                  value: theme['id'],
                  child: Text(theme['name']!, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value!;
                });
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  final roomName = _roomNameController.text.trim().isEmpty ? 'My Awesome Party Room' : _roomNameController.text.trim();
                  final hostName = _hostNameController.text.trim().isEmpty ? 'Host' : _hostNameController.text.trim();

                  final newRoom = PartyRoom(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    roomName: roomName,
                    hostName: hostName,
                    onlineCount: 1,
                    themeType: _selectedTheme,
                    seats: [hostName, 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty'],
                  );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PartyRoomScreen(room: newRoom),
                    ),
                  );
                },
                child: const Text('🚀 Launch Party Room', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
