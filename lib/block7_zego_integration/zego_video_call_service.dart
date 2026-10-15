import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../block6_party_room/gift_bottom_sheet.dart';

class ZegoVideoCallService {
  static bool isVideoEnabled = true;
  static bool isFrontCamera = true;

  // Initialize Live Video Broadcast
  static Future<void> startVideoBroadcast(String streamID) async {
    debugPrint("Starting Zego Video Broadcast for Stream: $streamID[span_0](start_span)[span_0](end_span)");
  }

  // Toggle Camera Front / Back
  static void switchCamera() {
    isFrontCamera = !isFrontCamera;
    debugPrint("Zego Camera Switched. Front Camera: $isFrontCamera[span_1](start_span)[span_1](end_span)");
  }

  // Toggle Video On / Off
  static void toggleVideo(bool enable) {
    isVideoEnabled = enable;
    debugPrint("Zego Video Enabled: $isVideoEnabled[span_2](start_span)[span_2](end_span)");
  }

  // 👉 Request All Permissions (Camera, Mic, Contacts, Location) then launch Real-Time Video Call
  static Future<void> startRealTimeVideoCall(BuildContext context, {required String receiverName}) async {
    // Request permissions for Camera, Microphone, Contacts, and Location
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.contacts,
      Permission.location,
    ].request();

    bool allGranted = statuses[Permission.camera]!.isGranted &&
        statuses[Permission.microphone]!.isGranted;

    if (allGranted) {
      // If permissions granted, open Real-Time Video Call Screen
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RealTimeVideoCallScreen(receiverName: receiverName),
          ),
        );
      }
    } else {
      // If permission denied, show alert
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera and Microphone permissions are required for Video Call!'),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}

// --- FULL FEATURED REAL-TIME VIDEO CALL SCREEN ---
class RealTimeVideoCallScreen extends StatefulWidget {
  final String receiverName;

  const RealTimeVideoCallScreen({super.key, required this.receiverName});

  @override
  State<RealTimeVideoCallScreen> createState() => _RealTimeVideoCallScreenState();
}

class _RealTimeVideoCallScreenState extends State<RealTimeVideoCallScreen> {
  bool isMuted = false;
  bool isVideoOff = false;
  bool isBeautyModeOn = true;
  bool isFront = true;
  String? activeGiftEffect;

  void _showGiftSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GiftBottomSheet(
          onSendGift: (giftName, quantity) {
            setState(() {
              activeGiftEffect = '$giftName x$quantity';
            });
            Future.delayed(const Duration(milliseconds: 2500), () {
              if (mounted) {
                setState(() {
                  activeGiftEffect = null;
                });
              }
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Video View
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF2C1E4A), Color(0xFF0F0817)],
                ),
              ),
              child: Center(
                child: isVideoOff
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(radius: 50, backgroundColor: Colors.white24, child: Icon(Icons.person, size: 50, color: Colors.white)),
                          SizedBox(height: 12),
                          Text('Camera Off (Audio Mode)', style: TextStyle(color: Colors.white60, fontSize: 14)),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.videocam, size: 100, color: Colors.cyanAccent),
                          const SizedBox(height: 10),
                          Text('Connected with ${widget.receiverName}', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          if (isBeautyModeOn)
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: Colors.pinkAccent.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                              child: const Text('✨ Beauty Mode Active', style: TextStyle(color: Colors.pinkAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                        ],
                      ),
              ),
            ),
          ),

          // Top Header Info
          Positioned(
            top: 45,
            left: 16,
            right: 16,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.purple.withOpacity(0.5),
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.receiverName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    const Text('Live Connection • HD', style: TextStyle(color: Colors.cyanAccent, fontSize: 11)),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(isBeautyModeOn ? Icons.face_retouching_natural : Icons.face, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      isBeautyModeOn = !isBeautyModeOn;
                    });
                  },
                ),
              ],
            ),
          ),

          // Center Cinematic Gift Animation Overlay
          if (activeGiftEffect != null)
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.amberAccent, width: 2.5),
                  boxShadow: [BoxShadow(color: Colors.amberAccent.withOpacity(0.8), blurRadius: 30, spreadRadius: 10)],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.card_giftcard, color: Colors.amberAccent, size: 40),
                    const SizedBox(width: 14),
                    Text(
                      activeGiftEffect!,
                      style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, decoration: TextDecoration.none),
                    ),
                  ],
                ),
              ),
            ),

          // Bottom Controls Toolbar
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: 'mute_btn',
                  backgroundColor: isMuted ? Colors.redAccent : Colors.white24,
                  onPressed: () {
                    setState(() {
                      isMuted = !isMuted;
                    });
                  },
                  child: Icon(isMuted ? Icons.mic_off : Icons.mic, color: Colors.white),
                ),
                FloatingActionButton(
                  heroTag: 'switch_cam',
                  backgroundColor: Colors.white24,
                  onPressed: () {
                    setState(() {
                      isFront = !isFront;
                    });
                    ZegoVideoCallService.switchCamera();
                  },
                  child: const Icon(Icons.cameraswitch, color: Colors.white),
                ),
                FloatingActionButton(
                  heroTag: 'video_off',
                  backgroundColor: isVideoOff ? Colors.redAccent : Colors.white24,
                  onPressed: () {
                    setState(() {
                      isVideoOff = !isVideoOff;
                    });
                    ZegoVideoCallService.toggleVideo(!isVideoOff);
                  },
                  child: Icon(isVideoOff ? Icons.videocam_off : Icons.videocam, color: Colors.white),
                ),
                FloatingActionButton(
                  heroTag: 'gift_btn',
                  backgroundColor: Colors.pinkAccent,
                  onPressed: () => _showGiftSheet(context),
                  child: const Icon(Icons.card_giftcard, color: Colors.white),
                ),
                FloatingActionButton(
                  heroTag: 'cut_call',
                  backgroundColor: Colors.red,
                  onPressed: () {
                    Navigator.pop(context);
                  },
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
