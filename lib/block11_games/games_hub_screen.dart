import 'package:flutter/material.dart';
import 'game_economy_config.dart';
import 'game_model.dart';
import 'game_wallet_manager.dart';
import 'game_matchmaking_service.dart';
import 'games_play_webview_screen.dart'; // 👉 Corrected import name here

class GamesHubScreen extends StatefulWidget {
  const GamesHubScreen({super.key});

  @override
  State<GamesHubScreen> createState() => _GamesHubScreenState();
}

class _GamesHubScreenState extends State<GamesHubScreen> {
  int selectedBetAmount = 50; // Default starting bet

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F051D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A0B2E),
        elevation: 0,
        title: const Text(
          '🎮 Fizz Games Arena (Free Entry)',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
                    '${GameWalletManager.currentUserGemsBalance} Gems',
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
                    'Play Mini Games Free & Win! 🔥',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Select your bet amount below, play against AI, and win rewards securely.',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Bet Selector Chips
            const Text(
              'Select Bet Amount (Gems):',
              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [50, 100, 150, 200, 250, 300].map((amount) {
                  bool isSelected = (selectedBetAmount == amount);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text('$amount Gems'),
                      selected: isSelected,
                      selectedColor: Colors.pinkAccent,
                      backgroundColor: const Color(0xFF1A0B2E),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          selectedBetAmount = amount;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Featured HTML5 Mini Games',
              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            // Grid View for Games
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.72,
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
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.purple.withOpacity(0.3),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            child: Center(
                              child: Text(
                                game.category == 'Board' ? '🎲' : (game.category == 'Sports' ? '🎱' : '🎡'),
                                style: const TextStyle(fontSize: 36),
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
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Bet: $selectedBetAmount Gems',
                                style: const TextStyle(color: Colors.cyanAccent, fontSize: 11),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                height: 30,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pinkAccent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: () async {
                                    bool canPlay = GameWalletManager.placeBetAndPlay(betAmount: selectedBetAmount);
                                    if (!canPlay) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Insufficient Gems balance!')),
                                      );
                                      return;
                                    }

                                    // Trigger AI Matchmaking outcome check
                                    bool playerWon = await GameMatchmakingService.playAgainstSystemAI(betAmount: selectedBetAmount);
                                    GameWalletManager.settleGameOutcome(betAmount: selectedBetAmount, didPlayerWin: playerWon);
                                    setState(() {});

                                    // Open WebView Game Screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GamesPlayWebviewScreen(
                                          gameTitle: game.title,
                                          gameUrl: 'https://html5games.com/',
                                          betAmount: selectedBetAmount,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('Play Now', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
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
