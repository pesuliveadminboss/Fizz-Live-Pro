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
      theme: ThemeData(brightness: Brightness.dark, scaffoldBackgroundColor: const Color(0xFF0F0F1A)),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginAuthScreen(),
        '/profile_setup': (context) => const ProfileSetupScreen(),
        '/popups': (context) => const PopupsWrapper(),
        '/main_shell': (context) => const MainShellNavigation(),
      },
    );
  }
}

class PopupsWrapper extends StatefulWidget {
  const PopupsWrapper({super.key});

  @override
  State<PopupsWrapper> createState() => _PopupsWrapperState();
}

class _PopupsWrapperState extends State<PopupsWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(context: context, builder: (_) => const DailyRewardsDialog()).then((_) {
        showDialog(context: context, builder: (_) => const AuthorizationSettingsDialog()).then((_) {
          showDialog(context: context, builder: (_) => const CallReminderDialog());
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) => const MainShellNavigation();
}
