import 'package:flutter/material.dart';
import 'models_and_state.dart';
import 'package:zego_express_engine/zego_express_engine.dart'; // Zego SDK package

// ZegoCloud Test Credentials (Neenga unga zego dashboard la irunthu mathikalm)
const int zegoAppID = 123456789; // Replace with your Zego AppID
const String zegoAppSign = "your_zego_app_sign_here_abcdef123456"; // Replace with your AppSign

class ZegoVideoCallManager {
  static bool isEngineInitialized = false;

  static Future<void> initZegoEngine() async {
    if (!isEngineInitialized) {
      await ZegoExpressEngine.createEngineWithProfile(
        ZegoEngineProfile(
          zegoAppID,
          ZegoScenario.StandardVideoCall,
          appSign: zegoAppSign,
        ),
      );
      isEngineInitialized = true;
    }
  }

  static Future<void> startCallSession(String userId, String userName) async {
    await initZegoEngine();
    // Login room for 1-to-1 call
    ZegoUser user = ZegoUser(userId, userName);
    ZegoRoomConfig roomConfig = ZegoRoomConfig.defaultConfig();
    await ZegoExpressEngine.instance.loginRoom("room_${userId}", user, config: roomConfig);
    
    // Start preview & publishing video
    ZegoExpressEngine.instance.startPreview();
    ZegoExpressEngine.instance.startPublishingStream("stream_${userId}");
  }

  static Future<void> endCallSession() async {
    if (isEngineInitialized) {
      await ZegoExpressEngine.instance.stopPublishingStream();
      await ZegoExpressEngine.instance.stopPreview();
      await ZegoExpressEngine.instance.logoutRoom();
    }
  }
}

// Updated 1-to-1 Video Call Dialog with Zego SDK triggers
void showVideoCall1to1Dialog(BuildContext context, StreamerItem streamer) {
  // Trigger Zego Session on dialog open
  ZegoVideoCallManager.startCallSession('user_101', 'Fizz User');

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.black,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Zego Video Canvas View Container (Local/Remote preview placeholder or active view)
          Container(
            color: Colors.black87,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 50, backgroundColor: streamer.color, child: Text(streamer.name[0], style: const TextStyle(fontSize: 40, color: Colors.white))),
                  const SizedBox(height: 16),
                  Text('Zego Live Call with ${streamer.name}', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('${streamer.flag} ${streamer.country} • Age ${streamer.age}', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 24),
                  const Text('🟢 ZegoCloud Secure Stream Connected', style: TextStyle(color: Colors.greenAccent, fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 40, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: () {
                    ZegoVideoCallManager.endCallSession();
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Zego video call ended')));
                  },
                  child: const Icon(Icons.call_end, color: Colors.white),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40, right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                ZegoVideoCallManager.endCallSession();
                Navigator.pop(ctx);
              },
            ),
          ),
        ],
      ),
    ),
  );
}

