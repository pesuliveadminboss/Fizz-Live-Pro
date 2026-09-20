import 'package:flutter/material.dart';

class AppTheme {
  static const bgDark = Color(0xFF0A0713);
  static const cardDark = Color(0xFF1B152E);
  static const primaryPink = Colors.pinkAccent;
  static const accentAmber = Colors.amber;
}

class WalletController extends ValueNotifier<int> {
  WalletController({int initial = 4050}) : super(initial);

  bool deduct(int amount) {
    if (value >= amount) {
      value -= amount;
      return true;
    }
    return false;
  }

  void add(int amount) => value += amount;
}

final globalWallet = WalletController();

