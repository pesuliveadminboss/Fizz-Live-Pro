import 'package:flutter/material.dart';

class DailyRewardsDialog extends StatefulWidget {
  const DailyRewardsDialog({super.key});

  @override
  State<DailyRewardsDialog> createState() => _DailyRewardsDialogState();
}

class _DailyRewardsDialogState extends State<DailyRewardsDialog> {
  // Simulated tracking state (In production, stored locally via SharedPreferences with secure real date check)
  static int currentStreakDay = 1; 
  static String? lastClaimDate;

  bool _isTodayClaimed = false;

  @override
  void initState() {
    super.initState();
    _validateRealCalendarDate();
  }

  void _validateRealCalendarDate() {
    final todayStr = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
    if (lastClaimDate != null) {
      final lastDate = DateTime.parse(lastClaimDate!);
      final currentDate = DateTime.now();
      final difference = currentDate.difference(lastDate).inDays;

      // If user skipped more than 1 calendar day, reset streak back to Day 1
      if (difference > 1) {
        currentStreakDay = 1;
      }
    }
  }

  void _handleCheckIn() {
    final todayStr = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
    
    if (lastClaimDate == todayStr) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have already claimed today\'s reward. Come back tomorrow!')),
      );
      return;
    }

    setState(() {
      lastClaimDate = todayStr;
      _isTodayClaimed = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Successfully claimed Day $currentStreakDay reward! 🎉')),
    );

    // If 7 days completed, reset or finish
    if (currentStreakDay >= 7) {
      currentStreakDay = 1; // Loop back or finish
    } else {
      currentStreakDay++;
    }

    Navigator.pop(context);
  }

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
                  _buildRewardCard(1, '40 Gems'),
                  _buildRewardCard(2, 'Card 1'),
                  _buildRewardCard(3, '50 Gems'),
                  _buildRewardCard(4, '90 Gems'),
                  _buildRewardCard(5, '120 Gems'),
                  _buildRewardCard(6, '180 Gems'),
                  _buildGiftBoxCard(7, '🎁 200 Gems'),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE94057),
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                ),
                onPressed: _isTodayClaimed ? null : _handleCheckIn,
                child: Text(_isTodayClaimed ? 'Claimed for Today' : 'Check-in', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardCard(int dayNumber, String reward) {
    bool isCurrent = (currentStreakDay == dayNumber);
    bool isPassed = (currentStreakDay > dayNumber);

    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: isCurrent ? const Color(0xFFE94057).withOpacity(0.3) : Colors.black38,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isCurrent ? Colors.pinkAccent : (isPassed ? Colors.green : Colors.white12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Day $dayNumber', style: TextStyle(color: isPassed ? Colors.green : Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(isPassed ? 'Claimed' : reward, style: TextStyle(color: isPassed ? Colors.greenAccent : Colors.amber, fontSize: 10), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildGiftBoxCard(int dayNumber, String reward) {
    bool isCurrent = (currentStreakDay == dayNumber);
    bool isPassed = (currentStreakDay > dayNumber);

    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: isCurrent ? const Color(0xFFE94057).withOpacity(0.4) : Colors.black38,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isCurrent ? Colors.pinkAccent : Colors.white12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Day $dayNumber', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(isPassed ? 'Claimed' : reward, style: const TextStyle(color: Colors.pinkAccent, fontSize: 9), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
