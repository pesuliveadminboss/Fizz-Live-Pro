import 'package:flutter/material.dart';

class UserProfileItem {
  final String idDigit;
  final String name;
  final String status; // 'online', 'live', 'busy', 'party', 'offline'
  final String country;
  final int age;
  final String induction;
  final String language;
  bool isFollowed;

  UserProfileItem({
    required this.idDigit,
    required this.name,
    required this.status,
    required this.country,
    required this.age,
    required this.induction,
    required this.language,
    this.isFollowed = false,
  });

  bool get isOnlineOrActive => status != 'offline';
}

class AppStateController extends ChangeNotifier {
  static final AppStateController instance = AppStateController._internal();
  factory AppStateController() => instance;
  AppStateController._internal();

  final List<UserProfileItem> allUsers = [
    UserProfileItem(idDigit: '8002023', name: 'Jocelyn Kidmat', status: 'online', country: 'Delhi', age: 34, induction: 'main tumhen chaahati hoon.', language: 'English, Hindi', isFollowed: true),
    UserProfileItem(idDigit: '90001001', name: 'Ayesha_Live', status: 'live', country: 'IN', age: 24, induction: 'Live vibe check', language: 'Tamil, English', isFollowed: true),
    UserProfileItem(idDigit: '90001002', name: 'Party_King_99', status: 'party', country: 'IN', age: 27, induction: 'Party all night', language: 'Hindi, English'),
    UserProfileItem(idDigit: '90001003', name: 'Offline_Guy', status: 'offline', country: 'UK', age: 30, induction: 'Busy offline', language: 'English'),
  ];

  UserProfileItem? searchById(String id) {
    try {
      return allUsers.firstWhere((u) => u.idDigit == id.trim());
    } catch (_) {
      return null;
    }
  }

  List<UserProfileItem> getFollowedOnlineUsers() {
    return allUsers.where((u) => u.isFollowed && u.isOnlineOrActive).toList();
  }

  void toggleFollow(UserProfileItem user) {
    user.isFollowed = !user.isFollowed;
    notifyListeners();
  }
}

