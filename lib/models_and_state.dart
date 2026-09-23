import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreamerItem {
  final String id;
  final String name;
  final String country;
  final String flag;
  final String status;
  final int age;
  final Color color;
  final bool isOffline;
  StreamerItem({
    required this.id,
    required this.name,
    required this.country,
    required this.flag,
    required this.status,
    required this.age,
    required this.color,
    this.isOffline = false,
  });
}

final List<StreamerItem> kMockStreamers = [
  StreamerItem(id: '1', name: 'AvniHotnessDil', country: 'India', flag: '🇮🇳', status: 'online', age: 27, color: const Color(0xFFE94057)),
  StreamerItem(id: '2', name: 'Shiny Sanya', country: 'India', flag: '🇮🇳', status: 'party', age: 25, color: const Color(0xFF8A2387)),
  StreamerItem(id: '3', name: 'Bella_America', country: 'America', flag: '🇺🇸', status: 'live', age: 24, color: const Color(0xFF00C9FF)),
  StreamerItem(id: '4', name: 'Riya_BD', country: 'Bangladesh', flag: '🇧🇩', status: 'online', age: 23, color: const Color(0xFF00B09B)),
  StreamerItem(id: '5', name: 'Zara_Pak', country: 'Pakistan', flag: '🇵🇰', status: 'party', age: 26, color: const Color(0xFFFF512F)),
  StreamerItem(id: '6', name: 'Elena_Rus', country: 'Russia', flag: '🇷🇺', status: 'live', age: 25, color: const Color(0xFF92FE9D)),
  StreamerItem(id: '7', name: 'Asha_Afr', country: 'Africa', flag: '🌍', status: 'online', age: 24, color: const Color(0xFFF27121)),
  StreamerItem(id: '8', name: 'Mada_Girl', country: 'Madagascar', flag: '🇲🇬', status: 'party', age: 22, color: const Color(0xFFE94057)),
  StreamerItem(id: '9', name: 'Offline_Emma', country: 'India', flag: '🇮🇳', status: 'offline', age: 26, color: Colors.grey, isOffline: true),
];

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

class AuthController extends ChangeNotifier {
  bool isLoggedIn = false;
  bool isExistingUser = false;
  bool isStreamer = false;
  String userName = 'Fizz User';
  String userHandle = '@fizzuser';
  String gender = 'Female';
  String country = 'India';
  String dob = '10/10/2000';
  final Set<String> _registeredUsers = {};

  Future<void> checkExistingAndLogin({
    required String identifier,
    required String loginType,
    required BuildContext context,
    required VoidCallback onNewUserNeedsProfile,
    required VoidCallback onExistingSuccess,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$loginType:$identifier';
    if (_registeredUsers.contains(key) || (prefs.getBool(key) ?? false)) {
      isExistingUser = true;
      isLoggedIn = true;
      notifyListeners();
      onExistingSuccess();
    } else {
      isExistingUser = false;
      onNewUserNeedsProfile();
    }
  }

  void completeNewUserProfile({
    required String name,
    required String selectedGender,
    required String selectedDob,
    required String selectedCountry,
    required String loginIdentifier,
    required String loginType,
  }) async {
    gender = selectedGender;
    isStreamer = (gender.toLowerCase() == 'female');
    userName = name;
    userHandle = '@${name.toLowerCase().replaceAll(' ', '_')}';
    dob = selectedDob;
    country = selectedCountry;
    isLoggedIn = true;
    final key = '$loginType:$loginIdentifier';
    _registeredUsers.add(key);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, true);
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    isExistingUser = false;
    notifyListeners();
  }
}
