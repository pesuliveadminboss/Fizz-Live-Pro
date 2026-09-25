import 'package:flutter/material.dart';

class DailyRewardsDialog extends StatelessWidget {
  const DailyRewardsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2C),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Close Button matching Screenshot 11
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily rewards',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.pinkAccent),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Sign in for 7 days\nto get a surprise',
                      style: TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 7 Days Grid Items matching Screenshot 11
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                _buildRewardCard('Day 1', '40 Gems', true),
                _buildRewardCard('Day 2', 'Card 1', false),
                _buildRewardCard('Day 3', '50 Gems', false),
                _buildRewardCard('Day 4', '90 Gems', false),
                _buildRewardCard('Day 5', '120 Gems', false),
                _buildRewardCard('Day 6', '180 Gems', false),
                _buildRewardCard('Day 7', 'Mystery Box', false, isSpecial: true),
              ],
            ),
            const SizedBox(height: 24),

            // Check-in Button matching Screenshot 11
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700), // Golden check-in button style
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Daily reward claimed successfully! 🎉')),
                  );
                  Navigator.pop(context);
                },
                child: const Text(
                  'Check-in',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardCard(String day, String reward, bool isSelected, {bool isSpecial = false}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.pinkAccent.withOpacity(0.2) : Colors.black26,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? Colors.pinkAccent : Colors.white12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(day, style: const TextStyle(fontSize: 10, color: Colors.white54)),
          const SizedBox(height: 4),
          Icon(
            isSpecial ? Icons.card_giftcard : Icons.monetization_on,
            color: isSpecial ? Colors.purpleAccent : Colors.amber,
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            reward,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
