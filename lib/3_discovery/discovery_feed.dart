import 'package:flutter/material.dart';
import '../1_core/core_data.dart';
import '../4_interactions/call_and_party_screens.dart';

final mockHosts = [
  {'name': 'Sneha', 'pic': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200', 'flag': '🇮🇳', 'rate': 1800},
  {'name': 'Priya', 'pic': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200', 'flag': '🇮🇳', 'rate': 1800},
];

class DiscoveryFeedView extends StatelessWidget {
  const DiscoveryFeedView({super.key});

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomCallScreen(hostName: 'Fast Match Creator', ratePerMin: 1800))),
            child: Container(
              width: double.infinity, height: 56,
              decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.purpleAccent]), borderRadius: BorderRadius.circular(28)),
              alignment: Alignment.center,
              child: const Text('⚡ Start Random Video Call (1800 gems/min)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Online Creators Ready', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: mockHosts.length,
              itemBuilder: (ctx, i) {
                final h = mockHosts[i];
                return Card(
                  color: AppTheme.cardDark,
                  child: ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(h['pic'] as String)),
                    title: Text('${h['name']} ${h['flag']}', style: const TextStyle(color: Colors.white)),
                    subtitle: Text('${h['rate']} gems/min • Live Now', style: const TextStyle(color: Colors.white54, fontSize: 11)),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryPink),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CustomCallScreen(hostName: h['name'] as String, ratePerMin: h['rate'] as int))),
                      child: const Text('Call', style: TextStyle(color: Colors.white)),
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

