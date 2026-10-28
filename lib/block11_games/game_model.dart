class GameItemModel {
  final String gameId;
  final String title;
  final String category;
  final int entryFee;
  final int prizePool;
  final String difficulty;
  final String imageUrl;
  final String gameUrl; // 👉 Real HTML5 Game Web URL

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
      gameId: 'game_archery',
      title: 'Archery World Tour',
      category: 'Sports',
      entryFee: 0,
      prizePool: 0,
      difficulty: 'Medium',
      imageUrl: 'assets/games/archery.png',
      gameUrl: 'https://html5games.com/Game/Archery-World-Tour/ebcb987a-3fd0-4b4a-bae6-f456fff9cac3',
    ),
    GameItemModel(
      gameId: 'game_tower_crash',
      title: 'Tower Crash 3D',
      category: 'Arcade',
      entryFee: 0,
      prizePool: 0,
      difficulty: 'Hard',
      imageUrl: 'assets/games/tower.png',
      gameUrl: 'https://html5games.com/Game/Tower-Crash-3D/68a7c06e-ec27-4fa4-99a5-a5e9702ac4ef',
    ),
    GameItemModel(
      gameId: 'game_diamond_rush',
      title: 'Diamond Rush',
      category: 'Puzzle',
      entryFee: 0,
      prizePool: 0,
      difficulty: 'Easy',
      imageUrl: 'assets/games/diamond.png',
      gameUrl: 'https://html5games.com/Game/Diamond-Rush/395b0746-6d0e-4ec8-b11c-18cab8009214',
    ),
    GameItemModel(
      gameId: 'game_table_tennis',
      title: 'Table Tennis World Tour',
      category: 'Sports',
      entryFee: 0,
      prizePool: 0,
      difficulty: 'Expert',
      imageUrl: 'assets/games/tennis.png',
      gameUrl: 'https://html5games.com/Game/Table-Tennis-World-Tour/8c8e5fc6-7e38-47ab-96eb-150276e79ef8',
    ),
    GameItemModel(
      gameId: 'game_free_kick',
      title: '3D Free Kick',
      category: 'Sports',
      entryFee: 0,
      prizePool: 0,
      difficulty: 'Medium',
      imageUrl: 'assets/games/kick.png',
      gameUrl: 'https://html5games.com/Game/3D-Free-Kick/2ee096ab-4cd7-4f9a-baa9-f58a54413c47',
    ),
  ];
}
