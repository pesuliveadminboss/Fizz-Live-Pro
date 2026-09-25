import 'package:flutter/material.dart';

class StreamerItem {
  final String id;
  final String name;
  final String country;
  final String flag;
  final int age;
  final String status; // 'live', 'party', 'online'
  final bool isOffline;
  final Color color;
  final String bio;
  final String speakingLanguage;

  StreamerItem({
    required this.id,
    required this.name,
    required this.country,
    required this.flag,
    required this.age,
    required this.status,
    required this.isOffline,
    required this.color,
    required this.bio,
    required this.speakingLanguage,
  });
}

final List<StreamerItem> kMockStreamers = [
  StreamerItem(
    id: 's1',
    name: 'AvniHotnessDil',
    country: 'India',
    flag: '🇮🇳',
    age: 27,
    status: 'live',
    isOffline: false,
    color: Colors.pink,
    bio: 'main tumhen chaahati hoon. aap kitane hot hain.',
    speakingLanguage: 'Hindi, English',
  ),
  StreamerItem(
    id: 's2',
    name: 'Shiny Sanya',
    country: 'India',
    flag: '🇮🇳',
    age: 28,
    status: 'party',
    isOffline: false,
    color: Colors.purple,
    bio: 'Always grateful 🌸✨',
    speakingLanguage: 'English, Tamil',
  ),
  StreamerItem(
    id: 's3',
    name: 'Exotic Moka',
    country: 'Egypt',
    flag: '🇪🇬',
    age: 25,
    status: 'live',
    isOffline: false,
    color: Colors.blue,
    bio: 'Call me if you are free. Waiting for you!',
    speakingLanguage: 'Arabic, English',
  ),
  StreamerItem(
    id: 's4',
    name: 'Jocelyn Kidmat',
    country: 'Delhi',
    flag: '🇮🇳',
    age: 34,
    status: 'live',
    isOffline: false,
    color: Colors.deepOrange,
    bio: 'Fun show baby, lets talk dirty.',
    speakingLanguage: 'Hindi, English',
  ),
  StreamerItem(
    id: 's5',
    name: 'Sara',
    country: 'Pakistan',
    flag: '🇵🇰',
    age: 21,
    status: 'live',
    isOffline: false,
    color: Colors.teal,
    bio: 'Welcome to my live room! Lets chat.',
    speakingLanguage: 'Urdu, English',
  ),
];
