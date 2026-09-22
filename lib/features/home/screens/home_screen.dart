import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fizz_live_pro/features/live/screens/live_stream_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text('Fizz Live - Discover', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.live_tv, color: Colors.pinkAccent),
            onPressed: () {
              Get.to(() => const LiveStreamScreen());
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Live streams feed will appear here',
          style: TextStyle(color: Colors.white70),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pinkAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Go Live', style: TextStyle(color: Colors.white)),
        onPressed: () {
          Get.to(() => const LiveStreamScreen());
        },
      ),
    );
  }
}
