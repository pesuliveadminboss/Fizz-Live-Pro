import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  int _gems = 450;
  final List<Map<String, dynamic>> _transactions = [
    {'title': 'Recharge 500 Gems', 'date': 'Today, 2:15 PM', 'amount': '+500 Gems', 'isCredit': true},
    {'title': 'Gift sent to Anitha_Live', 'date': 'Yesterday, 10:40 PM', 'amount': '-50 Gems', 'isCredit': false},
  ];

  int get gems => _gems;
  List<Map<String, dynamic>> get transactions => _transactions;

  bool sendGift(String receiver, String giftName, int cost) {
    if (_gems >= cost) {
      _gems -= cost;
      _transactions.insert(0, {
        'title': 'Sent $giftName to $receiver',
        'date': 'Just now',
        'amount': '-$cost Gems',
        'isCredit': false,
      });
      notifyListeners();
      return true;
    }
    return false;
  }

  void addRecharge(int amount, String priceLabel) {
    _gems += amount;
    _transactions.insert(0, {
      'title': 'Recharge $amount Gems ($priceLabel)',
      'date': 'Just now',
      'amount': '+$amount Gems',
      'isCredit': true,
    });
    notifyListeners();
  }
}
