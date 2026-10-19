import 'package:flutter/material.dart';
import 'game_economy_config.dart';
import 'game_model.dart';
import 'game_wallet_manager.dart';

class GamesHubScreen extends StatefulWidget {
  const GamesHubScreen({super.key});

  @override
  State<GamesHubScreen> createState() => _GamesHubScreenState();
}

class _GamesHubScreenState extends State<GamesHubScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F051D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A0B2E),
        title: const Text('🎮 Fizz Games Arena (100% Admin Revenue)', style: TextStyle(color: Colors.white, fontSize: 16)),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                '💎 ${GameWalletManager.currentUserGemsBalance} Gems',
                style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: GamesDataPool.availableGames.length,
        itemBuilder: (context, index) {
          final game = GamesDataPool.availableGames[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              title: Text(game.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('Category: ${game.category} • Difficulty: ${game.difficulty}', style: const TextStyle(color: Colors.white60, fontSize: 11)),
                  const SizedBox(height: 2),
                  Text('Entry Bet: ${game.entryFee} Gems | Win Pool: ${game.prizePool} Gems', style: const TextStyle(color: Colors.cyanAccent, fontSize: 12)),
                ],
              ),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  bool success = GameWalletManager.deductEntryFee(game.entryFee);
                  if (success) {
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Joined ${game.title}! ${game.entryFee} Gems deducted. Good luck!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Insufficient Gems! Please recharge via Block 10 plans.')),
                    );
                  }
                },
                child: const Text('Play Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          );
        },
      ),
    );
  }
}

