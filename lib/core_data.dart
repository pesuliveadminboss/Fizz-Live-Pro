import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreamerItem {
  final String id;
  final String name;
  final String country;
  final String flag;
  final String status;
  final int age;
  final Color color;
  final bool isOffline;
  StreamerItem({
    required this.id,
    required this.name,
    required this.country,
    required this.flag,
    required this.status,
    required this.age,
    required this.color,
    this.isOffline = false,
  });
}

final List<StreamerItem> kMockStreamers = [
  StreamerItem(id: '1', name: 'AvniHotnessDil', country: 'India', flag: '🇮🇳', status: 'online', age: 27, color: const Color(0xFFE94057)),
  StreamerItem(id: '2', name: 'Shiny Sanya', country: 'India', flag: '🇮🇳', status: 'party', age: 25, color: const Color(0xFF8A2387)),
  StreamerItem(id: '3', name: 'Bella_America', country: 'America', flag: '🇺🇸', status: 'live', age: 24, color: const Color(0xFF00C9FF)),
  StreamerItem(id: '4', name: 'Riya_BD', country: 'Bangladesh', flag: '🇧🇩', status: 'online', age: 23, color: const Color(0xFF00B09B)),
  StreamerItem(id: '5', name: 'Zara_Pak', country: 'Pakistan', flag: '🇵🇰', status: 'party', age: 26, color: const Color(0xFFFF512F)),
  StreamerItem(id: '6', name: 'Elena_Rus', country: 'Russia', flag: '🇷🇺', status: 'live', age: 25, color: const Color(0xFF92FE9D)),
  StreamerItem(id: '7', name: 'Asha_Afr', country: 'Africa', flag: '🌍', status: 'online', age: 24, color: const Color(0xFFF27121)),
  StreamerItem(id: '8', name: 'Mada_Girl', country: 'Madagascar', flag: '🇲🇬', status: 'party', age: 22, color: const Color(0xFFE94057)),
  StreamerItem(id: '9', name: 'Offline_Emma', country: 'India', flag: '🇮🇳', status: 'offline', age: 26, color: Colors.grey, isOffline: true),
];
