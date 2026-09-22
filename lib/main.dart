// lib/main.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding/onboarding_screen.dart';
import '3_discovery/discovery_feed.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isFirstTime = prefs.getBool('is_first_time') ?? true;
  runApp(MyApp(isFirstTime: isFirstTime));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  const MyApp({super.key, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0B1E),
      ),
      home: RootAuthGate(isFirstTime: isFirstTime),
    );
  }
}

class RootAuthGate extends StatefulWidget {
  final bool isFirstTime;
  const RootAuthGate({super.key, required this.isFirstTime});

  @override
  State<RootAuthGate> createState() => _RootAuthGateState();
}

class _RootAuthGateState extends State<RootAuthGate> {
  late bool isFirstTimeUser;

  @override
  void initState() {
    super.initState();
    isFirstTimeUser = widget.isFirstTime;
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_time', false);
    setState(() {
      isFirstTimeUser = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isFirstTimeUser) {
      return OnboardingScreen(onCompleteOnboarding: _completeOnboarding);
    } else {
      return const DiscoveryFeedScreen(); // Fast direct entry!
    }
  }
}
