class GameWalletManager {
  // Free starting coins/gems for users so entry is totally free[span_2](start_span)[span_2](end_span)
  static int currentUserGemsBalance = 500;[span_3](start_span)[span_3](end_span)
  
  // Track daily won gems to enforce the max limit (e.g., 1800 gems/day max win)[span_4](start_span)[span_4](end_span)
  static int dailyWonGemsCount = 0;[span_5](start_span)[span_5](end_span)
  static const int maxDailyWinLimit = 1800;[span_6](start_span)[span_6](end_span)

  static bool placeBetAndPlay({required int betAmount}) {
    if (currentUserGemsBalance >= betAmount) {
      currentUserGemsBalance -= betAmount; // Deduct user bet amount[span_7](start_span)[span_7](end_span)
      return true;[span_8](start_span)[span_8](end_span)
    }
    return false; // Not enough gems to place this bet[span_9](start_span)[span_9](end_span)
  }

  static void settleGameOutcome({required int betAmount, required bool didPlayerWin}) {
    if (didPlayerWin) {
      // Check if user has already reached the daily free win ceiling[span_10](start_span)[span_10](end_span)
      if (dailyWonGemsCount < maxDailyWinLimit) {
        int reward = betAmount * 2; // Double the reward[span_11](start_span)[span_11](end_span)
        currentUserGemsBalance += reward;[span_12](start_span)[span_12](end_span)
        dailyWonGemsCount += betAmount; // Track won amount[span_13](start_span)[span_13](end_span)
      } else {
        // Daily limit reached, house absorbs or user wins normal capped chips without extra free farming[span_14](start_span)[span_14](end_span)
        currentUserGemsBalance += betAmount;[span_15](start_span)[span_15](end_span)
      }
    } else {
      // Player lost to System/AI -> House takes everything (Admin Revenue)[span_16](start_span)[span_16](end_span)
      // Note: Bet amount is already deducted when placeBetAndPlay is called, so house secures the pot completely.
    }
  }
}
