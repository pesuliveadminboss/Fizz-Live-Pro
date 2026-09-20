class StreamerItemData {
  static int _idCounter = 90001001;
  
  final String id8Digit;
  final String name;
  final String country;
  final String imageUrl;
  final String status; // 'online', 'live', 'party' (offline excluded from hot feed)
  final String age;
  final String introduction;
  final String language;
  bool isFollowed;

  StreamerItemData({
    String? customId,
    required this.name,
    required this.country,
    required this.imageUrl,
    required this.status,
    required this.age,
    required this.introduction,
    required this.language,
    this.isFollowed = false,
  }) : id8Digit = customId ?? (_idCounter++).toString();
}

List<StreamerItemData> globalHotStreamers = [
  StreamerItemData(
    customId: '90001001',
    name: 'AvniHotnessDil',
    country: 'India',
    imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
    status: 'live',
    age: '27',
    introduction: 'Hi, I am Avni. Live stream vibes waiting for you!',
    language: 'Hindi, English',
  ),
  StreamerItemData(
    customId: '90001002',
    name: 'ShinySanya',
    country: 'India',
    imageUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400',
    status: 'online',
    age: '28',
    introduction: 'Online and ready for chat & video calls.',
    language: 'Tamil, English',
    isFollowed: true,
  ),
  StreamerItemData(
    customId: '90001003',
    name: 'Tala',
    country: 'Egypt',
    imageUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400',
    status: 'live',
    age: '26',
    introduction: 'Hi, I\'m Tala. Call me if you\'re free. I\'m waiting for you with bated breath',
    language: 'Arabic, English',
  ),
  StreamerItemData(
    customId: '90001004',
    name: 'PartyQueen',
    country: 'Russia',
    imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
    status: 'party',
    age: '24',
    introduction: 'Join party room for music and fun.',
    language: 'Russian, English',
  ),
];
