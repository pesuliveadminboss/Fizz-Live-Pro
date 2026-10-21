import 'dart:math';
import 'game_wallet_manager.dart';

class GameMatchmakingService {
  static Future<bool> playAgainstSystemAI({required int betAmount}) async {
    await Future.delayed(const Duration(seconds: 1)); // Delay simulation

    // If daily win limit (1800 gems) is reached, AI takes full control and user loses 95% of matches
    if (GameWalletManager.dailyWonGemsCount >= GameWalletManager.maxDailyWinLimit) {
      return Random().nextDouble() > 0.95; 
    }

    // Normal play: High AI win rate to protect house margin and prevent fast farming
    if (betAmount >= 100) {
      return Random().nextDouble() > 0.80; // System wins 80% on high bets
    } else {
      return Random().nextDouble() > 0.55; // Controlled wins on low bets
    }
  }

  static bool calculateGameOutcome(bool playerWon) {
    return playerWon;
  }
}
