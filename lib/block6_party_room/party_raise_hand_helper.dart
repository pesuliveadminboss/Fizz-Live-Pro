import 'package:flutter/material.dart';

class PartyRaiseHandHelper {
  static void showRaiseHandNotification(BuildContext context, String userName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.back_hand, color: Colors.cyanAccent, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$userName raised hand to join the mic 🙋‍♂️',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1D1B36),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
