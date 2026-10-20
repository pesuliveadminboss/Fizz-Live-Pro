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

class _GamesPlayNativeScreenState extends State<GamesPlayNativeScreen> with SingleTickerProviderStateMixin {
  bool _isCompeting = false;
  String _gameStatusMessage = "Tap 'Roll & Play Now' to battle AI!";
  bool? _didPlayerWin;
  
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startNativeGamePlay() async {
    GameSoundHelper.playSpinSound();
    setState(() {
      _isCompeting = true;
      _gameStatusMessage = "Battling with Expert AI Bot...";
      _didPlayerWin = null;
    });

    _animationController.repeat();

    // Simulate match processing delay
    await Future.delayed(const Duration(seconds: 2));
    _animationController.stop();

    // Check matchmaking outcome (Smart AI control & House margin protection)
    bool playerWon = await GameMatchmakingService.playAgainstSystemAI(betAmount: widget.betAmount);
    
    // 👉 Corrected Wallet Settlement Logic for Win & Loss
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
          ? "🎉 You Won! Double prize added (+${widget.betAmount * 2} Gems)."
          : "😢 You Lost! Bet amount taken by Admin/Bot (-${widget.betAmount} Gems).";
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
                style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1A0B2E),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.pinkAccent.withOpacity(0.5), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.pinkAccent.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.gameTitle,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.cyanAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Active Bet: ${widget.betAmount} Gems',
                    style: const TextStyle(color: Colors.cyanAccent, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 25),
                
                // Interactive Rotating Wheel / Loader Animation
                RotationTransition(
                  turns: _animationController,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Colors.pinkAccent, Colors.purpleAccent, Colors.amber],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🎯', style: TextStyle(fontSize: 36)),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                
                Text(
                  _gameStatusMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _didPlayerWin == true
                        ? Colors.greenAccent
                        : (_didPlayerWin == false ? Colors.redAccent : Colors.white70),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 30),
                
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isCompeting ? Colors.grey : Colors.pinkAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    onPressed: _isCompeting
                        ? null
                        : () {
                            GameSoundHelper.playClickSound();
                            _startNativeGamePlay();
                          },
                    child: Text(
                      _isCompeting ? 'Battling AI...' : '🎮 Roll & Play Now',
                      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

