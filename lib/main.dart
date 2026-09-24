import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'auth_controller.dart';
import 'login_screen.dart';
import 'popups_and_dialogs.dart';
import 'feed_and_tabs.dart';

// Import our 8 New Modular Files
import 'live_stream_model_and_filters.dart';
import 'live_row_grid_widget.dart';
import 'category_filter_cards_widget.dart';
import 'live_room_main_screen.dart';
import 'synced_hearts_and_follow_controller.dart';
import 'pip_floating_window_manager.dart';
import 'live_chat_and_warning_banner.dart';
import 'viewer_list_and_video_call_actions.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => AuthController()),
      ],
      child: const FizzLiveProApp(),
    ),
  );
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
        primaryColor: const Color(0xFFE94057),
        scaffoldBackgroundColor: const Color(0xFF0F0F1A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE94057),
          secondary: Color(0xFF8A2387),
          surface: Color(0xFF1E1E2C),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/main': (_) => const MainShell(),
      },
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authCtrl = context.watch<AuthController>();
    final isStreamer = authCtrl.isStreamer;

    final List<Widget> maleScreens = [
      const IntegratedForYouScreen(),
      const FollowScreen(),
      const GameScreen(),
      const ChatListScreen(),
      const ProfileScreen(),
    ];

    final List<Widget> femaleScreens = [
      const IntegratedForYouScreen(),
      const FollowScreen(),
      const LiveStreamScreen(),
      const GameScreen(),
      const ChatListScreen(),
      const ProfileScreen(),
    ];

    final currentScreen = isStreamer
        ? femaleScreens[_currentIndex < femaleScreens.length ? _currentIndex : 0]
        : maleScreens[_currentIndex < maleScreens.length ? _currentIndex : 0];

    final items = isStreamer
        ? const [
            BottomNavigationBarItem(icon: Icon(Icons.thumb_up_alt_outlined), label: 'For You'),
            BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Follow'),
            BottomNavigationBarItem(icon: Icon(Icons.videocam_rounded), label: 'Go live'),
            BottomNavigationBarItem(icon: Icon(Icons.games_outlined), label: 'Game'),
            BottomNavigationBarItem(icon: Icon(Icons.message_outlined), label: 'Messages'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Me'),
          ]
        : const [
            BottomNavigationBarItem(icon: Icon(Icons.thumb_up_alt_outlined), label: 'For You'),
            BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Follow'),
            BottomNavigationBarItem(icon: Icon(Icons.games_outlined), label: 'Game'),
            BottomNavigationBarItem(icon: Icon(Icons.message_outlined), label: 'Messages'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Me'),
          ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fizz Live Pro', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.security, color: Colors.cyanAccent),
            tooltip: 'Auth Settings',
            onPressed: () => EntryPopupsHelper.showAuthorizationSettingsDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_active, color: Colors.amberAccent),
            tooltip: 'Call Reminder',
            onPressed: () => EntryPopupsHelper.showCallReminderDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.card_giftcard, color: Colors.pinkAccent),
            tooltip: 'Daily Rewards',
            onPressed: () => EntryPopupsHelper.showDailyRewardsDialog(context),
          ),
        ],
      ),
      body: currentScreen,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E1E2C),
        selectedItemColor: const Color(0xFFE94057),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex >= items.length ? 0 : _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: items,
      ),
    );
  }
}

// Integrated For You Screen using our New Modules & Filters
class IntegratedForYouScreen extends StatefulWidget {
  const IntegratedForYouScreen({super.key});

  @override
  State<IntegratedForYouScreen> createState() => _IntegratedForYouScreenState();
}

class _IntegratedForYouScreenState extends State<IntegratedForYouScreen> {
  StreamerCategory? _selectedCategory;

  void _openLiveRoom(CategoryStreamerItem streamer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveRoomMainScreen(
          streamerName: streamer.name,
          streamerId: streamer.id,
          streamerCountry: streamer.country,
          onClosePressed: () => Navigator.pop(context),
          onProfilePressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Opening Profile for ${streamer.name}')),
            );
          },
          childContent: Stack(
            fit: StackFit.expand,
            children: [
              // Top Synced Heart / Follow Controller
              Positioned(
                top: 90,
                left: 16,
                child: SyncedHeartsAndFollowController(
                  onFollowStateChanged: () {
                    // Sync action handled inside controller
                  },
                ),
              ),

              // Viewer count & Video call actions
              Positioned(
                top: 90,
                right: 16,
                child: ViewerListAndVideoCallActions(
                  viewersCount: streamer.viewersCount,
                  onViewersListTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.grey[900],
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (ctx) => Container(
                        padding: const EdgeInsets.all(16),
                        height: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Active Viewers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const Divider(color: Colors.white24),
                            Expanded(
                              child: ListView(
                                children: [
                                  ListTile(
                                    leading: const CircleAvatar(backgroundColor: Colors.pinkAccent, child: Text('U1')),
                                    title: const Text('Viewer_Alex'),
                                    subtitle: const Text('@alex_99'),
                                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                                    onTap: () => Navigator.pop(ctx),
                                  ),
                                  ListTile(
                                    leading: const CircleAvatar(backgroundColor: Colors.purpleAccent, child: Text('U2')),
                                    title: const Text('Viewer_Priya'),
                                    subtitle: const Text('@priya_live'),
                                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                                    onTap: () => Navigator.pop(ctx),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  onGiftTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gift sent successfully! 🎁')),
                    );
                  },
                  onVideoCallTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Connecting 1-to-1 Video Call... 📞')),
                    );
                  },
                ),
              ),

              // Live Chat & Warning Banner at bottom left
              const Positioned(
                bottom: 20,
                left: 16,
                right: 16,
                child: LiveChatAndWarningBanner(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allStreamers = LiveStreamFilterManager.getMockCategoryStreamers();
    final displayedStreamers = _selectedCategory == null
        ? allStreamers
        : LiveStreamFilterManager.filterByCategory(allStreamers, _selectedCategory!);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed Pretty, New, Sexy Category Filter Cards
            CategoryFilterCardsWidget(
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Live Streamers',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            // Live Stream Grid View linked to our Live Room Screen
            LiveRowGridWidget(
              streamers: displayedStreamers,
              onStreamerTap: (streamer) {
                _openLiveRoom(streamer);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FollowScreen extends StatelessWidget {
  const FollowScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Followed Creators')));
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Interactive Live Games 🎮')));
}

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Messages')), body: const Center(child: Text('Chat List')));
}

class LiveStreamScreen extends StatelessWidget {
  const LiveStreamScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Go Live (Streamer) • 💎 ${appState.gems}'), actions: [IconButton(icon: const Icon(Icons.card_giftcard), onPressed: () => appState.sendGift('Anitha_Live', 'Rose', 50))]),
      body: const Center(child: Text('Live Stream Broadcaster View', style: TextStyle(color: Colors.white))),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Center(child: Text('${appState.userName}\n${appState.userHandle}\nGems: ${appState.gems}')),
    );
  }
}

