import 'package:flutter/material.dart';

class PartyRoomCreatorScreen extends StatefulWidget {
  const PartyRoomCreatorScreen({super.key});

  @override
  State<PartyRoomCreatorScreen> createState() => _PartyRoomCreatorScreenState();
}

class _PartyRoomCreatorScreenState extends State<PartyRoomCreatorScreen> {
  final TextEditingController _roomNameController = TextEditingController();
  String _selectedTheme = 'party_ship_cinematic';

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1B36),
        title: const Text('Create Party Room 🚢', style: TextStyle(color: Colors.white, fontSize: 16)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Compact AdMob Safe Slot
            Container(
              height: 35,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1D1B36),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white10),
              ),
              child: const Center(
                child: Text(
                  "AdMob Creator Banner [Button Size]",
                  style: TextStyle(color: Colors.white54, fontSize: 10),
                ),
              ),
            ),
            const Text(
              'Room Name',
              style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _roomNameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter cinematic party room name...',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF1D1B36),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Cinematic Theme',
              style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildThemeChip('Party Ship', 'party_ship_cinematic'),
                const SizedBox(width: 10),
                _buildThemeChip('Royal Night', 'royal_night'),
                const SizedBox(width: 10),
                _buildThemeChip('DJ Club', 'dj_club'),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (_roomNameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a room name!')),
                    );
                    return;
                  }
                  Navigator.pop(context, {
                    'roomName': _roomNameController.text.trim(),
                    'theme': _selectedTheme,
                  });
                },
                child: const Text(
                  'Launch Party Room 🚀',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeChip(String label, String themeValue) {
    bool isSelected = _selectedTheme == themeValue;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTheme = themeValue;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.pinkAccent.withOpacity(0.3) : const Color(0xFF1D1B36),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? Colors.pinkAccent : Colors.white12,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.pinkAccent : Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
