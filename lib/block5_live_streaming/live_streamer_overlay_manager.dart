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
    if (_overlayEntry != null) return;

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
                      // Center area tap to expand to Big Screen
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
                      // Top-right close button to kill the mini player
                      Positioned(
                        top: 4,
                        right: 4,
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
