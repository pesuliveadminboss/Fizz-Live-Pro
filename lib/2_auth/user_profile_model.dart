class UserProfileData {
  String username;
  String dob;
  String gender;
  String language;
  String bio;
  bool isProfileCompleted;

  UserProfileData({
    this.username = '',
    this.dob = '',
    this.gender = 'Female',
    this.language = 'Tamil',
    this.bio = '',
    this.isProfileCompleted = false,
  });
}

final userProfile = UserProfileData();

