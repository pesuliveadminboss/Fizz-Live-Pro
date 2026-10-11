import 'package:flutter/material.dart';
import 'party_room_model.dart';
import 'party_room_screen.dart';

class PartyRoomOverlayManager {
  static OverlayEntry? _overlayEntry;

  static void showCompactAudioMiniPlayer({
    required BuildContext context,
    required PartyRoom room,
  }) {
    hideOverlay();

    Offset position = const Offset(20, 120);

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
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D1B36),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.cyanAccent, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Center tap to expand back to Party Room Full Screen
                      Positioned.fill(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            hideOverlay();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PartyRoomScreen(room: room),
                              ),
                            );
                          },
                          child: const Center(
                            child: Icon(Icons.mic, color: Colors.cyanAccent, size: 28),
                          ),
                        ),
                      ),
                      // Tiny close button
                      Positioned(
                        top: 2,
                        right: 2,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            hideOverlay();
                          },
                          child: const CircleAvatar(
                            radius: 9,
                            backgroundColor: Colors.redAccent,
                            child: Icon(Icons.close, color: Colors.white, size: 10),
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

