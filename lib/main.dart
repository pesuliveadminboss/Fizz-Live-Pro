import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'auth_controller.dart';
import 'login_screen.dart';
import 'popups_and_dialogs.dart';
import 'feed_and_tabs.dart';

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
      const HomeScreenContainer(),
      const FollowScreen(),
      const GameScreen(),
      const ChatListScreen(),
      const ProfileScreen(),
    ];

    final List<Widget> femaleScreens = [
      const HomeScreenContainer(),
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

class HomeScreenContainer extends StatefulWidget {
  const HomeScreenContainer({super.key});
  @override
  State<HomeScreenContainer> createState() => _HomeScreenContainerState();
}

class _HomeScreenContainerState extends State<HomeScreenContainer> {
  bool _popupsTriggered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_popupsTriggered) {
      _popupsTriggered = true;
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) EntryPopupsHelper.showDailyRewardsDialog(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) => const ForYouScreen();
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
