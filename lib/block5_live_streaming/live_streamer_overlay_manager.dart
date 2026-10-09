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
    hideOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) => _FloatingPlayerWidget(
        streamer: streamer,
        onExpand: onExpand,
        onClose: onClose,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class _FloatingPlayerWidget extends StatefulWidget {
  final LiveStreamer streamer;
  final VoidCallback onExpand;
  final VoidCallback onClose;

  const _FloatingPlayerWidget({
    required this.streamer,
    required this.onExpand,
    required this.onClose,
  });

  @override
  State<_FloatingPlayerWidget> createState() => _FloatingPlayerWidgetState();
}

class _FloatingPlayerWidgetState extends State<_FloatingPlayerWidget> {
  Offset position = const Offset(20, 100);

  @override
  Widget build(BuildContext context) {
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
                // Center Tap to Expand
                Positioned.fill(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      LiveStreamerOverlayManager.hideOverlay();
                      widget.onExpand();
                    },
                    child: const Center(
                      child: Icon(Icons.person, color: Colors.white54, size: 50),
                    ),
                  ),
                ),
                // Close Button to Kill Mini Screen
                Positioned(
                  top: 6,
                  right: 6,
                  child: InkWell(
                    onTap: () {
                      LiveStreamerOverlayManager.hideOverlay();
                      widget.onClose();
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
  }
}
