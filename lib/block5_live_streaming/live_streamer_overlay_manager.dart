import 'package:flutter/material.dart';
import 'live_streamer_model.dart';
import 'dart:async';

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
          bool showCloseButton = false;
          Timer? hideTimer;

          void triggerCloseButtonVisibility() {
            setState(() {
              showCloseButton = true;
            });
            hideTimer?.cancel();
            hideTimer = Timer(const Duration(seconds: 2), () {
              if (context.mounted) {
                setState(() {
                  showCloseButton = false;
                });
              }
            });
          }

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
                child: GestureDetector(
                  onTap: () {
                    // Tapping anywhere on the mini screen shows close button momentarily OR expands if tapped center, 
                    // but let's make a dedicated tap to show close button and center to expand, or tap triggers close button visibility
                    triggerCloseButtonVisibility();
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
                        // Clean live stream view: Tapping the center expands to full screen
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: () {
                              hideOverlay();
                              onExpand();
                            },
                            child: const Center(
                              child: Icon(Icons.person, color: Colors.white54, size: 50),
                            ),
                          ),
                        ),
                        // Auto-hiding Close button (Visible for 2 seconds when tapped, then fades out)
                        if (showCloseButton)
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
