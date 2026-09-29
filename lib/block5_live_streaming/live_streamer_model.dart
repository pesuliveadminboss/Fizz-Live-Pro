class LiveStreamer {
  final String id;
  final String name;
  final String viewers;
  final String category;
  final String profileImageUrl;
  final String bio;

  const LiveStreamer({
    required this.id,
    required this.name,
    required this.viewers,
    required this.category,
    required this.profileImageUrl,
    required this.bio,
  });

  static const List<LiveStreamer> dummyStreamers = [
    LiveStreamer(id: '1', name: 'sara', viewers: '1.2k', category: 'Hot', profileImageUrl: '', bio: 'Call me baby. I am waiting for you.'),
    LiveStreamer(id: '2', name: 'niki', viewers: '850', category: 'Pretty', profileImageUrl: '', bio: 'Welcome to my live stream! Let us talk.'),
    LiveStreamer(id: '3', name: 'tasty', viewers: '3.4k', category: 'New', profileImageUrl: '', bio: 'Enjoy the music and chat with me.'),
    LiveStreamer(id: '4', name: 'duniya', viewers: '2.1k', category: 'Sexy', profileImageUrl: '', bio: 'Thanks for following and sending gifts!'),
    LiveStreamer(id: '5', name: 'Pooja Sharma', viewers: '4.5k', category: 'Hot', profileImageUrl: '', bio: 'Spread love and positive vibes only.'),
    LiveStreamer(id: '6', name: 'Kiran Queen', viewers: '920', category: 'Pretty', profileImageUrl: '', bio: 'Always active and ready for video calls!'),
  ];
}
