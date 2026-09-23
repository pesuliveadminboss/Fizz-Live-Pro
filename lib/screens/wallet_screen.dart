import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  final List<Map<String, dynamic>> _rechargePackages = const [
    {'gems': 100, 'price': '₹85'},
    {'gems': 500, 'price': '₹420'},
    {'gems': 1200, 'price': '₹999'},
    {'gems': 5000, 'price': '₹3,999'},
  ];

  final List<Map<String, dynamic>> _transactions = const [
    {'title': 'Recharge 500 Gems', 'date': 'Today, 2:15 PM', 'amount': '+500 Gems', 'isCredit': true},
    {'title': 'Gift sent to Anitha_Live', 'date': 'Yesterday, 10:40 PM', 'amount': '-50 Gems', 'isCredit': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet & Gems 💎'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8A2387), Color(0xFFE94057)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: const [
                  Text('Available Balance', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.diamond, color: Colors.amberAccent, size: 28),
                      SizedBox(width: 8),
                      Text('450', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Recharge Packages', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: _rechargePackages.length,
              itemBuilder: (context, index) {
                final pkg = _rechargePackages[index];
                return InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Purchasing ${pkg['gems']} Gems for ${pkg['price']}...')),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2C),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.diamond, color: Colors.amberAccent, size: 20),
                            const SizedBox(width: 6),
                            Text('${pkg['gems']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE94057),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(pkg['price'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final tx = _transactions[index];
                final isCredit = tx['isCredit'] as bool;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: isCredit ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                    child: Icon(
                      isCredit ? Icons.add : Icons.remove,
                      color: isCredit ? Colors.greenAccent : Colors.redAccent,
                    ),
                  ),
                  title: Text(tx['title']!),
                  subtitle: Text(tx['date']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  trailing: Text(
                    tx['amount']!,
                    style: TextStyle(
                      color: isCredit ? Colors.greenAccent : Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
