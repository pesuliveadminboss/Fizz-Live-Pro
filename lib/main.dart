import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fizz_live_pro/core/fizz_core_controller.dart';
import 'package:fizz_live_pro/views/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(FizzCoreController(), permanent: true);
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
      home: const LoginView(),
    );
  }
}
