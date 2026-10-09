import 'package:flutter/material.dart';
import 'live_streamer_model.dart';

class LiveStreamerOverlayManager {
  static OverlayEntry? _overlayEntry;

  static void showFloatingMiniPlayer({
    required BuildContext context,
    required LiveStreamer streamer,
    required VoidCallback onExpand,
    required VoidCallback onClose,
  }) {
    // If a mini player is already showing, remove it first so old streamer's mini player doesn't persist!
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
              child: Listener(
                // Using Listener and GestureDetector together for flawless touch detection
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
                        // Center area: Tapping here expands to Big Screen
                        Positioned.fill(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              hideOverlay();
                              onExpand();
                            },
                            child: const Center(
                              child: Icon(Icons.person, color: Colors.white54, size: 50),
                            ),
                          ),
                        ),
                        // Top-right close button: Tapping here closes the mini player completely
                        Positioned(
                          top: 6,
                          right: 6,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              hideOverlay();
                              onClose();
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
