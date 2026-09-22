import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/fizz_core_controller.dart';
import 'views/splash_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(FizzCoreController(), permanent: true);
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    home: SplashView(),
  ));
}
