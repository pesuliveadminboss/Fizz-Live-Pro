import 'package:flutter/material.dart';
import 'monetization_config.h'; // or relative import as needed

class RechargeBottomSheetUi extends StatelessWidget {
  final Function(RechargePlanModel selectedPlan) onPlanSelected;

  const RechargeBottomSheetUi({super.key, required this.onPlanSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF160C28),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.between,
            children: [
              const Text(
                '💎 Recharge Coins & Gems',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white60),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Base rate: 1,800 coins/min • Choose your pack below:',
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 320,
            child: ListView.builder(
              itemCount: MonetizationConfig.officialRechargePlans.length,
              itemBuilder: (context, index) {
                final plan = MonetizationConfig.officialRechargePlans[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: plan.isBestValue ? Colors.pink.withOpacity(0.15) : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: plan.isBestValue ? Colors.pinkAccent : Colors.white12,
                      width: plan.isBestValue ? 1.5 : 1,
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      plan.title,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text(
                      '${plan.coins} Coins + ${plan.bonusCoins} Bonus (${plan.savingsLabel})',
                      style: const TextStyle(color: Colors.amberAccent, fontSize: 11),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: plan.isBestValue ? Colors.pinkAccent : Colors.purpleAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () => onPlanSelected(plan),
                      child: Text('₹${plan.priceInINR.toInt()}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
