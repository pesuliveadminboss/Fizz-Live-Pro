import 'package:flutter/material.dart';
import 'party_room_screen.dart';

class PartyRoomOverlayManager {
  static OverlayEntry? _overlayEntry;

  static void showFloatingMiniPlayer({
    required BuildContext context,
    required dynamic room,
  }) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => _FloatingPartyRoomWidget(
        room: room,
        onClose: () {
          hideOverlay();
        },
        onExpand: () {
          hideOverlay();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PartyRoomScreen(room: room),
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

class _FloatingPartyRoomWidget extends StatefulWidget {
  final dynamic room;
  final VoidCallback onClose;
  final VoidCallback onExpand;

  const _FloatingPartyRoomWidget({
    required this.room,
    required this.onClose,
    required this.onExpand,
  });

  @override
  State<_FloatingPartyRoomWidget> createState() => _FloatingPartyRoomWidgetState();
}

class _FloatingPartyRoomWidgetState extends State<_FloatingPartyRoomWidget> with SingleTickerProviderStateMixin {
  Offset _offset = const Offset(20, 100);
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 2.0, end: 6.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _offset.dx,
      top: _offset.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _offset += details.delta;
          });
        },
        onTap: widget.onExpand,
        child: AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.cyanAccent, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.8),
                    blurRadius: 10,
                    spreadRadius: _glowAnimation.value,
                  )
                ],
                color: Colors.black87,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.mic, color: Colors.cyanAccent, size: 28),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: widget.onClose,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 10, color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow, size: 8, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
