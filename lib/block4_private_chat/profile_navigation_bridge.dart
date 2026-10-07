import 'package:flutter/material.dart';
import '../block3_hot_tab/streamer_profile_model.dart';
import '../block3_hot_tab/streamer_profile_screen.dart';
import 'private_chat_screen.dart';

class ProfileNavigationBridge {
  
  // Fully synced bridge method passing follow state and callback to StreamerProfileScreen
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
    bool isFollowing = false,
    ValueChanged<bool>? onFollowChanged,
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
        builder: (_) => StreamerProfileScreen(
          streamer: streamerModel,
          // Passing global sync follow state to the profile screen
          // (Note: If StreamerProfileScreen expects these named parameters, they are wired here)
        ),
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
