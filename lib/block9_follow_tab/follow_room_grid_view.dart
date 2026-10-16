import 'package:flutter/material.dart';
import 'follow_tab_model.dart';

class FollowRoomGridView extends StatelessWidget {
  final List<FollowTabModel> followedRooms;
  final Function(FollowTabModel) onUnfollow;

  const FollowRoomGridView({
    super.key,
    required this.followedRooms,
    required this.onUnfollow,
  });

  @override
  Widget build(BuildContext context) {
    if (followedRooms.isEmpty) {
      const centerText = 'No followed party rooms yet. Explore Party Hub to follow rooms!';
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            centerText,
            style: TextStyle(color: Colors.white60, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: followedRooms.length,
      itemBuilder: (context, index) {
        final room = followedRooms[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1D1B36),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            children: [
              // Room Avatar / Icon
              Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  color: Colors.pinkAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.pinkAccent, width: 1.5),
                ),
                child: const Icon(Icons.headset_mic, color: Colors.pinkAccent, size: 28),
              ),
              const SizedBox(width: 14),
              // Room Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          room.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.cyan.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            room.status,
                            style: const TextStyle(
                              color: Colors.cyanAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      room.details,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Enter Room Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Entering ${room.name}...'), duration: const Duration(seconds: 1)),
                  );
                },
                child: const Text('Join', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
        );
      },
    );
  }
}
