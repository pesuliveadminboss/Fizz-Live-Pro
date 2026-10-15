import 'package:flutter/material.dart';
import '../block5_live_streaming/streamer_follow_manager.dart';
import 'gift_bottom_sheet.dart';
// பிரைவேட் சாட் ஸ்கிரீன் ரூட் சரியாக இணைக்கப்பட்டுள்ளது
import '../../lib/private_chat_screen.dart'; // அல்லது ப்ராஜெக்ட் அமைப்பிற்கு ஏற்ப சரியான பாத்

class PartyRoomSeatProfileSheet extends StatelessWidget {
  final String userName;
  final String role;
  final Function(String giftName, int quantity)? onSendGift;

  const PartyRoomSeatProfileSheet({
    super.key,
    required this.userName,
    required this.role,
    this.onSendGift,
  });

  @override
  Widget build(BuildContext context) {
    final followNotifier = StreamerFollowManager().getFollowNotifier(userName);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: const BoxDecoration(
        color: Color(0xFF1D1B36),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Wrap(
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.pinkAccent,
                child: Icon(Icons.person, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      role,
                      style: const TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ValueListenableBuilder<bool>(
                valueListenable: followNotifier,
                builder: (context, isFollowing, child) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFollowing ? Colors.grey.shade800 : Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrivateChatScreen(streamerName: userName),
                      ),
                    );
                  },
                  icon: const Icon(Icons.message, color: Colors.white, size: 16),
                  label: const Text(
                    'Message',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
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
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return GiftBottomSheet(
                          onSendGift: (giftName, quantity) {
                            if (onSendGift != null) {
                              onSendGift!(giftName, quantity);
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Sent $giftName x$quantity to $userName 🎁'), duration: const Duration(milliseconds: 1000)),
                            );
                          },
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.card_giftcard, color: Colors.white, size: 16),
                  label: const Text(
                    'Send Gifts',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
