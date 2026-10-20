class GameItemModel {
  final String gameId;
  final String title;
  final String category;
  final int entryFee;
  final int prizePool;
  final String difficulty;
  final String imageUrl;
  final String gameUrl; // 👉 Individual HTML5 game web URL

  const GameItemModel({
    required this.gameId,
    required this.title,
    required this.category,
    required this.entryFee,
    required this.prizePool,
    required this.difficulty,
    required this.imageUrl,
    required this.gameUrl,
  });
}

class GamesDataPool {
  static const List<GameItemModel> availableGames = [
    GameItemModel(
      gameId: 'game_ludo_1v1',
      title: 'Royal Ludo 1v1',
      category: 'Board',
      entryFee: 50,
      prizePool: 100,
      difficulty: 'Hard (Expert AI)',
      imageUrl: 'assets/games/ludo.png',
      gameUrl: 'https://html5games.com/Game/Ludo-Hero', // Sample Ludo HTML5 game link
    ),
    GameItemModel(
      gameId: 'game_carrom_pro',
      title: 'Pro Carrom Arena',
      category: 'Sports',
      entryFee: 100,
      prizePool: 200,
      difficulty: 'Expert',
      imageUrl: 'assets/games/carrom.png',
      gameUrl: 'https://html5games.com/Game/Billiards-Master', // Sample Carrom/Cue HTML5 game link
    ),
    GameItemModel(
      gameId: 'game_spin_wheel',
      title: 'Lucky Fortune Wheel',
      category: 'Arcade',
      entryFee: 30,
      prizePool: 60,
      difficulty: 'Medium',
      imageUrl: 'assets/games/wheel.png',
      gameUrl: 'https://html5games.com/Game/Wheel-of-Fortune', // Sample Wheel HTML5 game link
    ),
  ];
}
