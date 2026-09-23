import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  bool isLoggedIn = false;
  bool isExistingUser = false;
  bool isStreamer = false; // Women = streamer (Go-Live shown), Men = user (No Go-Live)
  String userName = '';
  String userHandle = '';
  String gender = 'Female';
  String country = 'India';
  String dob = '';
  String? phoneOrEmail;

  final Set<String> _registeredUsers = {}; // Mock DB check

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
      // Existing user / streamer path
      isExistingUser = true;
      isLoggedIn = true;
      isStreamer = (gender == 'Female');
      notifyListeners();
      onExistingSuccess();
    } else {
      // New user registration flow
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
    await prefs.setString('user_gender', gender);
    await prefs.setString('user_name', userName);

    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    isExistingUser = false;
    notifyListeners();
  }
}

