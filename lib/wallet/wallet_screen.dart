import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  final int initialCoins;
  const WalletScreen({super.key, this.initialCoins = 5000});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late int currentCoins;

  final List<Map<String, dynamic>> rechargePackages = [
    {'coins': 500, 'price': '₹49', 'bonus': '+50 free'},
    {'coins': 1200, 'price': '₹99', 'bonus': '+150 free'},
    {'coins': 3000, 'price': '₹249', 'bonus': '+500 free'},
    {'coins': 10000, 'price': '₹799', 'bonus': '+2000 free'},
  ];

  @override
  void initState() {
    super.initState();
    currentCoins = widget.initialCoins;
  }

  void _topUp(int coins, String price) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1F1A24),
        title: const Text('Confirm Top-Up', style: TextStyle(color: Colors.white, fontSize: 16)),
        content: Text('Recharge $coins diamonds for $price via UPI/Mock?', style: const TextStyle(color: Color(0xBFFFFFFF), fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                currentCoins += coins;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Top-up successful! Added 💎 $coins'), backgroundColor: Colors.green),
              );
            },
            child: const Text('Pay Now'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0B1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0B1E),
        title: const Text('My Wallet 💎', style: TextStyle(color: Colors.white, fontSize: 16)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E1A47), Color(0xFF1F1A24)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Balance', style: TextStyle(color: Color(0x99FFFFFF), fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.diamond, color: Colors.amber, size: 28),
                      const SizedBox(width: 8),
                      Text('$currentCoins', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Top-Up Packages', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.3,
                ),
                itemCount: rechargePackages.length,
                itemBuilder: (_, index) {
                  final pkg = rechargePackages[index];
                  return GestureDetector(
                    onTap: () => _topUp(pkg['coins'] as int, pkg['price'] as String),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F1A24),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.diamond, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text('${pkg['coins']}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(pkg['bonus'] as String, style: const TextStyle(color: Colors.pinkAccent, fontSize: 10)),
                          const Spacer(),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.pinkAccent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(pkg['price'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

