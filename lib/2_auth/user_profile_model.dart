class UserProfileData {
  static int _userCounter = 1;
  
  String username;
  String dob;
  String gender;
  String language;
  String bio;
  String avatarUrl;
  bool isProfileCompleted;

  UserProfileData({
    this.username = '',
    this.dob = '',
    this.gender = 'Female',
    this.language = 'Tamil',
    this.bio = '',
    this.avatarUrl = '',
    this.isProfileCompleted = false,
  });

  static String generateNextDefaultUsername() {
    final name = 'user_${_userCounter.toString().padLeft(4, '0')}';
    _userCounter++;
    return name;
  }

  static String getDefaultAvatarForGender(String gender) {
    if (gender == 'Male') {
      return 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200';
    } else {
      return 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200';
    }
  }
}

final userProfile = UserProfileData();
