import 'package:flutter/material.dart';

class PartyMultiSeatRoomScreen extends StatelessWidget {
  final dynamic streamer;
  const PartyMultiSeatRoomScreen({super.key, required this.streamer});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> seats = [
      {'name': 'Beauty', 'diamond': '0', 'isOccupied': true},
      {'name': 'Ms.Maee', 'diamond': '30', 'isOccupied': true},
      {'name': 'Sweet...', 'diamond': '1.54k', 'isOccupied': true},
      {'name': 'Fariya', 'diamond': '370', 'isOccupied': true},
      {'name': 'Jiy...', 'diamond': '1.15k', 'isOccupied': true},
      {'name': 'pooja...', 'diamond': '820', 'isOccupied': true},
      {'name': 'Seat 7', 'diamond': '0', 'isOccupied': false},
      {'name': 'Seat 8', 'diamond': '0', 'isOccupied': false},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF130F25),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black45,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          children: [
                            const CircleAvatar(radius: 12, backgroundColor: Colors.amber),
                            const SizedBox(width: 6),
                            const Text('Room', style: TextStyle(color: Colors.white, fontSize: 11)),
                            const SizedBox(width: 6),
                            Container(width: 18, height: 18, decoration: const BoxDecoration(color: Colors.pinkAccent, shape: BoxShape.circle), child: const Icon(Icons.add, size: 12, color: Colors.white)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(16)),
                        child: const Row(
                          children: [
                            Icon(Icons.favorite, color: Colors.pinkAccent, size: 12),
                            SizedBox(width: 4),
                            Text('33.9k', style: TextStyle(color: Colors.white, fontSize: 11)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(16)),
                        child: const Row(
                          children: [
                            Icon(Icons.bar_chart, color: Colors.amber, size: 12),
                            SizedBox(width: 4),
                            Text('Hourly Rank', style: TextStyle(color: Colors.white, fontSize: 10)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(16)),
                        child: const Row(
                          children: [
                            Icon(Icons.diamond, color: Colors.amber, size: 12),
                            SizedBox(width: 4),
                            Text('13 ×', style: TextStyle(color: Colors.white, fontSize: 11)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: GridView.builder(
                      itemCount: seats.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.72,
                      ),
                      itemBuilder: (_, index) {
                        final seat = seats[index];
                        final occupied = seat['isOccupied'] as bool;
                        final seatName = seat['name'] as String;
                        final seatDiamond = seat['diamond'] as String;
                        return Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor: occupied ? Colors.purple.withOpacity(0.4) : Colors.white12,
                                  child: Icon(occupied ? Icons.person : Icons.mic_off, size: 22, color: occupied ? Colors.white : Colors.white38),
                                ),
                                if (occupied)
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                                      child: const Icon(Icons.mic, size: 8, color: Colors.white),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              seatName,
                              style: const TextStyle(color: Colors.white, fontSize: 10),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '💎 $seatDiamond',
                              style: const TextStyle(color: Colors.amber, fontSize: 9),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  height: 220,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2E1A47), Color(0xFF0F0B1E)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade700,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('18+ ONLY', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 9)),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.shade900.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.amber, width: 1.5),
                            ),
                            child: const Column(
                              children: [
                                Text('SLOTS', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: 2)),
                                SizedBox(height: 6),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star, color: Colors.amber, size: 16),
                                    Icon(Icons.star, color: Colors.amber, size: 16),
                                    Icon(Icons.star, color: Colors.amber, size: 16),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text('Loading...', style: TextStyle(color: Color(0xBFFFFFFF), fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 14,
            left: 12,
            right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    CircleAvatar(radius: 18, backgroundColor: Colors.white24, child: Icon(Icons.mic, size: 16, color: Colors.white)),
                    SizedBox(width: 8),
                    CircleAvatar(radius: 18, backgroundColor: Colors.white24, child: Icon(Icons.grid_view, size: 16, color: Colors.white)),
                    SizedBox(width: 8),
                    CircleAvatar(radius: 18, backgroundColor: Colors.amber, child: Icon(Icons.card_giftcard, size: 16, color: Colors.black)),
                  ],
                ),
                Row(
                  children: [
                    CircleAvatar(radius: 18, backgroundColor: Colors.pinkAccent, child: Icon(Icons.videogame_asset, size: 16, color: Colors.white)),
                    const SizedBox(width: 8),
                    CircleAvatar(radius: 18, backgroundColor: Colors.cyan, child: Icon(Icons.casino, size: 16, color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

