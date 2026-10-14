import 'package:flutter/material.dart';

class PartyRoomMinimizeHelper {
  static Widget buildMinimizedFloatingWidget({
    required Offset offset,
    required Function(DragUpdateDetails) onPanUpdate,
    required VoidCallback onTap,
    required Animation<double> glowAnimation,
  }) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: GestureDetector(
        onPanUpdate: onPanUpdate,
        onTap: onTap,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.cyanAccent, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withOpacity(0.8),
                blurRadius: 10,
                spreadRadius: glowAnimation.value,
              )
            ],
            color: Colors.black87,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.mic, color: Colors.cyanAccent, size: 26),
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
        ),
      ),
    );
  }
}
