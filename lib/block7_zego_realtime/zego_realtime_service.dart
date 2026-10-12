import 'package:flutter/material.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

class ZegoRealtimeService {
  // ZegoCloud Credentials for Fizz Live Pro
  static const int appID = 821340860;
  static const String appSign = "9d54b18680b7bd20f42dc3b7cdd1680e63b420a1e64aa0168cd7b167d1bb72dd";

  // 1. Initialize Zego Express Engine
  static Future<void> initZegoEngine() async {
    try {
      ZegoEngineProfile profile = ZegoEngineProfile(
        appID,
        ZegoScenario.Default,
      );
      await ZegoExpressEngine.createEngineWithProfile(profile);
      debugPrint("Zego Express Engine Initialized Successfully");
    } catch (e) {
      debugPrint("Zego Initialization Error: $e");
    }
  }

  // 2. Login to Live or Party Room
  static Future<bool> loginRoom(String roomID, String userID, String userName) async {
    try {
      ZegoUser user = ZegoUser(userID, userName);
      ZegoRoomConfig roomConfig = ZegoRoomConfig.defaultConfig();
      
      ZegoRoomLoginResult result = await ZegoExpressEngine.instance.loginRoom(roomID, user, config: roomConfig);
      
      if (result.errorCode == 0) {
        debugPrint("Successfully Logged into Zego Room: $roomID");
        return true;
      } else {
        debugPrint("Failed to Login Room. Error Code: ${result.errorCode}");
        return false;
      }
    } catch (e) {
      debugPrint("Zego Login Exception: $e");
      return false;
    }
  }

  // 3. Logout from the Room
  static Future<void> logoutRoom(String roomID) async {
    try {
      await ZegoExpressEngine.instance.logoutRoom(roomID);
      debugPrint("Logged out from Zego Room: $roomID");
    } catch (e) {
      debugPrint("Zego Logout Error: $e");
    }
  }

  // 4. Start Publishing Stream
  static Future<void> startPublishing(String streamID) async {
    try {
      ZegoExpressEngine.instance.startPreview();
      await ZegoExpressEngine.instance.startPublishingStream(streamID);
      debugPrint("Started Publishing Stream: $streamID");
    } catch (e) {
      debugPrint("Zego Publish Error: $e");
    }
  }

  // 5. Stop Publishing Stream
  static Future<void> stopPublishing() async {
    try {
      await ZegoExpressEngine.instance.stopPublishingStream();
      ZegoExpressEngine.instance.stopPreview();
      debugPrint("Stopped Publishing Stream");
    } catch (e) {
      debugPrint("Zego Stop Publish Error: $e");
    }
  }

  // 6. Party Room Seat Microphone Control
  static void setMicrophoneMuted(bool isMuted) {
    ZegoExpressEngine.instance.muteMicrophone(isMuted);
    debugPrint("Microphone Mute Status: $isMuted");
  }
}
