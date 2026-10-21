import 'dart:math';
import 'game_wallet_manager.dart';

class GameMatchmakingService {
  static Future<bool> playAgainstSystemAI({required int betAmount}) async {
    await Future.delayed(const Duration(seconds: 1)); // Match simulation delay

    // 👉 Check if user has exceeded or reached the daily winning ceiling (1800 Gems limit)
    if (GameWalletManager.dailyWonGemsCount >= GameWalletManager.maxDailyWinLimit) {
      // Post-limit enforcement: Expert AI takes full control. User loses 95% of the time (1 win, 10 losses)
      return Random().nextDouble() > 0.95; 
    }

    // Normal play: High restriction to protect house margin and prevent fast farming
    if (betAmount >= 100) {
      // Higher bets: System wins 80% of the time
      return Random().nextDouble() > 0.80; 
    } else {
      // Lower bets: Controlled wins so they don't spike up too fast
      return Random().nextDouble() > 0.55;
    }
  }

  static bool calculateGameOutcome(bool playerWon) {
    return playerWon;
  }
}
