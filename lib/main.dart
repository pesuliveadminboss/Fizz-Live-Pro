import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_modules.dart';

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
        title: Text(isStreamer ? 'Fizz Live Pro (Streamer)' : 'Fizz Live Pro (User)'),
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
