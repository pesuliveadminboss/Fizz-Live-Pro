import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  static const String _keyLoggedIn = 'is_logged_in';
  static const String _keyProfileDone = 'is_profile_done';
  static const String _keyUserName = 'user_name';

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  static Future<bool> isProfileDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyProfileDone) ?? false;
  }

  static Future<void> setLoggedIn(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, val);
  }

  static Future<void> setProfileDone(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyProfileDone, val);
  }

  static Future<void> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
