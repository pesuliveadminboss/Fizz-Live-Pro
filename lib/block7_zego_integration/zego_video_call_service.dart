import 'package:flutter/material.dart';

class ZegoVideoCallService {
  static bool isVideoEnabled = true;
  static bool isFrontCamera = true;

  // Initialize Live Video Broadcast
  static Future<void> startVideoBroadcast(String streamID) async {
    debugPrint("Starting Zego Video Broadcast for Stream: $streamID");
  }

  // Toggle Camera Front / Back
  static void switchCamera() {
    isFrontCamera = !isFrontCamera;
    debugPrint("Zego Camera Switched. Front Camera: $isFrontCamera");
  }

  // Toggle Video On / Off (Audio only mode)
  static void toggleVideo(bool enable) {
    isVideoEnabled = enable;
    debugPrint("Zego Video Enabled: $isVideoEnabled");
  }
}
