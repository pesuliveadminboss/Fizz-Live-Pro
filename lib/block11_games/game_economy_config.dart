class GameEconomyConfig {
  // 100% Admin Revenue Share from Games (No streamer cuts here)
  static const double adminGameRevenueShare = 1.00; 

  // Betting limits for 1v1 games (e.g., Ludo, Carrom)
  static const int minEntryBetCoins = 50;
  static const int maxEntryBetCoins = 200;

  // Controlled reward ceiling to prevent free gem farming
  static const int maxDailyWinningLimit = 3600; // Equal to max 2 video calls worth
  static const String currencyLabel = 'Gems / Coins';
}

