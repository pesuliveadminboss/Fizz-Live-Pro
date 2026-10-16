import 'package:flutter/material.dart';
import 'streamer_session_model.dart';
import 'streamer_blur_overlay.dart';
import 'live_queue_scroll_manager.dart';

class SmartLiveStreamingHub extends StatefulWidget {
  const SmartLiveStreamingHub({super.key});

  @override
  State<SmartLiveStreamingHub> createState() => _SmartLiveStreamingHubState();
}

class _SmartLiveStreamingHubState extends State<SmartLiveStreamingHub> {
  final LiveQueueScrollManager _scrollManager = LiveQueueScrollManager();

  @override
  void initState() {
    super.initState();
    _scrollManager.addListener(_onManagerChanged);
  }

  void _onManagerChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _scrollManager.removeListener(_onManagerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final StreamerSessionModel? activeStreamer = _scrollManager.getCurrentActiveStreamer();

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          // Smart swipe/scroll to next active live streamer, automatically skipping busy or offline ones
          _scrollManager.switchToNextStreamer();
        },
        child: Stack(
          children: [
            // Normal Live Stream Video / Background Screen Placeholder
            Positioned.fill(
              child: Container(
                color: const Color(0xFF1D1B36),
                child: Center(
                  child: Text(
                    activeStreamer != null
                        ? 'Live Stream Room: ${activeStreamer.streamerName}'
                        : 'No Active Live Streamers',
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            // Conditional Blur & "I'll back soon..." Overlay if Streamer is busy in 1-on-1 call
            if (activeStreamer != null && activeStreamer.isBusyInCall)
              Positioned.fill(
                child: StreamerBlurOverlay(
                  streamerName: activeStreamer.streamerName,
                  avatarUrl: activeStreamer.profileImageUrl,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
