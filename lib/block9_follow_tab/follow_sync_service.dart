import 'package:flutter/material.dart';

class FollowUserModel {
  final String id;
  final String name;
  final String imageUrl;
  String status; // 'Active', 'Live', 'Party', 'Busy'
  final String category; // 'girl' or 'room'
  final String details;
  bool isOnline;

  FollowUserModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.status,
    required this.category,
    required this.details,
    required this.isOnline,
  });
}

class FollowSyncService extends ChangeNotifier {
  static final FollowSyncService _instance = FollowSyncService._internal();
  factory FollowSyncService() => _instance;
  FollowSyncService._internal();

  // Global followed list (Synced across all screens)
  final Set<String> _followedIds = {'1', '2', '4', '5', '10'};

  final List<FollowUserModel> _allStreamers = [
    FollowUserModel(id: '1', name: 'MariaSopya', imageUrl: '', status: 'Active', category: 'girl', details: 'Online Now', isOnline: true),
    FollowUserModel(id: '2', name: 'SEXYDOLL💖-', imageUrl: '', status: 'Busy', category: 'girl', details: 'In Video Call', isOnline: true),
    FollowUserModel(id: '3', name: 'Brenda', imageUrl: '', status: 'Offline', category: 'girl', details: 'Offline', isOnline: false),
    FollowUserModel(id: '4', name: 'Rani Sharma', imageUrl: '', status: 'Live', category: 'girl', details: 'Live in Tamil Nadu', isOnline: true),
    FollowUserModel(id: '5', name: 'Serena❤️', imageUrl: '', status: 'Party', category: 'room', details: 'Candy Fiesta Room', isOnline: true),
    FollowUserModel(id: '10', name: 'Party Vibe Room', imageUrl: '', status: 'Party', category: 'room', details: 'Music Voice Chat', isOnline: true),
  ];

  // Get only online and followed users/rooms
  List<FollowUserModel> getFollowedGirls() {
    return _allStreamers.where((user) => _followedIds.contains(user.id) && user.isOnline && user.category == 'girl').toList();
  }

  List<FollowUserModel> getFollowedRooms() {
    return _allStreamers.where((user) => _followedIds.contains(user.id) && user.isOnline && user.category == 'room').toList();
  }

  bool isFollowing(String id) {
    return _followedIds.contains(id);
  }

  void toggleFollow(String id) {
    if (_followedIds.contains(id)) {
      _followedIds.remove(id);
    } else {
      _followedIds.add(id);
    }
    notifyListeners();
  }

  // Simulate dynamic status update (Live -> Busy -> Active)
  void updateStreamerStatus(String id, String newStatus) {
    final index = _allStreamers.indexWhere((u) => u.id == id);
    if (index != -1) {
      _allStreamers[index].status = newStatus;
      notifyListeners();
    }
  }
}
