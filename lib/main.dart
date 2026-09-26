import 'package:flutter/material.dart';

// --- BLOCK 1 IMPORTS (Auth, Profile Setup & Popups) ---
import 'block1_auth_onboarding/login_auth_screen.dart';
import 'block1_auth_onboarding/profile_setup_screen.dart';
import 'block1_auth_onboarding/daily_rewards_dialog.dart';
import 'block1_auth_onboarding/authorization_settings_dialog.dart';
import 'block1_auth_onboarding/call_reminder_dialog.dart';

// --- BLOCK 2 IMPORTS (Navigation Shell, Hot & Live Tabs, Grid, Search) ---
import 'block2_navigation_shell/main_shell_navigation.dart';
import 'block2_navigation_shell/hot_and_live_container_tab.dart';
import 'block2_navigation_shell/hot_tab_grid_screen.dart';
import 'block2_navigation_shell/streamer_model_data.dart';
import 'block2_navigation_shell/country_search_filter_helper.dart';

// --- BLOCK 3 IMPORTS (Dribbble Theme & Streamer Profile Features) ---
import 'block3_hot_tab/dribbble_theme_extension.dart';
import 'block3_hot_tab/streamer_profile_model.dart';
import 'block3_hot_tab/streamer_profile_screen.dart';
import 'block3_hot_tab/profile_actions_dialogs.dart';
import 'block3_hot_tab/profile_interaction_handler.dart';

// --- BLOCK 4 IMPORTS (Private Chat Area, Emojis & Recharge Gems Modal) ---
import 'block4_private_chat/private_chat_screen.dart';
import 'block4_private_chat/recharge_gems_dialog.dart';

void main() => runApp(const FizzLiveProApp());

class FizzLiveProApp extends StatelessWidget {
  const FizzLiveProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fizz Live Pro',
      debugShowCheckedModeBanner: false,
      // Block 3-ன் உலகளாவிய Dribbble தீம் (Deep Purple & Indigo) ஆப் முழுமைக்கும் அப்ளை ஆகும்
      theme: DribbbleTheme.themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginAuthScreenProfileBridge(),
        '/popups': (context) => const PopupsHomeWrapper(),
        '/main_shell': (context) => const MainShellNavigation(),
        '/private_chat': (context) => const PrivateChatScreen(),
      },
    );
  }
}

// --- SPLASH SCREEN ---
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Fizz Live Pro',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: DribbbleTheme.primaryPurple,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Live Streaming 18+',
              style: TextStyle(
                fontSize: 16,
                color: DribbbleTheme.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- BRIDGE FOR BLOCK 1 LOGIN ---
class LoginAuthScreenProfileBridge extends StatelessWidget {
  const LoginAuthScreenProfileBridge({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginAuthScreen();
  }
}

// --- POPUPS WRAPPER (Daily Rewards, Auth Settings, Call Reminders) ---
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
