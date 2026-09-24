import 'package:flutter/material.dart';

enum StreamerCategory { pretty, newStreamer, sexy }

class CategoryStreamerItem {
  final String id;
  final String name;
  final String country;
  final String flag;
  final String profileImageUrl;
  final StreamerCategory category;
  final int age;
  final int viewersCount;

  CategoryStreamerItem({
    required this.id,
    required this.name,
    required this.country,
    required this.flag,
    required this.profileImageUrl,
    required this.category,
    required this.age,
    required this.viewersCount,
  });
}

class LiveStreamFilterManager {
  static List<CategoryStreamerItem> getMockCategoryStreamers() {
    return [
      CategoryStreamerItem(
        id: 'p1',
        name: 'Muskan',
        country: 'India',
        flag: '🇮🇳',
        profileImageUrl: 'assets/images/muskan.jpg',
        category: StreamerCategory.pretty,
        age: 22,
        viewersCount: 2410,
      ),
      CategoryStreamerItem(
        id: 'p2',
        name: 'Nila',
        country: 'India',
        flag: '🇮🇳',
        profileImageUrl: 'assets/images/nila.jpg',
        category: StreamerCategory.pretty,
        age: 23,
        viewersCount: 1520,
      ),
      CategoryStreamerItem(
        id: 'n1',
        name: 'Natasha',
        country: 'India',
        flag: '🇮🇳',
        profileImageUrl: 'assets/images/natasha.jpg',
        category: StreamerCategory.newStreamer,
        age: 21,
        viewersCount: 890,
      ),
      CategoryStreamerItem(
        id: 'n2',
        name: 'Sara',
        country: 'India',
        flag: '🇮🇳',
        profileImageUrl: 'assets/images/sara.jpg',
        category: StreamerCategory.newStreamer,
        age: 20,
        viewersCount: 430,
      ),
      CategoryStreamerItem(
        id: 's1',
        name: 'Tala',
        country: 'Egypt',
        flag: '🇪🇬',
        profileImageUrl: 'assets/images/tala.jpg',
        category: StreamerCategory.sexy,
        age: 25,
        viewersCount: 3403,
      ),
      CategoryStreamerItem(
        id: 's2',
        name: 'Niki',
        country: 'India',
        flag: '🇮🇳',
        profileImageUrl: 'assets/images/niki.jpg',
        category: StreamerCategory.sexy,
        age: 24,
        viewersCount: 1890,
      ),
    ];
  }

  static List<CategoryStreamerItem> filterByCategory(
      List<CategoryStreamerItem> allStreamers, StreamerCategory category) {
    return allStreamers.where((streamer) => streamer.category == category).toList();
  }
}
