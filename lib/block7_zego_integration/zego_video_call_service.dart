import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import '../block6_party_room/gift_bottom_sheet.dart';

class ZegoVideoCallService {
  static bool isVideoEnabled = true;
  static bool isFrontCamera = true;
  static bool _isEngineInitialized = false;

  // Initialize Zego Engine properly
  static Future<void> initZegoEngine() async {
    if (_isEngineInitialized) return;

    try {
      // Using standard integer appID and appSign string
      await ZegoExpressEngine.createEngineWithProfile(
        const ZegoEngineProfile(
          123456789, // Replace with your valid Zego AppID integer if needed
          ZegoScenario.StandardVideoCall,
          appSign: "abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz12",
        ),
      );
      _isEngineInitialized = true;
      debugPrint("Zego Engine Initialized Successfully");
    } catch (e) {
      debugPrint("Zego Engine Initialization Failed: $e");
    }
  }

  // Toggle Camera Front / Back
  static void switchCamera() {
    isFrontCamera = !isFrontCamera;
    ZegoExpressEngine.instance.useFrontCamera(isFrontCamera);
    debugPrint("Zego Camera Switched. Front Camera: $isFrontCamera");
  }

  // Toggle Video On / Off
  static void toggleVideo(bool enable) {
    isVideoEnabled = enable;
    ZegoExpressEngine.instance.enableCamera(enable);
    debugPrint("Zego Video Enabled: $isVideoEnabled");
  }

  // Request Permissions & Launch Real-Time Video Call Screen
  static Future<void> startRealTimeVideoCall(BuildContext context, {required String receiverName}) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    bool cameraGranted = statuses[Permission.camera]?.isGranted ?? false;
    bool micGranted = statuses[Permission.microphone]?.isGranted ?? false;

    if (cameraGranted && micGranted) {
      await initZegoEngine();

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RealTimeVideoCallScreen(receiverName: receiverName),
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera and Microphone permissions are required to start Video Call!'),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }
}

// --- REAL-TIME VIDEO CALL SCREEN WITH ZEGO CAMERA VIEW ---
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

  int? _viewID;
  bool _isCanvasReady = false;

  @override
  void initState() {
    super.initState();
    _initZegoPreview();
  }

  Future<void> _initZegoPreview() async {
    try {
      await ZegoExpressEngine.instance.createCanvasView((viewID) {
        if (mounted) {
          setState(() {
            _viewID = viewID;
            _isCanvasReady = true;
          });
        }
        ZegoExpressEngine.instance.startPreview(
          canvas: ZegoCanvas(viewID, viewMode: ZegoViewMode.AspectFill),
        );
      });
    } catch (e) {
      debugPrint("Error starting Zego preview: $e");
    }
  }

  void _showGiftSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GiftBottomSheet(
          onSendGift: (giftName, quantity) {
            if (mounted) {
              setState(() {
                activeGiftEffect = '$giftName x$quantity';
              });
            }
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
  void dispose() {
    ZegoExpressEngine.instance.stopPreview();
    if (_viewID != null) {
      ZegoExpressEngine.instance.destroyCanvasView(_viewID!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: isVideoOff
                ? Container(
                    color: const Color(0xFF0F0817),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(radius: 50, backgroundColor: Colors.white24, child: Icon(Icons.person, size: 50, color: Colors.white)),
                          SizedBox(height: 12),
                          Text('Camera Off (Audio Mode)', style: TextStyle(color: Colors.white60, fontSize: 14)),
                        ],
                      ),
                    ),
                  )
                : (_isCanvasReady && _viewID != null
                    ? Texture(textureId: _viewID!)
                    : Container(
                        color: Colors.black,
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.pinkAccent),
                        ),
                      )),
          ),
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
                    const Text('Live Zego Call • HD', style: TextStyle(color: Colors.cyanAccent, fontSize: 11)),
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
                    ZegoExpressEngine.instance.muteMicrophone(isMuted);
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
                    ZegoExpressEngine.instance.stopPreview();
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
