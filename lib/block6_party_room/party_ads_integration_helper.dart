import 'package:flutter/material.dart';

class PartyAdsIntegrationHelper extends StatelessWidget {
  const PartyAdsIntegrationHelper({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1B36),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: const Center(
        child: Text(
          "AdMob Party Room Safe Banner Slot [Button Size]",
          style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
