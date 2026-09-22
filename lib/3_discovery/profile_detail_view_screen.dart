import 'dart:async';
import 'package:flutter/material.dart';
import '../controllers/app_state_controller.dart';
import '../4_interactions/call_screen.dart';

class ProfileDetailViewScreen extends StatefulWidget {
  final dynamic streamer;
  const ProfileDetailViewScreen({super.key, required this.streamer});

  @override
  State<ProfileDetailViewScreen> createState() => _ProfileDetailViewScreenState();
}

class _ProfileDetailViewScreenState extends State<ProfileDetailViewScreen> {
  late bool isFollowed;
  bool showUnfollowToast = false;
  bool showFollowToast = false;

  @override
  void initState() {
    super.initState();
    isFollowed = widget.streamer is UserProfileItem 
        ? (widget.streamer as UserProfileItem).isFollowed 
        : false;
  }

  void _toggleFollowSync() {
    setState(() {
      isFollowed = !isFollowed;
      if (widget.streamer is UserProfileItem) {
        AppStateController.instance.toggleFollow(widget.streamer as UserProfileItem);
      }
      if (isFollowed) {
        showFollowToast = true;
        showUnfollowToast = false;
      } else {
        showUnfollowToast = true;
        showFollowToast = false;
      }
    });

    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          showFollowToast = false;
          showUnfollowToast = false;
        });
      }
    });
  }

  @override
  Widget build(context) {
    final name = widget.streamer is UserProfileItem ? (widget.streamer as UserProfileItem).name : 'Streamer/User';
    final idDigits = widget.streamer is UserProfileItem ? (widget.streamer as UserProfileItem).idDigit : '90001001';

    return Scaffold(
      backgroundColor: const Color(0xFF0F0B1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0B1E),
        title: Text(name, style: const TextStyle(color: Colors.white, fontSize: 16)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          GestureDetector(
            onTap: _toggleFollowSync,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                isFollowed ? Icons.favorite : Icons.favorite_border,
                color: isFollowed ? Colors.black : Colors.pinkAccent,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(radius: 40, backgroundColor: Colors.pinkAccent, child: Icon(Icons.person, size: 50, color: Colors.white)),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('ID: $idDigits', style: const TextStyle(color: Colors.amber, fontSize: 12)),
                        const Text('Status: Online / Active', style: TextStyle(color: Colors.green, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: _toggleFollowSync,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isFollowed ? Colors.white24 : Colors.pinkAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(isFollowed ? Icons.favorite : Icons.favorite_border, color: isFollowed ? Colors.black : Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(isFollowed ? 'Following (Tap to unfollow)' : 'Follow', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (showFollowToast || showUnfollowToast)
            Positioned(
              bottom: 80,
              left: 40,
              right: 40,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    showFollowToast ? 'following' : 'unfollowing',
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CallScreen(callType: 'Video')));
                },
                child: const Text('Start 1-to-1 Video Call (1800 gems/min)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
