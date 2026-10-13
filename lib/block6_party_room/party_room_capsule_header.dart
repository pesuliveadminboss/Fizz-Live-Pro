import 'package:flutter/material.dart';

class PartyRoomCapsuleHeader extends StatelessWidget {
  final String hostName;
  final int onlineCount;
  final VoidCallback onProfileTap;
  final VoidCallback onFollowTap;
  final bool isFollowing;

  const PartyRoomCapsuleHeader({
    super.key,
    required this.hostName,
    required this.onlineCount,
    required this.onProfileTap,
    required this.onFollowTap,
    required this.isFollowing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Capsule Profile Tap Area (Jumps to Full Profile)
          GestureDetector(
            onTap: onProfileTap,
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.pinkAccent,
                  child: Icon(Icons.person, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      hostName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.circle, color: Colors.greenAccent, size: 8),
                        const SizedBox(width: 4),
                        Text(
                          '$onlineCount Online',
                          style: const TextStyle(color: Colors.cyanAccent, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Synced Follow Button
          SizedBox(
            height: 28,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isFollowing ? Colors.white24 : Colors.pinkAccent,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: onFollowTap,
              child: Text(
                isFollowing ? 'Following' : 'Follow',
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

