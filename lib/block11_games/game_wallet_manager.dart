class GameWalletManager {
  // Free starting coins/gems for users so entry is totally free
  static int currentUserGemsBalance = 500;
  
  // Track daily won gems to enforce the max limit (e.g., 1800 gems/day max win)
  static int dailyWonGemsCount = 0;
  static const int maxDailyWinLimit = 1800;

  static bool placeBetAndPlay({required int betAmount}) {
    if (currentUserGemsBalance >= betAmount) {
      currentUserGemsBalance -= betAmount; // Deduct user bet amount
      return true;
    }
    return false; // Not enough gems to place this bet
  }

  static void settleGameOutcome({required int betAmount, required bool didPlayerWin}) {
    if (didPlayerWin) {
      // Check if user has already reached the daily free win ceiling
      if (dailyWonGemsCount < maxDailyWinLimit) {
        int reward = betAmount * 2; // Double the reward
        currentUserGemsBalance += reward;
        dailyWonGemsCount += betAmount; // Track won amount
      } else {
        // Daily limit reached, house absorbs or user wins normal capped chips without extra free farming
        currentUserGemsBalance += betAmount; 
      }
    } else {
      // Player lost to System/AI -> House takes everything (Admin Revenue)
      // Note: Bet amount is already deducted when placeBetAndPlay is called, so house secures the pot completely.
    }
  }
}
