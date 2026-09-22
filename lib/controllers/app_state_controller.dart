// Add inside AppStateController or auth state controller:
class UserAuthProfile {
  String name;
  String gender;
  String dob;
  String country; // default India
  bool isRegistered;

  UserAuthProfile({
    this.name = '',
    this.gender = '',
    this.dob = '',
    this.country = 'India 🇮🇳',
    this.isRegistered = false,
  });
}

