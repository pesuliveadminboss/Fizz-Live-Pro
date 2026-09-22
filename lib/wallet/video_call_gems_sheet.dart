import 'package:flutter/material.dart';

void showVideoCallGemsSheet(BuildContext context, int currentGems) {
  final packages = [
    {'gems': 4050, 'price': '₹100.00', 'tag': '17% off'},
    {'gems': 8100, 'price': '₹200.00', 'tag': '17% off'},
    {'gems': 16380, 'price': '₹400.00', 'tag': '17% off'},
    {'gems': 32940, 'price': '₹800.00', 'tag': '17% off'},
    {'gems': 66600, 'price': '₹1,600.00', 'tag': '30% off'},
    {'gems': 167400, 'price': '₹4,000.00', 'tag': '60% off'},
  ];

  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF1F1A24),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (ctx) => Container(
      padding: const EdgeInsets.all(16),
      height: 480,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 24),
              const Column(
                children: [
                  Text('Make video calls with Gems', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                  Text('Call beauties with Gems', style: TextStyle(color: Colors.white54, fontSize: 11)),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.pop(ctx),
                child: const Icon(Icons.close, color: Colors.white70, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: packages.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (_, index) {
                final p = packages[index];
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C223C),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.amber.withOpacity(0.4)),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.diamond, color: Colors.amber, size: 20),
                          const SizedBox(height: 4),
                          Text('${p['gems']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(10)),
                            child: Text(p['price'] as String, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: const BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.horizontal(left: Radius.circular(8), right: Radius.circular(14))),
                        child: Text(p['tag'] as String, style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.diamond, color: Colors.amber, size: 14),
              const SizedBox(width: 4),
              Text('My Gems: $currentGems', style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recharge package selected!')));
              },
              child: const Text('Continue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    ),
  );
}
