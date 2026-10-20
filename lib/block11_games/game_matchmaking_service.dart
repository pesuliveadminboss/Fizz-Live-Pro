import 'dart:math';

class GameMatchmakingService {
  // Determine if player wins or system wins based on bet size and difficulty
  static Future<bool> playAgainstSystemAI({required int betAmount}) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate match delay

    // Logic: If bet is high (>= 150 gems), Expert AI rigorously wins to protect house margin
    if (betAmount >= 150) {
      // High stakes: System wins 85% of the time
      return Random().nextDouble() > 0.85; 
    } else {
      // Low stakes (50-100 gems): Give user occasional wins to keep engagement high
      return Random().nextDouble() > 0.45;
    }
  }

  static bool calculateGameOutcome(bool playerWon) {
    // Ensuring the house/admin always secures its margin
    return playerWon;
  }
}
