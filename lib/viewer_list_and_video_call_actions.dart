import 'package:flutter/material.dart';

class ViewerListAndVideoCallActions extends StatelessWidget {
  final int viewersCount;
  final VoidCallback onViewersListTap;
  final VoidCallback onGiftTap;
  final VoidCallback onVideoCallTap;

  const ViewerListAndVideoCallActions({
    Key? key,
    required this.viewersCount,
    required this.onViewersListTap,
    required this.onGiftTap,
    required this.onVideoCallTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Viewer Count Indicator (Clickable to show viewer list popup)
        GestureDetector(
          onTap: onViewersListTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.remove_red_eye, color: Colors.white, size: 14),
                const SizedBox(width: 4),
                Text(
                  '$viewersCount',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
        ),

        // Right side action buttons: Gift, Follow, and 1-to-1 Video Call
        Row(
          children: [
            // Gift Icon Button
            IconButton(
              icon: const Icon(Icons.card_giftcard, color: Colors.pinkAccent, size: 24),
              onPressed: onGiftTap,
            ),
            const SizedBox(width: 8),

            // 1-to-1 Video Call Trigger Button (Matching Screenshot 1 & 4 style)
            ElevatedButton.icon(
              onPressed: onVideoCallTap,
              icon: const Icon(Icons.video_call, color: Colors.white, size: 18),
              label: const Text(
                'Video Call',
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

