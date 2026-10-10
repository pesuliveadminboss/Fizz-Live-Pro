import 'package:flutter/material.dart';
import 'live_streamer_model.dart';
import 'live_room_screen.dart';

class LiveStreamerOverlayManager {
  static OverlayEntry? _overlayEntry;

  static void showFloatingMiniPlayer({
    required BuildContext context,
    required LiveStreamer streamer,
  }) {
    hideOverlay();

    Offset position = const Offset(20, 100);

    _overlayEntry = OverlayEntry(
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Positioned(
            left: position.dx,
            top: position.dy,
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    position += details.delta;
                  });
                },
                child: Container(
                  width: 140,
                  height: 220,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D1B36),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.pinkAccent, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Center tap to open Big Screen
                      Positioned.fill(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            hideOverlay();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LiveRoomScreen(streamer: streamer),
                              ),
                            );
                          },
                          child: const Center(
                            child: Icon(Icons.person, color: Colors.white54, size: 50),
                          ),
                        ),
                      ),
                      // Close button to kill mini player
                      Positioned(
                        top: 6,
                        right: 6,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            hideOverlay();
                          },
                          child: const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.black54,
                            child: Icon(Icons.close, color: Colors.white, size: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
