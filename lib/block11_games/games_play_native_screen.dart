import 'package:flutter/material.dart';
import 'game_sound_helper.dart';
import '../block10_monetization/admob_monetization_helper.dart'; // AdMob integration

class GamesPlayNativeScreen extends StatefulWidget {
  final String gameTitle;

  const GamesPlayNativeScreen({
    super.key,
    required this.gameTitle,
  });

  @override
  State<GamesPlayNativeScreen> createState() => _GamesPlayNativeScreenState();
}

class _GamesPlayNativeScreenState extends State<GamesPlayNativeScreen> with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  String _statusText = "Tap 'Start Game' to play!";
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

  void _startFreeGame() async {
    GameSoundHelper.playSpinSound();
    setState(() {
      _isPlaying = true;
      _statusText = "Game in progress... Have fun!";
    });

    _animationController.repeat();

    await Future.delayed(const Duration(seconds: 3));
    _animationController.stop();

    GameSoundHelper.playWinSound();

    setState(() {
      _isPlaying = false;
      _statusText = "🎉 Awesome Match! Play again for more fun.";
    });

    // Trigger AdMob ad on game completion (End of game ad)
    AdmobMonetizationHelper.initializeAdSdk();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F051D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A0B2E),
        title: Text(widget.gameTitle, style: const TextStyle(color: Colors.white, fontSize: 16)),
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
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.gameTitle,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Free Entertainment Mode',
                  style: TextStyle(color: Colors.greenAccent, fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 30),
                
                RotationTransition(
                  turns: _animationController,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Colors.pinkAccent, Colors.purpleAccent, Colors.cyan],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Text('🎯', style: TextStyle(fontSize: 36)),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                
                Text(
                  _statusText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 30),
                
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isPlaying ? Colors.grey : Colors.pinkAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    onPressed: _isPlaying
                        ? null
                        : () {
                            GameSoundHelper.playClickSound();
                            _startFreeGame();
                          },
                    child: Text(
                      _isPlaying ? 'Playing...' : '🎮 Start Game Now',
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
