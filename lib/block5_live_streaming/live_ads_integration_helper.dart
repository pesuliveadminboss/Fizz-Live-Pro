import 'package:flutter/material.dart';

class LiveAdsIntegrationHelper {
  static Widget buildRightSideVerticalAds() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Ad with Timer 00:59:17
        Container(
          width: 48,
          height: 55,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.pinkAccent, width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.card_giftcard, color: Colors.pinkAccent, size: 16),
              SizedBox(height: 2),
              Text('00:59:17', style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        // Mini Banner Ad 2
        Container(
          width: 48,
          height: 48,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.purpleAccent, width: 1.5),
          ),
          child: const Center(
            child: Icon(Icons.star, color: Colors.amber, size: 20),
          ),
        ),
        // Roulette Icon Box
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blueAccent, width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.casino, color: Colors.cyanAccent, size: 16),
              SizedBox(height: 2),
              Text('ROULETTE', style: TextStyle(color: Colors.white, fontSize: 6, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}
