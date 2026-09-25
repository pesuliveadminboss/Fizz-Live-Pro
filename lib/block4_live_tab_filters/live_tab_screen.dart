import 'package:flutter/material.dart';
import '../block5_live_room_immersive/live_room_screen.dart';

class LiveTabScreen extends StatefulWidget {
  const LiveTabScreen({super.key});

  @override
  State<LiveTabScreen> createState() => _LiveTabScreenState();
}

class _LiveTabScreenState extends State<LiveTabScreen> {
  String _selectedCategory = 'Hot';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            children: ['Hot', 'Pretty', 'New', 'Sexy'].map((cat) {
              bool isSelected = _selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: const Color(0xFFE94057),
                  backgroundColor: const Color(0xFF1E1E2C),
                  labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white70),
                  onSelected: (val) => setState(() => _selectedCategory = cat),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LiveRoomScreen(streamerName: 'Live Streamer')));
                },
                child: Container(
                  decoration: BoxDecoration(color: const Color(0xFF1E1E2C), borderRadius: BorderRadius.circular(16)),
                  child: Stack(
                    children: [
                      const Center(child: Icon(Icons.live_tv, size: 50, color: Colors.white24)),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFE94057), borderRadius: BorderRadius.circular(8)),
                          child: Text(_selectedCategory, style: const TextStyle(color: Colors.white, fontSize: 9)),
                        ),
                      ),
                      const Positioned(
                        bottom: 8,
                        left: 8,
                        child: Text('Live Streamer Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
