import 'package:flutter/material.dart';

class PartyGiftAnimationHelper {
  static void showPartyGiftAnimation(BuildContext context, String giftName, String senderName) {
    // Show Cinematic SnackBar
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

    // Show Pop-up Scale Animation Dialog for visual effect
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Opacity(
                  opacity: value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2A1B4E), Color(0xFFFF2E93)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pinkAccent.withOpacity(0.6),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                      border: Border.all(color: Colors.amber, width: 2),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.card_giftcard, color: Colors.amber, size: 50),
                        const SizedBox(height: 10),
                        Text(
                          '$senderName sent $giftName! 🎁',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '✨ Spectacular Gift Effect ✨',
                          style: TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 12,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );

    // Auto dismiss dialog after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });
  }
}
