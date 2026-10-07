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
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  position += details.delta;
                });
              },
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 140,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.black,
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
                      // Tap center to expand back to full live room
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: () {
                            hideOverlay();
                            onExpand();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.person, color: Colors.white54, size: 40),
                              const SizedBox(height: 8),
                              Text(
                                streamer.name,
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              const Text('Tap to Expand', style: TextStyle(color: Colors.white70, fontSize: 9)),
                            ],
                          ),
                        ),
                      ),
                      // Close button inside mini player to kill live completely
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
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
