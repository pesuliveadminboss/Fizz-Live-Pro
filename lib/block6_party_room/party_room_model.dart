class PartyRoom {
  final String id;
  final String roomName;
  final String hostName;
  final int onlineCount;
  final String themeType; // 'cruise', 'couple', 'dj', 'retro'
  final List<String> seats;

  PartyRoom({
    required this.id,
    required this.roomName,
    required this.hostName,
    required this.onlineCount,
    required this.themeType,
    required this.seats,
  });

  static List<PartyRoom> dummyRooms = [
    PartyRoom(
      id: '1',
      roomName: 'Sweet Couple Ceremony ❤️',
      hostName: 'PariHub Star',
      onlineCount: 11,
      themeType: 'cruise',
      seats: ['Host', 'Co-Host', 'User1', 'User2', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty'],
    ),
    PartyRoom(
      id: '2',
      roomName: 'Mahfil a Isha 🌙',
      hostName: 'Aisha Live',
      onlineCount: 8,
      themeType: 'couple',
      seats: ['Host', 'Guest1', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty'],
    ),
    PartyRoom(
      id: '3',
      roomName: 'Super Party TV 🎉',
      hostName: 'DJ Rahul',
      onlineCount: 15,
      themeType: 'dj',
      seats: ['Host', 'DJ', 'Dancer1', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty'],
    ),
    PartyRoom(
      id: '4',
      roomName: 'Night Vibes & Chill ✨',
      hostName: 'Kavi Speaker',
      onlineCount: 6,
      themeType: 'retro',
      seats: ['Host', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty'],
    ),
  ];
}
