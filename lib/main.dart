import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'features/auth/screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FizzLiveApp());
}

class FizzLiveApp extends StatelessWidget {
  const FizzLiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fizz Live Pro',
      theme: ThemeData.dark(),
      home: const LoginScreen(),
    );
  }
}
