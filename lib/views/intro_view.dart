import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_view.dart';

class IntroView extends StatelessWidget {
  const IntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Fizz Live Pro',
              style: TextStyle(color: Colors.pinkAccent, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Connect, Stream & Play Live', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
              onPressed: () => Get.off(() => const LoginView()),
              child: const Text('Get Started', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
