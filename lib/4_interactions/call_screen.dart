import 'package:flutter/material.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, title: const Text('Video Call')),
      body: const Center(child: Text('Video Call Connected', style: TextStyle(color: Colors.white))),
    );
  }
}

