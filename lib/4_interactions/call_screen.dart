import 'package:flutter/material.dart';
import 'gift_sheet.dart';

class ZegoVideoCallScreen extends StatefulWidget {
  final String streamerName;
  final String streamerId;
  final int gemCostPerMin;

  const ZegoVideoCallScreen({
    super.key,
    required this.streamerName,
    required this.streamerId,
    this.gemCostPerMin = 40,
  });

  @override
  State<ZegoVideoCallScreen> createState() => _ZegoVideoCallScreenState();
}

class _ZegoVideoCallScreenState extends State<ZegoVideoCallScreen> {
  bool isMicMuted = false;
  bool isCameraOff = false;
  bool isFrontCamera = true;

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: const Color(0xFF1F1A24),
            child: const Center(
              child: Icon(Icons.person, size: 120, color: Colors.white24),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  const CircleAvatar(backgroundColor: Colors.black45, child: Icon(Icons.shield, color: Colors.amber, size: 18)),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.streamerName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('ID: ${widget.streamerId} • 💎 ${widget.gemCostPerMin}/min', style: const TextStyle(color: Colors.amber, fontSize: 11)),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(12)),
                    child: const Text('00:45', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 40, left: 24, right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: 'mic',
                  backgroundColor: isMicMuted ? Colors.red : Colors.white24,
                  onPressed: () => setState(() => isMicMuted = !isMicMuted),
                  child: Icon(isMicMuted ? Icons.mic_off : Icons.mic, color: Colors.white),
                ),
                FloatingActionButton(
                  heroTag: 'cam',
                  backgroundColor: isCameraOff ? Colors.red : Colors.white24,
                  onPressed: () => setState(() => isCameraOff = !isCameraOff),
                  child: Icon(isCameraOff ? Icons.videocam_off : Icons.videocam, color: Colors.white),
                ),
                FloatingActionButton(
                  heroTag: 'flip',
                  backgroundColor: Colors.white24,
                  onPressed: () => setState(() => isFrontCamera = !isFrontCamera),
                  child: const Icon(Icons.flip_camera_ios, color: Colors.white),
                ),
                FloatingActionButton(
                  heroTag: 'gift_call',
                  backgroundColor: Colors.purple,
                  onPressed: () => showGiftSendingSheet(context, 'VideoCallUser'),
                  child: const Icon(Icons.card_giftcard, color: Colors.amber),
                ),
                FloatingActionButton(
                  heroTag: 'end_call',
                  backgroundColor: Colors.red,
                  onPressed: () => Navigator.pop(context),
                  child: const Icon(Icons.call_end, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
