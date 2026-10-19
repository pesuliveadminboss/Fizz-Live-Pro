import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class UserIdentityGenerator {
  static const String _keyGeneratedId = 'fizz_pro_unique_user_id';
  static const String _keyIsRegistered = 'fizz_pro_device_registered';

  /// 1. Generate a unique 8-digit identification number for the user or device
  static Future<String> getOrCreateUniqueId({required String userEmailOrDeviceKey}) async {
    final prefs = await SharedPreferences.getInstance();
    
    bool isAlreadyRegistered = prefs.getBool(_keyIsRegistered) ?? false;
    String? existingId = prefs.getString(_keyGeneratedId);

    // Check if an ID has already been generated for this device/user
    if (isAlreadyRegistered && existingId != null && existingId.isNotEmpty) {
      return existingId;
    }

    // Generate a new random 8-digit unique ID (e.g., 74829103)
    final random = Random();
    int min = 10000000;
    int max = 99999999;
    String newUniqueId = (min + random.nextInt(max - min)).toString();

    // Secure and lock registration data locally
    await prefs.setString(_keyGeneratedId, newUniqueId);
    await prefs.setBool(_keyIsRegistered, true);
    await prefs.setString('registered_identifier', userEmailOrDeviceKey);

    return newUniqueId;
  }

  /// 2. Check if the device or user identifier already exists in local storage
  static Future<bool> checkIfDeviceOrUserAlreadyExists(String currentIdentifier) async {
    final prefs = await SharedPreferences.getInstance();
    bool isRegistered = prefs.getBool(_keyIsRegistered) ?? false;
    String? savedIdentifier = prefs.getString('registered_identifier');

    if (isRegistered && savedIdentifier != null) {
      return true;
    }
    return false;
  }

  /// 3. Reset identity data completely for testing purposes if needed
  static Future<void> resetIdentityForTesting() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyGeneratedId);
    await prefs.remove(_keyIsRegistered);
    await prefs.remove('registered_identifier');
  }
}
