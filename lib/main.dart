import 'package:flutter/material.dart';
import 'block1_auth_onboarding/login_auth_screen.dart';
import 'block1_auth_onboarding/profile_setup_screen.dart';
import 'block1_auth_onboarding/daily_rewards_dialog.dart';
import 'block1_auth_onboarding/authorization_settings_dialog.dart';
import 'block1_auth_onboarding/call_reminder_dialog.dart';
import 'block2_navigation_shell/main_shell_navigation.dart';

void main() => runApp(const FizzLiveProApp());

class FizzLiveProApp extends StatelessWidget {
  const FizzLiveProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fizz Live Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F1A),
        primaryColor: const Color(0xFFE94057),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginAuthScreen(),
        '/popups': (context) => const PopupsHomeWrapper(),
        '/main_shell': (context) => const MainShellNavigation(),
      },
    );
  }
}

// 2 Seconds Splash Screen matching "Fizz Live Pro Live Streaming 18+"
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Fizz Live Pro',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFE94057)),
            ),
            SizedBox(height: 8),
            Text(
              'Live Streaming 18+',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class PopupsHomeWrapper extends StatefulWidget {
  const PopupsHomeWrapper({super.key});

  @override
  State<PopupsHomeWrapper> createState() => _PopupsHomeWrapperState();
}

class _PopupsHomeWrapperState extends State<PopupsHomeWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (_) => const DailyRewardsDialog(),
      ).then((_) {
        showDialog(
          context: context,
          builder: (_) => const AuthorizationSettingsDialog(),
        ).then((_) {
          showDialog(
            context: context,
            builder: (_) => const CallReminderDialog(),
          );
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MainShellNavigation();
  }
}
