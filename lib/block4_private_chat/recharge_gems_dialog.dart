import 'package:flutter/material.dart';

class RechargeGemsDialog extends StatefulWidget {
  const RechargeGemsDialog({super.key});

  @override
  State<RechargeGemsDialog> createState() => _RechargeGemsDialogState();
}

class _RechargeGemsDialogState extends State<RechargeGemsDialog> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _packages = [
    {'gems': '4050', 'price': '₹100.00', 'discount': '17% OFF', 'isOnce': true},
    {'gems': '8100', 'price': '₹200.00', 'discount': '17% OFF', 'isOnce': false},
    {'gems': '16380', 'price': '₹400.00', 'discount': '17% OFF', 'isOnce': false},
    {'gems': '32940', 'price': '₹800.00', 'discount': '17% OFF', 'isOnce': false},
    {'gems': '66600', 'price': '₹1,600.00', 'discount': '30% OFF', 'isOnce': false},
    {'gems': '167400', 'price': '₹4,000.00', 'discount': '60% OFF', 'isOnce': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF1D1B36),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row with Close Button
            Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFF6366F1),
                  child: Icon(Icons.person, size: 20, color: Colors.white),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'You want to see me? Recharge and we can continue 💋',
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Gem Packages Grid (matching reference screenshot 8)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.9,
              ),
              itemCount: _packages.length,
              itemBuilder: (context, index) {
                final pkg = _packages[index];
                final isSelected = _selectedIndex == index;

                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF121026),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFF97316) : Colors.white10,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        if (pkg['discount'] != null)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(16),
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                              child: Text(pkg['discount'], style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.diamond, color: Colors.amber, size: 24),
                              const SizedBox(height: 4),
                              Text(pkg['gems'], style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1D1B36),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(pkg['price'], style: const TextStyle(color: Colors.white70, fontSize: 11)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // My Gems Balance & Continue Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('My Gems: 1670', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                Icon(Icons.diamond, color: Colors.amber, size: 18),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEC4899),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Recharge successful! Continuing call...')),
                );
              },
              child: const Text('Continue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
