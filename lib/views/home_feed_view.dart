import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fizz_live_pro/core/fizz_core_controller.dart';
import 'package:fizz_live_pro/views/live_room_view.dart';

class HomeFeedView extends StatelessWidget {
  const HomeFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final FizzCoreController core = Get.find<FizzCoreController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text('Fizz Live - Discover', style: TextStyle(color: Colors.white)),
        actions: [
          Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Center(
              child: CircleAvatar(
                radius: 6,
                backgroundColor: core.connectionState.value == ConnectionStateEnum.connected
                    ? Colors.green
                    : Colors.purple.withOpacity(0.4),
              ),
            ),
          )),
          IconButton(
            icon: const Icon(Icons.live_tv, color: Colors.pinkAccent),
            onPressed: () {
              Get.to(() => const LiveRoomView());
            },
          ),
        ],
      ),
      body: Center(
        child: Obx(() => Text(
          'Connection Status: ${core.connectionState.value.name.toUpperCase()}\nLive streams feed will appear here',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70),
        )),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pinkAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Go Live', style: TextStyle(color: Colors.white)),
        onPressed: () {
          Get.to(() => const LiveRoomView());
        },
      ),
    );
  }
}
