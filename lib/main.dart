import 'package:flutter/material.dart';
import '2_auth/auth_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Global bindings & async initializations if needed
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AgeGateAndAuthScreen(),
  ));
}

