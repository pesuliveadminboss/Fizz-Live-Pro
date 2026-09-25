import 'package:flutter/material.dart';

// Both names supported so no more type errors
class StreamerItem {
  final String id;
  final String name;
  final String country;
  final String flag;
  final int age;
  final String status; // 'online', 'live', 'party', 'offline'
  final String intro;
  final String language;

  StreamerItem({
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

typedef StreamerModel = StreamerItem;

final List<StreamerItem> kMockStreamers = [
  StreamerItem(id: '1', name: 'AvniHotnessDil', country: 'India', flag: '🇮🇳', age: 24, status: 'live', intro: 'Welcome to my live room!', language: 'Hindi, English'),
  StreamerItem(id: '2', name: 'Shiny Sanya', country: 'America', flag: '🇺🇸', age: 22, status: 'online', intro: 'Always smiling ✨', language: 'English'),
  StreamerItem(id: '3', name: 'Jocelyn Kidmat', country: 'Bangladesh', flag: '🇧🇩', age: 26, status: 'party', intro: 'Party all night!', language: 'Bengali, English'),
  StreamerItem(id: '4', name: 'Offline Girl', country: 'India', flag: '🇮🇳', age: 25, status: 'offline', intro: 'Busy right now', language: 'Tamil'),
];

final List<StreamerItem> kAllStreamers = kMockStreamers;
