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
        elevation: 0,
        title: const Text(
          '🎮 Fizz Games Arena',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amberAccent.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  const Text('💎 ', style: TextStyle(fontSize: 14)),
                  Text(
                    '${GameWalletManager.currentUserGemsBalance}',
                    style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7928CA), Color(0xFFFF0080)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Play 1v1 & Win Big! 🔥',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Battle with players or expert AI, use gems, and win real rewards securely.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Featured Games',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            
            // Grid View for Games (Instead of vertical lines)
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.75,
                ),
                itemCount: GamesDataPool.availableGames.length,
                itemBuilder: (context, index) {
                  final game = GamesDataPool.availableGames[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A0B2E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Game Header / Image Placeholder Box
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.purple.withOpacity(0.3),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            child: Center(
                              child: Text(
                                game.category == 'Board' ? '🎲' : (game.category == 'Sports' ? '🎱' : '🎡'),
                                style: const TextStyle(fontSize: 40),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                game.title,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Entry: ${game.entryFee} Gems',
                                style: const TextStyle(color: Colors.cyanAccent, fontSize: 11),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                height: 32,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pinkAccent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: () {
                                    bool success = GameWalletManager.deductEntryFee(game.entryFee);
                                    if (success) {
                                      setState(() {});
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Joined ${game.title}! Match starting...')),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Insufficient Gems! Please recharge.')),
                                      );
                                    }
                                  },
                                  child: const Text('Play Now', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

