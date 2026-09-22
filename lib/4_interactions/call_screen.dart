import 'dart:async';
import 'package:flutter/material.dart';

class CallScreen extends StatefulWidget {
  final String callType; // 'Video' or 'Voice'
  final String peerName;
  const CallScreen({super.key, this.callType = 'Video', this.peerName = 'User_90001001'});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool isMicMuted = false;
  bool isCameraOff = false;
  bool isSpeakerOn = true;
  int secondsElapsed = 0;
  Timer? _callTimer;

  @override
  void initState() {
    super.initState();
    isCameraOff = widget.callType == 'Voice';
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => secondsElapsed++);
      }
    });
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(int secs) {
    final mins = secs ~/ 60;
    final remainingSecs = secs % 60;
    return '${mins.toString().padLeft(2, '0')}:${remainingSecs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Remote video or avatar placeholder
          Positioned.fill(
            child: isCameraOff
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(radius: 50, backgroundColor: Colors.pinkAccent, child: Icon(Icons.person, size: 60, color: Colors.white)),
                        SizedBox(height: 12),
                        Text('Voice / Camera Off Call', style: TextStyle(color: Colors.white75, fontSize: 14)),
                      ],
                    ),
                  )
                : Container(
                    color: const Color(0xFF181329),
                    child: const Center(
                      child: Icon(Icons.videocam, size: 90, color: Colors.white24),
                    ),
                  ),
          ),
          // Top Bar (Peer info, duration, coin burn rate)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(radius: 18, backgroundColor: Colors.pinkAccent, child: Icon(Icons.person, size: 20, color: Colors.white)),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.peerName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          Text(_formatDuration(secondsElapsed), style: const TextStyle(color: Colors.amber, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(12)),
                    child: const Text('💎 40/min', style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          // Picture-in-picture local preview (if video call)
          if (widget.callType == 'Video' && !isCameraOff)
            Positioned(
              top: 80,
              right: 16,
              child: Container(
                width: 90,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Center(child: Text('You', style: TextStyle(color: Colors.white54, fontSize: 10))),
              ),
            ),
          // Bottom Control Dock (Mic, Camera, Speaker, Flip, End Call)
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => setState(() => isMicMuted = !isMicMuted),
                  child: CircleAvatar(
                    radius: 26,
                    backgroundColor: isMicMuted ? Colors.white : Colors.white24,
                    child: Icon(isMicMuted ? Icons.mic_off : Icons.mic, color: isMicMuted ? Colors.black : Colors.white, size: 22),
                  ),
                ),
                if (widget.callType == 'Video')
                  GestureDetector(
                    onTap: () => setState(() => isCameraOff = !isCameraOff),
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: isCameraOff ? Colors.white : Colors.white24,
                      child: Icon(isCameraOff ? Icons.videocam_off : Icons.videocam, color: isCameraOff ? Colors.black : Colors.white, size: 22),
                    ),
                  ),
                GestureDetector(
                  onTap: () => setState(() => isSpeakerOn = !isSpeakerOn),
                  child: CircleAvatar(
                    radius: 26,
                    backgroundColor: isSpeakerOn ? Colors.pinkAccent : Colors.white24,
                    child: Icon(isSpeakerOn ? Icons.volume_up : Icons.volume_off, color: Colors.white, size: 22),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.redAccent,
                    child: Icon(Icons.call_end, color: Colors.white, size: 26),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

