class GameItemModel {
  final String gameId;
  final String title;
  final String category;
  final int entryFee;
  final int prizePool;
  final String difficulty;
  final String imageUrl;
  final String gameUrl; // 👉 WebView HTML5 Game URL

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
      gameId: 'game_bubble_tower',
      title: 'Bubble Tower 3D',
      category: 'Arcade',
      entryFee: 0,
      prizePool: 0,
      difficulty: 'Easy',
      imageUrl: 'assets/games/bubble.png',
      gameUrl: 'https://html5games.com/Game/Bubble-Tower-3D/1385d98a-b5f2-4339-bce7-b99a8dd2e8b0', // 👉 Real HTML5 game link
    ),
    GameItemModel(
      gameId: 'game_ludo_1v1',
      title: 'Royal Ludo 1v1',
      category: 'Board',
      entryFee: 0,
      prizePool: 0,
      difficulty: 'Medium',
      imageUrl: 'assets/games/ludo.png',
      gameUrl: 'https://html5games.com/Game/Bubble-Tower-3D/1385d98a-b5f2-4339-bce7-b99a8dd2e8b0',
    ),
    GameItemModel(
      gameId: 'game_carrom_pro',
      title: 'Pro Carrom Arena',
      category: 'Sports',
      entryFee: 0,
      prizePool: 0,
      difficulty: 'Expert',
      imageUrl: 'assets/games/carrom.png',
      gameUrl: 'https://html5games.com/Game/Bubble-Tower-3D/1385d98a-b5f2-4339-bce7-b99a8dd2e8b0',
    ),
  ];
}
