import 'package:flutter/material.dart';

class PartyRoomScreen extends StatefulWidget {
  const PartyRoomScreen({super.key});

  @override
  State<PartyRoomScreen> createState() => _PartyRoomScreenState();
}

class _PartyRoomScreenState extends State<PartyRoomScreen> {
  final List<Map<String, dynamic>> _seats = List.generate(8, (index) {
    if (index == 0) return {'name': 'Host (Karthik)', 'isHost': true, 'isMuted': false, 'occupied': true};
    if (index == 1) return {'name': 'Anitha', 'isHost': false, 'isMuted': true, 'occupied': true};
    if (index == 3) return {'name': 'Priya', 'isHost': false, 'isMuted': false, 'occupied': true};
    return {'name': 'Empty', 'isHost': false, 'isMuted': false, 'occupied': false};
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        title: const Text('Tamil Chill Voice Party 🎙️'),
        actions: [
          IconButton(
            icon: const Icon(Icons.people_outline),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF1E1E2C),
            child: const Text(
              'Topic: Late night talks & movie reviews 🍿 (No toxic chat)',
              style: TextStyle(color: Colors.white70, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
              itemCount: 8,
              itemBuilder: (context, index) {
                final seat = _seats[index];
                final occupied = seat['occupied'] as bool;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: occupied ? const Color(0xFFE94057) : Colors.white12,
                          child: Icon(
                            occupied ? Icons.person : Icons.add,
                            color: occupied ? Colors.white : Colors.white38,
                          ),
                        ),
                        if (seat['isHost'] == true)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.amber,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.star, size: 10, color: Colors.black),
                            ),
                          ),
                        if (seat['isMuted'] == true)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.mic_off, size: 10, color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      seat['name'],
                      style: TextStyle(
                        fontSize: 11,
                        color: occupied ? Colors.white : Colors.white38,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF1E1E2C),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.mic, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.card_giftcard, color: Color(0xFFE94057)),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.front_hand, color: Colors.amber),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
