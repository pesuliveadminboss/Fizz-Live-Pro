import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  int _gems = 450;
  int _currentStreakDay = 1;
  bool _claimedToday = false;
  
  String _userName = 'Fizz User';
  String _userHandle = '@fizzuser_101';
  final List<Map<String, dynamic>> _transactions = [
    {'title': 'Recharge 500 Gems', 'date': 'Today, 2:15 PM', 'amount': '+500 Gems', 'isCredit': true},
    {'title': 'Gift sent to Anitha_Live', 'date': 'Yesterday, 10:40 PM', 'amount': '-50 Gems', 'isCredit': false},
  ];
  
  int get gems => _gems;
  int get currentStreakDay => _currentStreakDay;
  bool get claimedToday => _claimedToday;
  String get userName => _userName;
  String get userHandle => _userHandle;
  List<Map<String, dynamic>> get transactions => _transactions;

  void claimDailyReward() {
    if (_claimedToday) return;
    int rewardGems = _currentStreakDay == 7 ? 200 : (_currentStreakDay == 2 ? 0 : [0, 40, 0, 50, 90, 120, 180, 200][_currentStreakDay]);
    if (_currentStreakDay == 2) {
      _transactions.insert(0, {'title': 'Daily Reward Day 2 (Surprise Card 🃏)', 'date': 'Today', 'amount': '+1 Card', 'isCredit': true});
    } else {
      _gems += rewardGems;
      _transactions.insert(0, {'title': 'Daily Reward Day $_currentStreakDay', 'date': 'Today', 'amount': '+$rewardGems Gems', 'isCredit': true});
    }
    _claimedToday = true;
    _currentStreakDay = _currentStreakDay < 7 ? _currentStreakDay + 1 : 1;
    notifyListeners();
  }

  void updateProfile(String name, String handle) {
    _userName = name;
    _userHandle = handle.startsWith('@') ? handle : '@$handle';
    notifyListeners();
  }

  bool sendGift(String receiver, String giftName, int cost) {
    if (_gems >= cost) {
      _gems -= cost;
      _transactions.insert(0, {'title': 'Sent $giftName to $receiver', 'date': 'Just now', 'amount': '-$cost Gems', 'isCredit': false});
      notifyListeners();
      return true;
    }
    return false;
  }
}

