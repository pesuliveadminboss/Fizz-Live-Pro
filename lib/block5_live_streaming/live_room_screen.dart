import 'package:flutter/material.dart';
import 'live_streamer_model.dart';
import 'live_room_header.dart';
import 'live_room_bottom_toolbar.dart';
import 'live_tools_and_gifts_helper.dart';
import 'live_ads_integration_helper.dart';

class LiveRoomScreen extends StatefulWidget {
  final LiveStreamer streamer;
  const LiveRoomScreen({super.key, required this.streamer});

  @override
  State<LiveRoomScreen> createState() => _LiveRoomScreenState();
}

class _LiveRoomScreenState extends State<LiveRoomScreen> {
  bool _isFollowing = false;
  final List<Map<String, String>> _liveChats = [
    {'user': 'Maryam ❤️', 'message': 'Hi! Thanks for joining my live, feel free to talk with me'},
    {'user': 'guest', 'message': 'joined the room'},
  ];

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: const Color(0xFF1D1B36),
              child: const Center(
                child: Icon(Icons.person, size: 150, color: Colors.white10),
              ),
            ),
          ),

          // Top Header Bar
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: LiveRoomHeader(
              streamer: widget.streamer,
              onClose: () => Navigator.pop(context),
            ),
          ),

          // Right Side Mini Ads Position
          Positioned(
            top: 100,
            right: 16,
            child: LiveAdsIntegrationHelper.buildRightSideMiniAds(),
          ),

          // Bottom Chat & Toolbar
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.withOpacity(0.5)),
                  ),
                  child: const Text(
                    'Pornographic, vulgar, violent and under age is forbidden to appear in the live. You\'ll be punished seriously once you violate the rules!',
                    style: TextStyle(color: Colors.amberAccent, fontSize: 10),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 90,
                  child: ListView.builder(
                    itemCount: _liveChats.length,
                    itemBuilder: (context, index) {
                      final chat = _liveChats[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${chat['user']}: ',
                                style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: chat['message'],
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                LiveRoomBottomToolbar(
                  isFollowing: _isFollowing,
                  onToggleFollow: _toggleFollow,
                  onOpenTools: () => LiveToolsAndGiftsHelper.showToolsMenu(context, () {}),
                  onVideoCall: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Initiating Video Call...'), duration: Duration(seconds: 1)),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
