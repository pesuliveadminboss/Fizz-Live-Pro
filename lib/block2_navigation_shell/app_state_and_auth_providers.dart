import 'package:flutter/material.dart';

class AppStateProvider extends ChangeNotifier {
  int _gems = 1250;
  String _userName = 'Macha User';
  String _userHandle = '@macha_live';
  bool _isStreamer = false;

  int get gems => _gems;
  String get userName => _userName;
  String get userHandle => _userHandle;
  bool get isStreamer => _isStreamer;

  void updateRole(bool isStreamer) {
    _isStreamer = isStreamer;
    notifyListeners();
  }

  void addGems(int amount) {
    _gems += amount;
    notifyListeners();
  }

  void sendGift(String receiver, String giftName, int cost) {
    if (_gems >= cost) {
      _gems -= cost;
      notifyListeners();
    }
  }
}

class AuthControllerProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isStreamerMode = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get isStreamerMode => _isStreamerMode;

  void loginSuccess({required bool isStreamer}) {
    _isAuthenticated = true;
    _isStreamerMode = isStreamer;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}

