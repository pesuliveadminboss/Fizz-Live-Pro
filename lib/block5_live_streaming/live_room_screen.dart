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
  bool _isMiniScreen = false;
  int _currentIndex = 0;

  void _handleNewMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Message sent: $msg'), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Floating Mini Screen View (Pip)
    if (_isMiniScreen) {
      return Stack(
        children: [
          Positioned(
            top: 80,
            right: 20,
            child: GestureDetector(
              onTap: () => setState(() => _isMiniScreen = false),
              child: Container(
                width: 130,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.pinkAccent, width: 2),
                ),
                child: Stack(
                  children: [
                    const Center(child: Icon(Icons.person, color: Colors.white54, size: 50)),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.black54,
                          child: Icon(Icons.close, color: Colors.white, size: 12),
                        ),
                      ),
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 120),
                        child: Text('Tap to Expand', style: TextStyle(color: Colors.white70, fontSize: 10)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: LiveStreamer.dummyStreamers.length,
        controller: PageController(initialPage: LiveStreamer.dummyStreamers.indexWhere((s) => s.id == widget.streamer.id).clamp(0, LiveStreamer.dummyStreamers.length - 1)),
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final currentStreamer = LiveStreamer.dummyStreamers[index];

          return Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: const Color(0xFF1D1B36),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.person, size: 150, color: Colors.white10),
                        const SizedBox(height: 10),
                        Text('Live: ${currentStreamer.name}', style: const TextStyle(color: Colors.white38, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ),

              // Top Header Bar
              Positioned(
                top: 40,
                left: 16,
                right: 16,
                child: LiveRoomHeader(
                  streamer: currentStreamer,
                  onMinimize: () => setState(() => _isMiniScreen = true),
                  onClose: () => Navigator.pop(context),
                ),
              ),

              // Right Side Vertical Ads & Roulette Position
              Positioned(
                top: 100,
                right: 12,
                child: LiveAdsIntegrationHelper.buildRightSideVerticalAds(),
              ),

              // Bottom Warning Box & Toolbar (Live Chat feed completely removed as requested)
              Positioned(
                bottom: 20,
                left: 16,
                right: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.withOpacity(0.5)),
                      ),
                      child: const Text(
                        'Pornographic, vulgar, violent and under age is forbidden to appear in the live. You\'ll be punished seriously once you violate the rules!',
                        style: TextStyle(color: Colors.amberAccent, fontSize: 9),
                      ),
                    ),
                    const SizedBox(height: 10),
                    LiveRoomBottomToolbar(
                      onOpenTools: () {},
                      onVideoCall: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Initiating Video Call...'), duration: Duration(seconds: 1)),
                        );
                      },
                      onGiftTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Opening Gift Panel...'), duration: Duration(seconds: 1)),
                        );
                      },
                      onLikeTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Liked Streamer ❤️'), duration: Duration(milliseconds: 500)),
                        );
                      },
                      onSendMessage: _handleNewMessage,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
