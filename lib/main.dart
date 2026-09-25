import 'package:flutter/material.dart';
import 'block1_auth_onboarding/login_auth_screen.dart';
import 'block1_auth_onboarding/profile_setup_screen.dart';
import 'block1_auth_onboarding/daily_rewards_dialog.dart';
import 'block1_auth_onboarding/authorization_settings_dialog.dart';
import 'block1_auth_onboarding/call_reminder_dialog.dart';
import 'block2_navigation_shell/main_shell_navigation.dart';

void main() {
  runApp(const FizzLiveProApp());
}

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
        '/': (context) => const LoginAuthScreen(),
        '/profile_setup': (context) => const ProfileSetupScreen(),
        '/popups': (context) => const PopupsHomeWrapper(),
        '/main_shell': (context) => const MainShellNavigation(),
      },
    );
  }
}

// Temporary wrapper to show entry popups right after profile setup
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
      // Show Daily Rewards, Authorization Settings, and Call Reminder dialogs sequentially
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

