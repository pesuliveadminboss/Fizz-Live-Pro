class GameItemModel {
  final String gameId;
  final String title;
  final String category;
  final int entryFee;
  final int prizePool;
  final String difficulty;
  final String imageUrl;

  const GameItemModel({
    required this.gameId,
    required this.title,
    required this.category,
    required this.entryFee,
    required this.prizePool,
    required this.difficulty,
    required this.imageUrl,
  });
}

class GamesDataPool {
  static const List<GameItemModel> availableGames = [
    GameItemModel(
      gameId: 'game_ludo_1v1',
      title: 'Royal Ludo 1v1',
      category: 'Board',
      entryFee: 50,
      prizePool: 90, // House takes 10 coins commission
      difficulty: 'Hard (Competitive AI)',
      imageUrl: 'assets/games/ludo.png',
    ),
    GameItemModel(
      gameId: 'game_carrom_pro',
      title: 'Pro Carrom Arena',
      category: 'Sports',
      entryFee: 100,
      prizePool: 180,
      difficulty: 'Expert',
      imageUrl: 'assets/games/carrom.png',
    ),
    GameItemModel(
      gameId: 'game_spin_wheel',
      title: 'Lucky Fortune Wheel',
      category: 'Arcade',
      entryFee: 30,
      prizePool: 50,
      difficulty: 'Medium',
      imageUrl: 'assets/games/wheel.png',
    ),
  ];
}
