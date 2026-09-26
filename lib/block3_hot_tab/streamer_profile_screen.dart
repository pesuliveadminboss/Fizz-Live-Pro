import 'package:flutter/material.dart';
import 'streamer_profile_model.dart';
import 'profile_actions_dialogs.dart';
import 'profile_interaction_handler.dart';

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
                // Like / Heartbeat Button bottom-right of big photo
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.streamer.isLiked = !widget.streamer.isLiked;
                      });
                      String statusText = widget.streamer.isLiked ? 'Following' : 'Unfollowing';
                      _showBottomToast(statusText);
                    },
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.black45,
                      child: Icon(
                        widget.streamer.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: widget.streamer.isLiked ? Colors.pinkAccent : Colors.white,
                        size: 24,
                      ),
                    ),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.streamer.name,
                                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              if (widget.streamer.isVerified) ...[
                                const SizedBox(width: 6),
                                const Icon(Icons.verified, color: Colors.blueAccent, size: 16),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ID: 340301087',
                            style: TextStyle(color: Colors.white60, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Status & Country Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.streamer.status == 'live' ? Colors.pinkAccent : Colors.green,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.streamer.status.toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1D1B36),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${widget.streamer.flag} ${widget.streamer.country}',
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1D1B36),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${widget.streamer.age} yrs',
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Introduction Section
                  const Text('Introduction', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D1B36),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Text(
                      widget.streamer.intro,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Speaking Language Section
                  const Text('Speaking language', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: widget.streamer.language.split(',').map((lang) {
                      return Chip(
                        backgroundColor: const Color(0xFF1D1B36),
                        label: Text(lang.trim(), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: const Color(0xFF121026),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFF1D1B36),
              child: IconButton(
                icon: const Icon(Icons.message, color: Colors.blueAccent),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening chat with streamer...')),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEC4899),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: () => ProfileInteractionHandler.startVideoCall(context, widget.streamer.name),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.videocam, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Video • 1800 coins/min', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

