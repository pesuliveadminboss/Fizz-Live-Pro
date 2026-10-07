import 'package:flutter/material.dart';
import 'streamer_profile_model.dart';
import 'profile_actions_dialogs.dart';
import 'profile_interaction_handler.dart';
import '../block4_private_chat/private_chat_screen.dart';
import '../block5_live_streaming/streamer_follow_manager.dart';

class StreamerProfileScreen extends StatefulWidget {
  final StreamerProfileModel streamer;
  const StreamerProfileScreen({super.key, required this.streamer});

  @override
  State<StreamerProfileScreen> createState() => _StreamerProfileScreenState();
}

class _StreamerProfileScreenState extends State<StreamerProfileScreen> {
  OverlayEntry? _overlayEntry;

  void _showBottomToast(String message) {
    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 80,
        left: MediaQuery.of(context).size.width * 0.25,
        right: MediaQuery.of(context).size.width * 0.25,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1D1B36),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.pinkAccent.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 2), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.streamer.isBanned) {
      return Scaffold(
        backgroundColor: const Color(0xFF121026),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Account Suspended: Customer met 1 month ban due to multiple reports.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

    // Connects with Global Follow Manager to sync with live room header and popup buttons
    final followNotifier = StreamerFollowManager().getFollowNotifier(widget.streamer.name);

    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Big Photo & App Bar Navigation
            Stack(
              children: [
                Container(
                  height: 380,
                  width: double.infinity,
                  color: const Color(0xFF1D1B36),
                  child: const Center(
                    child: Icon(Icons.person, size: 120, color: Colors.white24),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_horiz, color: Colors.white),
                          onPressed: () => ProfileActionsDialogs.showMoreOptionsSheet(
                            context,
                            widget.streamer,
                            () => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Globally Synced Like / Heartbeat Button bottom-right of big photo
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: followNotifier,
                    builder: (context, isFollowing, child) {
                      return GestureDetector(
                        onTap: () {
                          StreamerFollowManager().toggleFollow(widget.streamer.name);
                          String statusText = !isFollowing ? 'Following' : 'Unfollowing';
                          _showBottomToast(statusText);
                        },
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.black45,
                          child: Icon(
                            isFollowing ? Icons.favorite : Icons.favorite_border,
                            color: isFollowing ? Colors.pinkAccent : Colors.white,
                            size: 24,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Profile Details Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: const Color(0xFF6366F1),
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        cross
                        
