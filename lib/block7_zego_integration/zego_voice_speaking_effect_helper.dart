import 'package:flutter/material.dart';

class ZegoVoiceSpeakingEffectHelper extends StatefulWidget {
  final int seatIndex;
  final String userName;
  final bool isSpeaking;
  final bool isMuted;

  const ZegoVoiceSpeakingEffectHelper({
    super.key,
    required this.seatIndex,
    required this.userName,
    required this.isSpeaking,
    required this.isMuted,
  });

  @override
  State<ZegoVoiceSpeakingEffectHelper> createState() => _ZegoVoiceSpeakingEffectHelperState();
}

class _ZegoVoiceSpeakingEffectHelperState extends State<ZegoVoiceSpeakingEffectHelper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isSpeaking ? _scaleAnimation.value : 1.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.isSpeaking ? Colors.cyanAccent : Colors.white24,
                    width: widget.isSpeaking ? 3.0 : 1.0,
                  ),
                  boxShadow: widget.isSpeaking
                      ? [
                          BoxShadow(
                            color: Colors.cyanAccent.withOpacity(0.6),
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                        ]
                      : [],
                ),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: widget.isMuted
                      ? Colors.redAccent.withOpacity(0.4)
                      : Colors.pinkAccent.withOpacity(0.4),
                  child: Icon(
                    widget.isMuted ? Icons.mic_off : Icons.mic,
                    color: widget.isMuted ? Colors.white54 : Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.userName,
                style: TextStyle(
                  color: widget.isSpeaking ? Colors.cyanAccent : Colors.white70,
                  fontSize: 10,
                  fontWeight: widget.isSpeaking ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
