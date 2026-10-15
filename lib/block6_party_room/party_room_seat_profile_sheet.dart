import 'package:flutter/material.dart';
import '../block5_live_streaming/streamer_follow_manager.dart';

class PartyRoomSeatProfileSheet extends StatelessWidget {
  final String userName;
  final String role;

  const PartyRoomSeatProfileSheet({
    super.key,
    required this.userName,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final followNotifier = StreamerFollowManager().getFollowNotifier(userName);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF1D1B36),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.pinkAccent.withOpacity(0.3),
                child: const Icon(Icons.person, color: Colors.white, size: 36),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      role,
                      style: const TextStyle(color: Colors.cyanAccent, fontSize: 13),
                    ),
                  ],
                ),
              ),
              // Follow Button
              ValueListenableBuilder<bool>(
                valueListenable: followNotifier,
                builder: (context, isFollowing, child) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFollowing ? Colors.grey.shade800 : Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
                    onPressed: () {
                      StreamerFollowManager().toggleFollow(userName);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isFollowing ? 'Unfollowed $userName' : 'Successfully Followed $userName ❤️'),
                          duration: const Duration(milliseconds: 600),
                        ),
                      );
                    },
                    child: Text(
                      isFollowing ? 'Following' : 'Follow',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Message and Send Gifts Buttons matching the reference design
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening chat with $userName...'), duration: const Duration(milliseconds: 800)),
                    );
                  },
                  icon: const Icon(Icons.message, color: Colors.white, size: 18),
                  label: const Text(
                    'Message',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening gift menu for $userName...'), duration: const Duration(milliseconds: 800)),
                    );
                  },
                  icon: const Icon(Icons.card_giftcard, color: Colors.white, size: 18),
                  label: const Text(
                    'Send Gifts',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
