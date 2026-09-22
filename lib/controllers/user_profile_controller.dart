import 'package:get/get.dart';
import 'dart:math';

class UserProfileController extends GetxController {
  var profileName = ''.obs;
  var gender = 'Female'.obs; // 'Male' or 'Female'
  var dob = '10/10/2000'.obs;
  var country = 'India'.obs;
  var profilePhotoUrl = ''.obs;
  var authType = 'Guest'.obs;

  final List<String> allCountries = [
    'India', 'United States', 'United Kingdom', 'Canada', 'Australia',
    'Germany', 'France', 'Japan', 'Singapore', 'Malaysia', 'United Arab Emirates'
  ];

  void resetForFastLogin() {
    authType.value = 'Fast Login';
    profileName.value = 'Macha_${Random().nextInt(9000) + 1000}';
    gender.value = 'Female';
    dob.value = '10/10/2000';
    country.value = 'India';
    profilePhotoUrl.value = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300';
  }

  void fillFromGoogleAccount(String email) {
    authType.value = 'Google';
    profileName.value = email.split('@').first;
    gender.value = 'Female';
    dob.value = '12/05/1999';
    country.value = 'India'; // default / detected fallback
    profilePhotoUrl.value = 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=300';
  }

  void setupGuestProfile(String selectedGender, String selectedDob, String selectedCountry) {
    authType.value = 'Guest';
    gender.value = selectedGender;
    dob.value = selectedDob;
    country.value = selectedCountry.isEmpty ? 'India' : selectedCountry;
    profileName.value = 'guest_${Random().nextInt(9000) + 1000}';
    updateGenderAvatar(selectedGender);
  }

  void updateGenderAvatar(String g) {
    gender.value = g;
    if (g.toLowerCase() == 'male') {
      profilePhotoUrl.value = 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=300';
    } else {
      profilePhotoUrl.value = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300';
    }
  }

  void updateCustomProfile({required String name, required String g, required String d, required String c}) {
    profileName.value = name;
    gender.value = g;
    dob.value = d;
    country.value = c;
    updateGenderAvatar(g);
  }
}
