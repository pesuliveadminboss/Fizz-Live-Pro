class StreamerModel {
  final String id;
  final String name;
  final String country;
  final String flag;
  final int age;
  final String status; // 'online', 'live', 'party', 'offline'
  final String intro;
  final String language;

  StreamerModel({
    required this.id,
    required this.name,
    required this.country,
    required this.flag,
    required this.age,
    required this.status,
    required this.intro,
    required this.language,
  });
}

final List<StreamerModel> kAllStreamers = [
  StreamerModel(id: '1', name: 'Avni Hotness', country: 'India', flag: '🇮🇳', age: 24, status: 'live', intro: 'Welcome to my live room!', language: 'Hindi, English'),
  StreamerModel(id: '2', name: 'Shiny Sanya', country: 'America', flag: '🇺🇸', age: 22, status: 'online', intro: 'Always smiling ✨', language: 'English'),
  StreamerModel(id: '3', name: 'Jocelyn', country: 'Bangladesh', flag: '🇧🇩', age: 26, status: 'party', intro: 'Party all night!', language: 'Bengali, English'),
  StreamerModel(id: '4', name: 'Zoya Khan', country: 'Pakistan', flag: '🇵🇰', age: 23, status: 'live', intro: 'Let us chat!', language: 'Urdu, English'),
  StreamerModel(id: '5', name: 'Natasha', country: 'Russia', flag: '🇷🇺', age: 25, status: 'online', intro: 'Hello everyone', language: 'Russian, English'),
  StreamerModel(id: '6', name: 'Amina', country: 'Africa', flag: '🌍', age: 24, status: 'party', intro: 'Vibes only', language: 'English'),
  StreamerModel(id: '7', name: 'Madeline', country: 'Madagascar', flag: '🇲🇬', age: 22, status: 'live', intro: 'Island girl', language: 'French, English'),
  StreamerModel(id: '8', name: 'Offline User', country: 'India', flag: '🇮🇳', age: 26, status: 'offline', intro: 'Not active', language: 'Tamil'),
];
