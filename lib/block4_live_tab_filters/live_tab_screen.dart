import 'package:flutter/material.dart';
import 'live_stream_model_and_filters.dart';
import 'category_filter_cards_widget.dart';
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
    final filteredStreamers = _selectedCategory == 'Hot'
        ? kLiveStreamers
        : kLiveStreamers.where((s) => s.category == _selectedCategory).toList();

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Filter Cards Widget
          CategoryFilterCardsWidget(
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Live Streamers',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),

          // Live Streamers Grid View
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredStreamers.length,
              itemBuilder: (context, index) {
                final streamer = filteredStreamers[index];

                return GestureDetector(
                  onTap: () {
                    // Clicking streamer box opens Live Room Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LiveRoomScreen(streamerName: streamer.name),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2C),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            color: Colors.pinkAccent.withOpacity(0.3),
                            child: Center(
                              child: Text(
                                streamer.name[0],
                                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white24),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE94057),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                streamer.category,
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    streamer.name,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '👥 ${streamer.viewers} watching',
                                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
