import 'package:flutter/material.dart';
import '../1_core/core_data.dart';

class GemRechargePlan {
  final int gems;
  final String discountTag;
  final double priceINR;

  const GemRechargePlan({
    required this.gems,
    required this.discountTag,
    required this.priceINR,
  });
}

final List<GemRechargePlan> exactGemsPlans = [
  const GemRechargePlan(gems: 4050, discountTag: '', priceINR: 100),
  const GemRechargePlan(gems: 8100, discountTag: '17% off', priceINR: 200),
  const GemRechargePlan(gems: 16380, discountTag: '17% off', priceINR: 400),
  const GemRechargePlan(gems: 32940, discountTag: '17% off', priceINR: 800),
  const GemRechargePlan(gems: 66600, discountTag: '30% off', priceINR: 1600),
  const GemRechargePlan(gems: 167400, discountTag: '60% off', priceINR: 4000),
];

void showGemsVideoCallRechargeModal(BuildContext context) {
  int selectedIndex = 0;

  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF140D26),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (ctx) => StatefulBuilder(
      builder: (context, setModalState) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 24),
                const Column(
                  children: [
                    Text('Make video calls with Gems', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2),
                    Text('Call beauties with Gems', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 18),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.92,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: exactGemsPlans.length,
              itemBuilder: (_, index) {
                final plan = exactGemsPlans[index];
                final isSelected = selectedIndex == index;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onTap: () => setModalState(() => selectedIndex = index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.amber.withOpacity(0.18) : Colors.white.withOpacity(0.06),
                          border: Border.all(
                            color: isSelected ? Colors.amber : Colors.white24,
                            width: isSelected ? 1.8 : 1,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.diamond, color: Colors.amber, size: 24),
                            const SizedBox(height: 6),
                            Text('${plan.gems}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.amber : Colors.white12,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '₹${plan.priceINR.toInt()}.00',
                                style: TextStyle(
                                  color: isSelected ? Colors.black : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (plan.discountTag.isNotEmpty)
                      Positioned(
                        top: -6, right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(plan.discountTag, style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.diamond, color: Colors.amber, size: 16),
                const SizedBox(width: 6),
                ValueListenableBuilder<int>(
                  valueListenable: globalWallet,
                  builder: (_, balance, __) => Text(
                    'My Gems: $balance',
                    style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                final chosen = exactGemsPlans[selectedIndex];
                globalWallet.value += chosen.gems;
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Recharged ${chosen.gems} gems successfully! New balance: 💎 ${globalWallet.value}')),
                );
              },
              child: Container(
                width: double.infinity, height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.purpleAccent]),
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.center,
                child: const Text('Continue', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
