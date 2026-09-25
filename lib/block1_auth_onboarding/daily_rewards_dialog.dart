import 'package:flutter/material.dart';

class DailyRewardsDialog extends StatelessWidget {
  const DailyRewardsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E1E2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Daily rewards', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const Text('Sign in for 7 days to get a surprise', style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildRewardCard('Day 1', '40 Gems'),
                  _buildRewardCard('Day 2', 'Card 1'),
                  _buildRewardCard('Day 3', '50 Gems'),
                  _buildRewardCard('Day 4', '90 Gems'),
                  _buildRewardCard('Day 5', '120 Gems'),
                  _buildRewardCard('Day 6', '180 Gems'),
                  _buildGiftBoxCard('Day 7', '🎁 200 Gems'),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE94057),
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Checked-in successfully! Gems added.')));
                  Navigator.pop(context);
                },
                child: const Text('Check-in', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardCard(String day, String reward) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(day, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(reward, style: const TextStyle(color: Colors.amber, fontSize: 10), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildGiftBoxCard(String day, String reward) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFFE94057).withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.pinkAccent),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(day, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(reward, style: const TextStyle(color: Colors.pinkAccent, fontSize: 9), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
