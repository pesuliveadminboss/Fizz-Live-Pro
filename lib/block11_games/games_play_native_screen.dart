import 'package:flutter/material.dart';
import 'game_wallet_manager.dart';
import 'game_matchmaking_service.dart';
import 'game_sound_helper.dart';

class GamesPlayNativeScreen extends StatefulWidget {
  final String gameTitle;
  final int betAmount;

  const GamesPlayNativeScreen({
    super.key,
    required this.gameTitle,
    required this.betAmount,
  });

  @override
  State<GamesPlayNativeScreen> createState() => _GamesPlayNativeScreenState();
}

class _GamesPlayNativeScreenState extends State<GamesPlayNativeScreen> {
  bool _isCompeting = false;
  String _gameStatusMessage = "Tap 'Start Battle' to play against AI!";
  bool? _didPlayerWin;

  void _startNativeGamePlay() async {
    GameSoundHelper.playSpinSound();
    setState(() {
      _isCompeting = true;
      _gameStatusMessage = "Battling with Expert AI Bot...";
      _didPlayerWin = null;
    });

    // Simulate AI match processing delay
    await Future.delayed(const Duration(seconds: 2));

    // Check matchmaking outcome (Smart AI control & House margin protection)
    bool playerWon = await GameMatchmakingService.playAgainstSystemAI(betAmount: widget.betAmount);
    GameWalletManager.settleGameOutcome(betAmount: widget.betAmount, didPlayerWin: playerWon);

    if (playerWon) {
      GameSoundHelper.playWinSound();
    } else {
      GameSoundHelper.playLossSound();
    }

    setState(() {
      _isCompeting = false;
      _didPlayerWin = playerWon;
      _gameStatusMessage = playerWon
          ? "🎉 You Won! Prize added to your Wallet."
          : "😢 You Lost to AI Bot! House takes the pot.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F051D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A0B2E),
        title: Text(widget.gameTitle, style: const TextStyle(color: Colors.white, fontSize: 16)),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                '💎 Gems: ${GameWalletManager.currentUserGemsBalance}',
                style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1A0B2E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.pinkAccent.withOpacity(0.4)),
              ),
              child: Column(
                children: [
                  Text(
                    widget.gameTitle,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Bet Placed: ${widget.betAmount} Gems',
                    style: const TextStyle(color: Colors.cyanAccent, fontSize: 14),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    _gameStatusMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _didPlayerWin == true
                          ? Colors.greenAccent
                          : (_didPlayerWin == false ? Colors.redAccent : Colors.white70),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _isCompeting
                      ? const CircularProgressIndicator(color: Colors.pinkAccent)
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          onPressed: () {
                            GameSoundHelper.playClickSound();
                            _startNativeGamePlay();
                          },
                          child: const Text(
                            '🎮 Roll & Play Now',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

