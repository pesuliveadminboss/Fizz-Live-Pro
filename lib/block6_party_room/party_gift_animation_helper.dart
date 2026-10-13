import 'package:flutter/material.dart';

class PartyGiftAnimationHelper {
  static void showPartyGiftAnimation(BuildContext context, String giftName, String senderName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.card_giftcard, color: Colors.pinkAccent, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$senderName sent a cinematic $giftName! 🚢✨',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2A1B4E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
