class RevenueCommissionCalculator {
  static const double ownerCommissionRate = 0.50; // 50% App Owner Commission
  static const double streamerPayoutRate = 0.50;  // 50% Streamer Earnings

  // Calculate earnings split when a gift is sent
  static Map<String, double> calculateGiftEarnings(double giftValueInINR) {
    double ownerShare = giftValueInINR * ownerCommissionRate;
    double streamerShare = giftValueInINR * streamerPayoutRate;

    return {
      'owner_revenue': ownerShare,
      'streamer_payout': streamerShare,
    };
  }

  // Calculate talk-time duration in minutes based on total coins
  static double calculateTalkTimeMinutes(int totalCoins) {
    return totalCoins / 1800.0; // 1,800 coins per minute rate
  }
}
