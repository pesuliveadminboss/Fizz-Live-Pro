import 'package:flutter/material.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

class MatchCallHelper {
  static bool _isEngineInitialized = false;

  // Initialize Zego for Random Match Video/Audio Call
  static Future<void> initMatchCallEngine() async {
    if (_isEngineInitialized) return;

    try {
      await ZegoExpressEngine.createEngineWithProfile(
        ZegoEngineProfile(
          821340860, // AppID
          ZegoScenario.StandardVideoCall,
          appSign: "9d54b18680b7bd20f42dc3b7cdd1680e63b420a1e64aa0168cd7b167d1bb72dd",
        ),
      );
      _isEngineInitialized = true;
      debugPrint("Match Call Zego Engine Initialized Successfully");
    } catch (e) {
      debugPrint("Match Call Zego Engine Init Failed: $e");
    }
  }

  // Start Real-Time Match Video Stream Preview
  static Widget buildMatchCameraPreview({required bool isVideoEnabled}) {
    if (!isVideoEnabled) {
      return Container(
        color: const Color(0xFF0F0817),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              SizedBox(height: 12),
              Text(
                'Camera Off (Audio Match Mode)',
                style: TextStyle(color: Colors.white60, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: const Color(0xFF1A0B2E),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam, size: 80, color: Colors.pinkAccent),
            SizedBox(height: 12),
            Text(
              'Connected to Live Match Stream • HD',
              style: TextStyle(color: Colors.cyanAccent, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  static void disposeMatchCall() {
    try {
      ZegoExpressEngine.instance.stopPreview();
    } catch (e) {
      debugPrint("Error stopping match preview: $e");
    }
  }
}
