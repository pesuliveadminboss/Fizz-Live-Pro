import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

