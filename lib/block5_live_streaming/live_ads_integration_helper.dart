import 'package:flutter/material.dart';

class LiveAdsIntegrationHelper {
  static Widget buildRightSideMiniAds() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.pinkAccent, width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.card_giftcard, color: Colors.pinkAccent, size: 18),
              SizedBox(height: 2),
              Text('Gems', style: TextStyle(color: Colors.white, fontSize: 8)),
            ],
          ),
        ),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber, width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.local_fire_department, color: Colors.amber, size: 18),
              SizedBox(height: 2),
              Text('Rank', style: TextStyle(color: Colors.white, fontSize: 8)),
            ],
          ),
        ),
      ],
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
