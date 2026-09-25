class LiveStreamer {
  final String id;
  final String name;
  final String category; // 'Pretty', 'New', 'Sexy'
  final int viewers;
  final String avatarUrl;

  LiveStreamer({
    required this.id,
    required this.name,
    required this.category,
    required this.viewers,
    required this.avatarUrl,
  });
}

final List<LiveStreamer> kLiveStreamers = [
  LiveStreamer(id: 'l1', name: 'AvniHotnessDil', category: 'Sexy', viewers: 1250, avatarUrl: 'assets/avatar1.png'),
  LiveStreamer(id: 'l2', name: 'Shiny Sanya', category: 'Pretty', viewers: 890, avatarUrl: 'assets/avatar2.png'),
  LiveStreamer(id: 'l3', name: 'Exotic Moka', category: 'New', viewers: 430, avatarUrl: 'assets/avatar3.png'),
  LiveStreamer(id: 'l4', name: 'Jocelyn Kidmat', category: 'Sexy', viewers: 2300, avatarUrl: 'assets/avatar4.png'),
  LiveStreamer(id: 'l5', name: 'Sara', category: 'Pretty', viewers: 670, avatarUrl: 'assets/avatar5.png'),
];
