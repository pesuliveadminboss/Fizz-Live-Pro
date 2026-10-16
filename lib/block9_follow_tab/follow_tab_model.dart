class FollowTabModel {
  final String id;
  final String name;
  final String imageUrl;
  final String status; // 'Active', 'Live', 'Party', 'Busy', 'Offline'
  final String category; // 'girl' or 'room'
  final String details;

  FollowTabModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.status,
    required this.category,
    required this.details,
  });

  // Dummy mock data for initial testing and display
  static List<FollowTabModel> dummyFollowList = [
    FollowTabModel(
      id: '1',
      name: 'MariaSopya',
      imageUrl: '',
      status: 'Active',
      category: 'girl',
      details: 'Active Streamer',
    ),
    FollowTabModel(
      id: '2',
      name: 'SEXYDOLL💖-',
      imageUrl: '',
      status: 'Active',
      category: 'girl',
      details: 'VIP Host',
    ),
    FollowTabModel(
      id: '3',
      name: 'Brenda',
      imageUrl: '',
      status: 'Active',
      category: 'girl',
      details: 'Top Creator',
    ),
    FollowTabModel(
      id: '4',
      name: 'Rani Sharma',
      imageUrl: '',
      status: 'Live',
      category: 'girl',
      details: 'Live Streaming in Tamil Nadu',
    ),
    FollowTabModel(
      id: '5',
      name: 'Serena❤️',
      imageUrl: '',
      status: 'Party',
      category: 'room',
      details: 'Hosting Candy Fiesta Party Room',
    ),
    FollowTabModel(
      id: '6',
      name: 'Sonia',
      imageUrl: '',
      status: 'Live',
      category: 'girl',
      details: 'PK Battle Live',
    ),
    FollowTabModel(
      id: '7',
      name: 'SeductiveSavanna💖',
      imageUrl: '',
      status: 'Live',
      category: 'girl',
      details: 'Late Night Live',
    ),
    FollowTabModel(
      id: '8',
      name: 'Candie',
      imageUrl: '',
      status: 'Busy',
      category: 'girl',
      details: 'In 1-on-1 Video Call',
    ),
    FollowTabModel(
      id: '9',
      name: 'jessylover',
      imageUrl: '',
      status: 'Active',
      category: 'girl',
      details: 'Online Now',
    ),
    FollowTabModel(
      id: '10',
      name: 'Party Vibe Room',
      imageUrl: '',
      status: 'Party',
      category: 'room',
      details: 'Music & Voice Chat Room',
    ),
  ];
}
