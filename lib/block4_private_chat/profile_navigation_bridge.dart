import 'package:flutter/material.dart';
import '../block3_hot_tab/streamer_profile_model.dart';
import '../block3_hot_tab/streamer_profile_screen.dart';
import 'private_chat_screen.dart';

class ProfileNavigationBridge {
  
  // Navigate to streamer profile with synced follow state callback
  static void openStreamerProfile({
    required BuildContext context,
    required String streamerId,
    required String streamerName,
    String country = 'India',
    String flag = '🇮🇳',
    int age = 22,
    String status = 'live',
    String intro = 'Welcome to my live stream!',
    String language = 'English, Tamil',
    bool isVerified = true,
    required bool isFollowing,
    required ValueChanged<bool> onFollowChanged,
  }) {
    final streamerModel = StreamerProfileModel(
      id: streamerId,
      name: streamerName,
      country: country,
      flag: flag,
      age: age,
      status: status,
      intro: intro,
      language: language,
      isVerified: isVerified,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StreamerProfileScreen(streamer: streamerModel),
      ),
    );
  }

  static void openPrivateChat({
    required BuildContext context,
    required String streamerName,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PrivateChatScreen(streamerName: streamerName),
      ),
    );
  }
}
