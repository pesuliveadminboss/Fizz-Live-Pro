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

// --- BLOCK 4 IMPORTS (Private Chat, Emojis, Voice Recorder, Gallery Picker & Audio Player) ---
import 'block4_private_chat/private_chat_screen.dart';
import 'block4_private_chat/recharge_gems_dialog.dart';
import 'block4_private_chat/voice_recorder_helper.dart';
import 'block4_private_chat/image_picker_helper.dart';
import 'block4_private_chat/audio_player_helper.dart';

// --- BLOCK 5 IMPORTS (Modular Files for Live Streaming & Monetization) ---
import 'block5_live_streaming/live_streamer_model.dart';
import 'block5_live_streaming/live_category_filter_bar.dart';
import 'block5_live_streaming/live_ads_integration_helper.dart';
import 'block5_live_streaming/live_streamer_grid_card.dart';
import 'block5_live_streaming/live_tab_screen.dart';
import 'block5_live_streaming/live_room_header.dart';
import 'block5_live_streaming/streamer_profile_popup.dart';
import 'block5_live_streaming/live_room_bottom_toolbar.dart';
import 'block5_live_streaming/live_tools_and_gifts_helper.dart';
import 'block5_live_streaming/live_room_screen.dart';
import 'block5_live_streaming/streamer_follow_manager.dart';
import 'block5_live_streaming/live_streamer_overlay_manager.dart';

// --- BLOCK 6 IMPORTS (Party Room Module - All 15 Files) ---
import 'block6_party_room/party_room_model.dart';
import 'block6_party_room/party_room_list_screen.dart';
import 'block6_party_room/party_room_hub.dart';
import 'block6_party_room/party_room_detail_screen.dart';
import 'block6_party_room/party_room_screen.dart';
import 'block6_party_room/party_room_capsule_header.dart';
import 'block6_party_room/party_room_creator_screen.dart';
import 'block6_party_room/party_room_overlay_manager.dart';
import 'block6_party_room/party_gift_animation_helper.dart';
import 'block6_party_room/party_room_navigation_bridge.dart';
import 'block6_party_room/party_raise_hand_helper.dart';
import 'block6_party_room/party_ads_integration_helper.dart';
import 'block6_party_room/party_room_audio_manager.dart';
import 'block6_party_room/party_room_members_helper.dart';
import 'block6_party_room/party_room_theme_helper.dart';

// --- BLOCK 7 IMPORTS (ZegoCloud Integration & Audio/Video Services) ---
import 'block7_zego_integration/zego_party_room_service.dart';
import 'block7_zego_integration/zego_voice_speaking_effect_helper.dart';
import 'block7_zego_integration/zego_video_call_service.dart';
import 'block7_zego_integration/zego_live_tools_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize ZegoCloud Engine with Official Production Credentials
  await ZegoPartyRoomService.initZegoEngine(
    userID: 'user_chandran_007',
    userName: 'Chandran S',
  );

  runApp(const FizzLiveProApp());
}

class FizzLiveProApp extends StatelessWidget {
  const FizzLiveProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fizz Live Pro',
      debugShowCheckedModeBanner: false,
      theme: DribbbleTheme.themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginAuthScreenProfileBridge(),
        '/popups': (context) => const PopupsHomeWrapper(),
        '/main_shell': (context) => const MainShellNavigation(),
        '/private_chat': (context) => const PrivateChatScreen(),
        '/live_tab': (context) => const LiveTabScreen(),
        '/party_room_hub': (context) => const PartyRoomHub(),
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

// --- POPUPS WRAPPER (Optimized: Auto-dismiss within 2 seconds) ---
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
        barrierDismissible: true,
        builder: (_) {
          Future.delayed(const Duration(seconds: 2), () {
            if (Navigator.canPop(context)) {
              Navigator.of(context, rootNavigator: true).pop();
            }
          });
          return const DailyRewardsDialog();
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MainShellNavigation();
  }
}
