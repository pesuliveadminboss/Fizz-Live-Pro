import 'package:flutter/material.dart';
import '../1_core/core_data.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: AppTheme.cardDark,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('My Gem Balance', style: TextStyle(color: Colors.white70, fontSize: 15)),
                  ValueListenableBuilder<int>(
                    valueListenable: globalWallet,
                    builder: (_, val, __) => Text('💎 $val gems', style: const TextStyle(color: Colors.amber, fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Instant Recharge Packs (UPI)', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ListTile(
            tileColor: AppTheme.cardDark,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text('₹100 Pack', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: const Text('Get 4,050 Gems (1800 gems/min standard rate)', style: TextStyle(color: Colors.white54, fontSize: 12)),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryPink),
              onPressed: () {
                globalWallet.add(4050);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('UPI Intent Verified: +4050 Gems credited!')));
              },
              child: const Text('Pay ₹100', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

