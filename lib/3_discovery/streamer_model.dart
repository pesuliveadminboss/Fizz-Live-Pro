class StreamerItemData {
  static int _idCounter = 90001001;
  
  final String id;
  final String name;
  final String idDigit;
  final String type; // 'online', 'live', 'party', 'offline'
  final String country;
  final DateTime dateOfBirth;
  final String induction;
  final String language;
  int closeFriendsCount;
  final int closeFriendsMax = 3;
  bool isFollowed;

  StreamerItemData({
    String? id,
    required this.name,
    String? idDigit,
    required this.type,
    this.country = 'IN 🇮🇳',
    DateTime? dateOfBirth,
    this.induction = 'Welcome to my live/party vibe!',
    this.language = 'Tamil, English',
    this.closeFriendsCount = 1,
    this.isFollowed = false,
  }) : id = id ?? 's_${_idCounter}',
       idDigit = idDigit ?? (_idCounter++).toString(),
       dateOfBirth = dateOfBirth ?? DateTime(1999, 8, 14);

  int get age {
    final now = DateTime.now();
    int a = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month || (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      a--;
    }
    return a;
  }

  StreamerItemData copyWith({
    bool? isFollowed,
    int? closeFriendsCount,
    String? type,
  }) {
    return StreamerItemData(
      id: id,
      name: name,
      idDigit: idDigit,
      type: type ?? this.type,
      country: country,
      dateOfBirth: dateOfBirth,
      induction: induction,
      language: language,
      closeFriendsCount: closeFriendsCount ?? this.closeFriendsCount,
      isFollowed: isFollowed ?? this.isFollowed,
    );
  }
}
