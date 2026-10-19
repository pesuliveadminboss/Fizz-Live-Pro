class RechargePlanModel {
  final String id;
  final String title;
  final double priceInINR;
  final int coins;
  final int bonusCoins;
  final String savingsLabel;
  final bool isBestValue;

  const RechargePlanModel({
    required this.id,
    required this.title,
    required this.priceInINR,
    required this.coins,
    required this.bonusCoins,
    required this.savingsLabel,
    this.isBestValue = false,
  });
}

class MonetizationConfig {
  // 1. Base Call Cost Configuration
  static const int coinsPerMinuteLive = 1800;

  // 2. Official Recharge Plans List (₹100 to ₹4,000)
  static const List<RechargePlanModel> officialRechargePlans = [
    RechargePlanModel(
      id: 'plan_100',
      title: 'Starter Pack',
      priceInINR: 100.0,
      coins: 4050,
      bonusCoins: 0,
      savingsLabel: 'Standard Plan',
    ),
    RechargePlanModel(
      id: 'plan_200',
      title: 'Popular Boost Pack',
      priceInINR: 200.0,
      coins: 8500,
      bonusCoins: 400,
      savingsLabel: '5% Extra Value',
    ),
    RechargePlanModel(
      id: 'plan_400',
      title: 'Super Streamer Pack',
      priceInINR: 400.0,
      coins: 17800,
      bonusCoins: 1600,
      savingsLabel: '10% Extra Value',
      isBestValue: true,
    ),
    RechargePlanModel(
      id: 'plan_1000',
      title: 'Mega Pro Pack',
      priceInINR: 1000.0,
      coins: 46000,
      bonusCoins: 5500,
      savingsLabel: '15% Extra Value',
    ),
    RechargePlanModel(
      id: 'plan_2000',
      title: 'VIP Whales Pack',
      priceInINR: 2000.0,
      coins: 95000,
      bonusCoins: 14000,
      savingsLabel: '20% Extra Value',
    ),
    RechargePlanModel(
      id: 'plan_4000',
      title: 'Ultimate Executive Pack',
      priceInINR: 4000.0,
      coins: 200000,
      bonusCoins: 38000,
      savingsLabel: '25% Extra + Free VIP 7 Days',
    ),
  ];
}
