import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import '../block6_party_room/gift_bottom_sheet.dart';

class ZegoVideoCallService {
  static bool isVideoEnabled = true;
  static bool isFrontCamera = true;
  static bool _isEngineInitialized = false;

  // Initialize Zego Engine properly to prevent infinite loading
  static Future<void> initZegoEngine() async {
    if (_isEngineInitialized) return;
    
    // Replace with your actual Zego AppID and AppSign if required, or use test app ID
    const uint32_t appID = 123456789; // Dummy/Test AppID for testing flow
    const String appSign = "abcdefghijklmnopqrstuvwxyz1234567890";

    try {
      await ZegoExpressEngine.createEngineWithProfile(
        ZegoEngineProfile(
          appID,
          ZegoScenario.StandardVideoCall,
          appSign: appSign,
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

  // 👉 Request Permissions & Launch Real-Time Video Call Screen with Zego Engine Init
  static Future<void> startRealTimeVideoCall(BuildContext context, {required String receiverName}) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    bool cameraGranted = statuses[Permission.camera]?.isGranted ?? false;
    bool micGranted = statuses[Permission.microphone]?.isGranted ?? false;

    if (cameraGranted && micGranted) {
      // Initialize Zego Engine before launching call screen
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
      // Create Platform View for Zego Camera Preview
      
