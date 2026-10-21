class GameWalletManager {
  static int currentUserGemsBalance = 500;
  
  static int dailyWonGemsCount = 0;
  static const int maxDailyWinLimit = 1800;

  static bool placeBetAndPlay({required int betAmount}) {
    if (currentUserGemsBalance >= betAmount) {
      currentUserGemsBalance -= betAmount; // Deducts bet amount immediately (User loses gems on bet)
      return true;
    }
    return false; // Insufficient balance
  }

  static void settleGameOutcome({required int betAmount, required bool didPlayerWin}) {
    if (didPlayerWin) {
      if (dailyWonGemsCount < maxDailyWinLimit) {
        // Rule: Win fixed +10 gems profit on top of their original bet
        int fixedProfit = 10;
        int totalReturn = betAmount + fixedProfit;
        
        currentUserGemsBalance += totalReturn;
        dailyWonGemsCount += fixedProfit; 
      } else {
        // Limit reached: Return only the original bet, no extra profit
        currentUserGemsBalance += betAmount; 
      }
    } else {
      // Player lost: Bet amount is already deducted in placeBetAndPlay. House takes everything.
    }
  }
}
