import 'package:flutter/material.dart';

class MatchProfileWidget extends StatelessWidget {
  final String userName;
  final String userAge;
  final String userLocation;
  final bool isFollowing;
  final VoidCallback onToggleFollow;
  final VoidCallback onNextMatch;
  final VoidCallback onOpenChat;

  const MatchProfileWidget({
    super.key,
    required this.userName,
    required this.userAge,
    required this.userLocation,
    required this.isFollowing,
    required this.onToggleFollow,
    required this.onNextMatch,
    required this.onOpenChat,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      left: 16,
      right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // User Profile Info Card
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.pinkAccent.withOpacity(0.6),
                child: const Icon(Icons.person, size: 32, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '$userName, $userAge',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.verified, color: Colors.cyanAccent, size: 16),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    userLocation,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Follow Button
              GestureDetector(
                onTap: onToggleFollow,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isFollowing ? Colors.grey.shade800 : Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isFollowing ? 'Following' : 'Follow',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Action Buttons (Next Match & Chat)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton.extended(
                heroTag: 'next_match_btn',
                backgroundColor: Colors.redAccent,
                onPressed: onNextMatch,
                icon: const Icon(Icons.shuffle, color: Colors.white),
                label: const Text('Next Match', style: TextStyle(color: Colors.white)),
              ),
              FloatingActionButton.extended(
                heroTag: 'match_chat_btn',
                backgroundColor: Colors.green,
                onPressed: onOpenChat,
                icon: const Icon(Icons.chat, color: Colors.white),
                label: const Text('Chat', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
