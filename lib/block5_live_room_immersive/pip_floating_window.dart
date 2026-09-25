import 'package:flutter/material.dart';

class PipFloatingWindow extends StatefulWidget {
  final Widget child;
  final VoidCallback onClose;
  final VoidCallback onTapExpand;

  const PipFloatingWindow({
    super.key,
    required this.child,
    required this.onClose,
    required this.onTapExpand,
  });

  @override
  State<PipFloatingWindow> createState() => _PipFloatingWindowState();
}

class _PipFloatingWindowState extends State<PipFloatingWindow> {
  Offset _position = const Offset(20, 100);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _position += details.delta;
          });
        },
        onTap: widget.onTapExpand,
        child: Container(
          width: 140,
          height: 220,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.pinkAccent, width: 2),
            boxShadow: const [
              BoxShadow(color: Colors.black54, blurRadius: 10, spreadRadius: 2),
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
                  right: 4,
                  child: GestureDetector(
                    onTap: widget.onClose,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
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
    );
  }
}
