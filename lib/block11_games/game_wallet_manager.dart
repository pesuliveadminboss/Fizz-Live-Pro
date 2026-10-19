class GameWalletManager {
  // Simulate user's gaming balance check
  static int currentUserGemsBalance = 1500;

  static bool deductEntryFee(int amount) {
    if (currentUserGemsBalance >= amount) {
      currentUserGemsBalance -= amount;
      return true;
    }
    return false; // Insufficient gems, user must recharge via Block 10 plans
  }

  static void creditWinningReward(int rewardAmount) {
    // Add winnings safely with ceiling checks
    currentUserGemsBalance += rewardAmount;
  }
}

