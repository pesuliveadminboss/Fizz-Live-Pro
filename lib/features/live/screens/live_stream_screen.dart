import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:fizz_live_pro/features/live/controllers/live_controller.dart';

class LiveStreamScreen extends StatelessWidget {
  const LiveStreamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LiveController());
    final int localViewID = 0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Obx(() {
              if (controller.isJoined.value) {
                return ZegoTexture(viewID: localViewID);
              }
              return const Text(
                'Ready to Go Live',
                style: TextStyle(color: Colors.white54, fontSize: 18),
              );
            }),
          ),
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      controller.stopLive();
                      Navigator.pop(context);
                    },
                  ),
                ),
                Obx(() => Chip(
                      backgroundColor: controller.isJoined.value
                          ? Colors.red.withOpacity(0.8)
                          : Colors.grey.withOpacity(0.8),
                      label: Text(
                        controller.isJoined.value ? 'LIVE' : 'OFFLINE',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(() => FloatingActionButton(
                      heroTag: 'cam',
                      backgroundColor: Colors.grey[850],
                      onPressed: () {
                        controller.isCameraOn.value =
                            !controller.isCameraOn.value;
                        ZegoExpressEngine.instance.enableCamera(
                            controller.isCameraOn.value);
                      },
                      child: Icon(
                        controller.isCameraOn.value
                            .tagIcon(Icons.videocam, Icons.videocam_off),
                        color: Colors.white,
                      ),
                    )),
                Obx(() => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.isJoined.value
                            ? Colors.red
                            : Colors.pinkAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: () {
                        if (controller.isJoined.value) {
                          controller.stopLive();
                        } else {
                          ZegoExpressEngine.instance
                              .startPreview(canvas: ZegoCanvas(localViewID));
                          controller.startLive();
                        }
                      },
                      child: Text(
                        controller.isJoined.value ? 'End Live' : 'Start Live',
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Obx(() => FloatingActionButton(
                      heroTag: 'mic',
                      backgroundColor: Colors.grey[850],
                      onPressed: () {
                        controller.isMicOn.value = !controller.isMicOn.value;
                        ZegoExpressEngine.instance
                            .muteMicrophone(!controller.isMicOn.value);
                      },
                      child: Icon(
                        controller.isMicOn.value
                            .tagIcon(Icons.mic, Icons.mic_off),
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension BoolIconExt on bool {
  IconData tagIcon(IconData t, IconData f) => this ? t : f;
}
