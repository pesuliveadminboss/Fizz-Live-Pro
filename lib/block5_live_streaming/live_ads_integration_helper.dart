import 'package:flutter/material.dart';

class LiveAdsIntegrationHelper {
  static Widget buildRightSideVerticalAds() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Small Square Ad 1 with Timer 00:59:17
        Container(
          width: 40,
          height: 45,
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.pinkAccent, width: 1.2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.card_giftcard, color: Colors.pinkAccent, size: 14),
              SizedBox(height: 2),
              Text('00:59:17', style: TextStyle(color: Colors.white, fontSize: 6, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        // Small Square Ad 2
        Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.purpleAccent, width: 1.2),
          ),
          child: const Center(
            child: Icon(Icons.star, color: Colors.amber, size: 16),
          ),
        ),
        // Small Square Roulette Icon Box
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blueAccent, width: 1.2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.casino, color: Colors.cyanAccent, size: 14),
              SizedBox(height: 1),
              Text('ROULETTE', style: TextStyle(color: Colors.white, fontSize: 5, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  static Widget buildSlidingMiniAd() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.pinkAccent.withOpacity(0.85),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.timer, color: Colors.white, size: 14),
          SizedBox(width: 4),
          Text('59:17 • Ad Bonus', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  static Widget buildGridBannerAd() {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1B36),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.pinkAccent.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.monetization_on, color: Colors.amber, size: 20),
          SizedBox(width: 8),
          Text('Sponsored Ad - Watch & Earn Free Coins', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

