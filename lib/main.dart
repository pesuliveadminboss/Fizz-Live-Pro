import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'auth_controller.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'explore_screen.dart';
import 'live_stream_screen.dart';
import 'chat_list_screen.dart';
import 'profile_screen.dart';
import 'party_room_screen.dart';

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

  final List<Widget> _screens = [
    const HomeScreen(),
    const ExploreScreen(),
    const LiveStreamScreen(),
    const ChatListScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final authCtrl = context.watch<AuthController>();

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E1E2C),
        selectedItemColor: const Color(0xFFE94057),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 2 && !authCtrl.isStreamer) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Go Live is available for Streamers (Female role) only.')),
            );
            return;
          }
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'Live'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
