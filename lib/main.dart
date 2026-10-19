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

// --- BLOCK 5 IMPORTS (Live Streaming & Smart Hub/Overlay/Scroll Files) ---
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
import 'block5_live_streaming/streamer_session_model.dart';
import 'block5_live_streaming/streamer_blur_overlay.dart';
import 'block5_live_streaming/live_queue_scroll_manager.dart';
import 'block5_live_streaming/smart_live_streaming_hub.dart';
import 'block5_live_streaming/gift_bottom_sheet.dart';
import 'block5_live_streaming/live_viewers_list_helper.dart';

// --- BLOCK 6 IMPORTS (Party Room Module - All Files Included) ---
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
import 'block6_party_room/party_room_follow_manager.dart';
import 'block6_party_room/party_room_seat_profile_sheet.dart';
import 'block6_party_room/room_viewers_screen.dart';
import 'block6_party_room/party_room_minimize_helper.dart';

// --- BLOCK 7 IMPORTS (ZegoCloud Integration & Audio/Video Services) ---
import 'block7_zego_integration/zego_party_room_service.dart';
import 'block7_zego_integration/zego_voice_speaking_effect_helper.dart';
import 'block7_zego_integration/zego_video_call_service.dart';
import 'block7_zego_integration/zego_live_tools_service.dart';

// --- BLOCK 8 IMPORTS (Random Match Tab Module) ---
import 'block8_match_tab/match_call_helper.dart';
import 'block8_match_tab/match_profile_widget.dart';
import 'block8_match_tab/match_screen.dart';

// --- BLOCK 9 IMPORTS (Follow Tab & Smart Sync Hub Module) ---
import 'block9_follow_tab/follow_tab_model.dart';
import 'block9_follow_tab/follow_manager_service.dart';
import 'block9_follow_tab/follow_girls_grid_view.dart';
import 'block9_follow_tab/follow_room_grid_view.dart';
import 'block9_follow_tab/follow_tab_container_screen.dart';
import 'block9_follow_tab/follow_sync_service.dart';
import 'block9_follow_tab/smart_follow_grid_view.dart';
import 'block9_follow_tab/follow_container_hub_screen.dart';

// --- BLOCK 10 IMPORTS (Monetization, VIP Tiers, Recharge Plans & Ads) ---
import 'block10_monetization/monetization_config.dart';
import 'block10_monetization/vip_tier_manager.dart';
import 'block10_monetization/recharge_bottom_sheet_ui.dart';
import 'block10_monetization/revenue_commission_calculator.dart';
import 'block10_monetization/admob_monetization_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ZegoPartyRoomService.initZegoEngine(
    userID: 'user_chandran_007',
    userName: 'Chandran S',
  );

  // Initialize Monetization & Ad SDK
  AdmobMonetizationHelper.initializeAdSdk();

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
        '/match_tab': (context) => const MatchScreen(),
        '/smart_live_hub': (context) => const SmartLiveStreamingHub(),
        '/follow_hub': (context) => const FollowContainerHubScreen(),
        
        // 👉 All required parameters fully populated without const errors:
        '/live_room_screen': (context) => const LiveRoomScreen(
          streamer: LiveStreamer(
            id: 'live_001',
            name: 'Live Streamer',
            viewers: '150',
            category: 'General',
            profileImageUrl: '',
            bio: 'Welcome to my live room!',
          ),
        ),
        '/party_room_screen': (context) => PartyRoomScreen(
          room: PartyRoomModel(
            roomID: 'party_001',
            roomName: 'Party Room',
            hostName: 'Host Name',
            onlineCount: 10,
            theme: 'default',
          ),
        ),
        '/streamer_profile_screen': (context) => StreamerProfileScreen(
          streamer: StreamerProfileModel(
            id: 'user_001',
            name: 'User Profile',
            country: 'India',
            flag: '🇮🇳',
            age: 24,
            status: 'Active',
            intro: 'Welcome to my profile!',
            language: 'English',
          ),
        ),
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
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
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

// --- POPUPS WRAPPER ---
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
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (dialogContext) {
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted && Navigator.canPop(dialogContext)) {
                Navigator.of(dialogContext).pop();
              }
            });
            return const DailyRewardsDialog();
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MainShellNavigation();
  }
}
