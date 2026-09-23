import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fizz_live_pro/core/fizz_core_controller.dart';

class LiveRoomView extends StatelessWidget {
  const LiveRoomView({super.key});

  @override
  Widget build(BuildContext context) {
    final FizzCoreController core = Get.find<FizzCoreController>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Obx(() => Text(
              'Live Room View (Status: ${core.connectionState.value.name})',
              style: const TextStyle(color: Colors.white54, fontSize: 18),
            )),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
