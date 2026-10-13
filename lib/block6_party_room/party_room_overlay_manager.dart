import 'package:flutter/material.dart';

class PartyRoomOverlayManager extends StatelessWidget {
  final bool isCinematicActive;
  final Widget child;

  const PartyRoomOverlayManager({
    super.key,
    required this.isCinematicActive,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isCinematicActive)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.pinkAccent.withOpacity(0.05),
                      Colors.transparent,
                      Colors.purpleAccent.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

