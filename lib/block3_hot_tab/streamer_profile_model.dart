class StreamerProfileModel {
  final String id;
  final String name;
  final String country;
  final String flag;
  final int age;
  final String status; // 'online', 'live', 'party', 'offline'
  final String intro;
  final String language;
  final bool isVerified;
  
  bool isBlocked;
  bool isLiked;
  int reportCount;
  bool isBanned;

  StreamerProfileModel({
    required this.id,
    required this.name,
    required this.country,
    required this.flag,
    required this.age,
    required this.status,
    required this.intro,
    required this.language,
    this.isVerified = true,
    this.isBlocked = false,
    this.isLiked = false,
    this.reportCount = 0,
    this.isBanned = false,
  });
}
