import 'package:flutter/material.dart';

class StreamerModel {
  final String id;
  final String name;
  final String country;
  final String flag;
  final int age;
  final String status; // 'online', 'live', 'party', 'offline'
  final String intro;
  final String language;
  
  StreamerModel({
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

final List<StreamerModel> kAllStreamers = [
  StreamerModel(id: '1', name: 'AvniHotnessDil', country: 'India', flag: '🇮🇳', age: 24, status: 'live', intro: 'Welcome to my live room!', language: 'Hindi, English'),
  StreamerModel(id: '2', name: 'Shiny Sanya', country: 'America', flag: '🇺🇸', age: 22, status: 'online', intro: 'Always smiling ✨', language: 'English'),
  StreamerModel(id: '3', name: 'Jocelyn Kidmat', country: 'Bangladesh', flag: '🇧🇩', age: 26, status: 'party', intro: 'Party all night!', language: 'Bengali, English'),
  StreamerModel(id: '4', name: 'Offline Girl', country: 'India', flag: '🇮🇳', age: 25, status: 'offline', intro: 'Busy right now', language: 'Tamil'),
];
