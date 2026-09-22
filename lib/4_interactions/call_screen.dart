import 'dart:async';
import 'package:flutter/material.dart';
import '../wallet/video_call_gems_sheet.dart';

class CallScreen extends StatefulWidget {
  final String callType; // 'Video' or 'Voice'
  final String peerName;
  final int initialWalletGems;
  const CallScreen({super.key, this.callType = 'Video', this.peerName = 'User_90001001', this.initialWalletGems = 3500});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool isMicMuted = false;
  bool isCameraOff = false;
  bool isSpeakerOn = true;
  int secondsElapsed = 0;
  late int remainingGems;
  Timer? _callTimer;

  @override
  void initState() {
    super.initState();
    isCameraOff = widget.callType == 'Voice';
    remainingGems = widget.initialWalletGems;

    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          secondsElapsed++;
          // 1800 gems per min (~30 gems/sec burn)
          if (secondsElapsed % 2 == 0 && remainingGems > 0) {
            remainingGems = (remainingGems - 30).clamp(0, 999999);
          }
        });
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

  bool get isLowGemsAlert => remainingGems < 2000;

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: isCameraOff
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(radius: 50, backgroundColor: Colors.pinkAccent, child: Icon(Icons.person, size: 60, color: Colors.white)),
                        SizedBox(height: 12),
                        Text('Voice / Camera Off Call', style: TextStyle(color: Color(0xBFFFFFFF), fontSize: 14)),
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
                          Text(
                            _formatDuration(secondsElapsed),
                            style: TextStyle(
                              color: isLowGemsAlert ? Colors.redAccent : Colors.amber,
                              fontWeight: isLowGemsAlert ? FontWeight.bold : FontWeight.normal,
                              fontSize: isLowGemsAlert ? 13 : 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => showVideoCallGemsSheet(context, remainingGems),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isLowGemsAlert ? Colors.red.withOpacity(0.3) : Colors.black54,
                        border: isLowGemsAlert ? Border.all(color: Colors.redAccent) : null,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isLowGemsAlert ? '⚠️ Low Gems (💎 $remainingGems)' : '💎 1800/min | Bal: $remainingGems',
                        style: TextStyle(color: isLowGemsAlert ? Colors.redAccent : Colors.amber, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
