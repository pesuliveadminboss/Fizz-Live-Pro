class GameWalletManager {
  static int currentUserGemsBalance = 500;[span_0](start_span)[span_0](end_span)
  
  static int dailyWonGemsCount = 0;[span_1](start_span)[span_1](end_span)
  static const int maxDailyWinLimit = 1800;[span_2](start_span)[span_2](end_span)

  static bool placeBetAndPlay({required int betAmount}) {
    if (currentUserGemsBalance >= betAmount) {
      currentUserGemsBalance -= betAmount; // Deduct user bet amount immediately[span_3](start_span)[span_3](end_span)
      return true;[span_4](start_span)[span_4](end_span)
    }
    return false;[span_5](start_span)[span_5](end_span)
  }

  static void settleGameOutcome({required int betAmount, required bool didPlayerWin}) {
    if (didPlayerWin) {
      // Check if user has already reached the daily free win ceiling (1800 gems limit)[span_6](start_span)[span_6](end_span)
      if (dailyWonGemsCount < maxDailyWinLimit) {
        // 👉 Rule: Win fixed +10 gems extra on top of their bet amount (No double multiplication)
        int fixedProfit = 10;
        int totalReturn = betAmount + fixedProfit;
        
        currentUserGemsBalance += totalReturn;
        dailyWonGemsCount += fixedProfit; // Track profit towards daily limit
      } else {
        // Daily limit reached (>= 1800): Return only their original bet amount, no extra profit (House absorbs profit)
        currentUserGemsBalance += betAmount;[span_7](start_span)[span_7](end_span)
      }
    } else {
      // 👉 Player lost: Bet amount is already deducted in placeBetAndPlay. 
      // House/Admin takes the pot completely. No refunds, balance decreases correctly!
    }
  }
}
