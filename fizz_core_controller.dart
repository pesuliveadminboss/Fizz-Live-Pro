import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import '../config/zego_config.dart';

enum ConnectionStateEnum { disconnected, connecting, connected, error }

class FizzCoreController extends GetxController {
  var engineState = ConnectionStateEnum.disconnected.obs;
  var isInitialized = false.obs;
  var isHost = false.obs;
  var activeRoomID = ''.obs;
  
  final String userID = 'fizz_user_${DateTime.now().millisecondsSinceEpoch % 100000}';
  final String userName = 'Macha_${DateTime.now().millisecondsSinceEpoch % 1000}';

  var liveMessages = <Map<String, String>>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    bootCoreEngine();
  }

  Future<bool> bootCoreEngine() async {
    try {
      if (isInitialized.value) return true;
      
      log("⚡ [HEART]: Initializing Zego Express Engine...");
      engineState.value = ConnectionStateEnum.connecting;

      if (ZegoConfig.appId == 0 || ZegoConfig.appSign.isEmpty) {
        throw Exception("Invalid ZegoConfig: AppID or AppSign missing!");
      }

      await ZegoExpressEngine.createEngineWithProfile(
        ZegoEngineProfile(
          ZegoConfig.appId,
          ZegoScenario.LiveStreaming,
          appSign: ZegoConfig.appSign,
        ),
      );

      setupEngineEventCallbacks();

      isInitialized.value = true;
      engineState.value = ConnectionStateEnum.disconnected;
      log("✅ [HEART]: Zego Engine Booted Successfully.");
      return true;
    } catch (e) {
      log("❌ [HEART Boot Error]: $e");
      errorMessage.value = e.toString();
      engineState.value = ConnectionStateEnum.error;
      return false;
    }
  }

  void setupEngineEventCallbacks() {
    ZegoExpressEngine.onRoomStateUpdate = (roomID, state, errorCode, extendedData) {
      log("Room State Update: $roomID, state: ${state.name}, code: $errorCode");
      if (errorCode != 0) {
        errorMessage.value = "Room error code: $errorCode";
      }
    };
  }

  Future<bool> checkAndRequestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    bool cameraGranted = statuses[Permission.camera]?.isGranted ?? false;
    bool micGranted = statuses[Permission.microphone]?.isGranted ?? false;

    if (!cameraGranted || !micGranted) {
      errorMessage.value = "Camera and Mic permissions required.";
      Get.snackbar("Permission Required", errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    return true;
  }

  Future<void> startCoreBroadcast(String roomID) async {
    if (!isInitialized.value) await bootCoreEngine();
    if (!await checkAndRequestPermissions()) return;

    try {
      activeRoomID.value = roomID;
      isHost.value = true;
      engineState.value = ConnectionStateEnum.connecting;

      ZegoUser user = ZegoUser(userID, userName);
      ZegoRoomConfig roomConfig = ZegoRoomConfig.defaultConfig();
      
      var loginResult = await ZegoExpressEngine.instance.loginRoom(roomID, user, config: roomConfig);
      if (loginResult.errorCode != 0) {
        throw Exception("Login room failed: ${loginResult.errorCode}");
      }

      await ZegoExpressEngine.instance.startPreview();
      String streamID = "stream_${roomID}_$userID";
      ZegoPublisherConfig pubConfig = ZegoPublisherConfig();
      await ZegoExpressEngine.instance.startPublishingStream(streamID, config: pubConfig);

      engineState.value = ConnectionStateEnum.connected;
      appendCoreLog("System", "Host broadcast started in room: $roomID");
    } catch (e) {
      log("❌ Start Broadcast Error: $e");
      engineState.value = ConnectionStateEnum.error;
      errorMessage.value = e.toString();
    }
  }

  Future<void> startCorePlayback(String roomID, String targetStreamID) async {
    if (!isInitialized.value) await bootCoreEngine();

    try {
      activeRoomID.value = roomID;
      isHost.value = false;
      engineState.value = ConnectionStateEnum.connecting;

      ZegoUser user = ZegoUser(userID, userName);
      ZegoRoomConfig roomConfig = ZegoRoomConfig.defaultConfig();
      
      var loginResult = await ZegoExpressEngine.instance.loginRoom(roomID, user, config: roomConfig);
      if (loginResult.errorCode != 0) {
        throw Exception("Room login failed: ${loginResult.errorCode}");
      }

      await ZegoExpressEngine.instance.startPlayingStream(targetStreamID);
      engineState.value = ConnectionStateEnum.connected;
      appendCoreLog("System", "Joined room playback: $roomID");
    } catch (e) {
      log("❌ Playback Error: $e");
      engineState.value = ConnectionStateEnum.error;
      errorMessage.value = e.toString();
    }
  }

  void appendCoreLog(String sender, String text) {
    liveMessages.add({"sender": sender, "text": text, "time": DateTime.now().toIso8601String()});
  }

  Future<void> destroySession() async {
    try {
      if (isHost.value) {
        await ZegoExpressEngine.instance.stopPreview();
        await ZegoExpressEngine.instance.stopPublishingStream();
      } else if (activeRoomID.isNotEmpty) {
        await ZegoExpressEngine.instance.stopPlayingStream("stream_${activeRoomID.value}");
      }
      if (activeRoomID.isNotEmpty) {
        await ZegoExpressEngine.instance.logoutRoom(activeRoomID.value);
      }
    } catch (e) {
      log("Teardown warning: $e");
    } finally {
      activeRoomID.value = '';
      engineState.value = ConnectionStateEnum.disconnected;
    }
  }

  @override
  void onClose() {
    destroySession();
    ZegoExpressEngine.destroyEngine();
    super.onClose();
  }
}
