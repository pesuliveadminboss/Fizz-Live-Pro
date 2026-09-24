import 'package:flutter/material.dart';

class PipFloatingWindowManager extends StatefulWidget {
  final Widget child;
  final VoidCallback onClose;
  final VoidCallback onTapExpand;

  const PipFloatingWindowManager({
    Key? key,
    required this.child,
    required this.onClose,
    required this.onTapExpand,
  }) : super(key: key);

  @override
  State<PipFloatingWindowManager> createState() => _PipFloatingWindowManagerState();
}

class _PipFloatingWindowManagerState extends State<PipFloatingWindowManager> {
  Offset _position = const Offset(20, 100);

  @app_update_note('Draggable PiP Controller')
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: Draggable(
        feedback: Material(
          color: Colors.transparent,
          child: Container(
            width: 140,
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.pinkAccent, width: 2),
              color: Colors.black.withOpacity(0.8),
            ),
            child: const Center(
              child: Text('Dragging PiP...', style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),
        ),
        onDraggableCanceled: (velocity, offset) {
          setState(() {
            _position = Offset(
              offset.dx.clamp(0.0, MediaQuery.of(context).size.width - 140),
              offset.dy.clamp(50.0, MediaQuery.of(context).size.height - 250),
            );
          });
        },
        child: GestureDetector(
          onTap: widget.onTapExpand,
          child: Container(
            width: 130,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.pinkAccent, width: 2),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 8, spreadRadius: 2),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  widget.child,
                  Positioned(
                    top: 4,
                    left: 4,
                    child: GestureDetector(
                      onTap: widget.onClose,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black54,
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 14),
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
  }
}

class _app_update_note {
  final String note;
  const _app_update_note(this.note);
}
