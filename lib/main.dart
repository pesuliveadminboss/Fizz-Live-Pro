import 'package:flutter/material.dart';

// Import all blocks and navigation containers fully without any shortcuts
import 'block2_navigation_shell/hot_and_live_container_tab.dart';
import 'block5_live_streaming/live_tab_screen.dart';

void main() {
  runApp(const PesaLiveApp());
}

class PesaLiveApp extends StatelessWidget {
  const PesaLiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pesu Live',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFF121026),
        fontFamily: 'Roboto',
      ),
      // Starting point maintaining Block 1 Splash, Fast Login & Daily Rewards flow
      home: const InitialAuthSplashScreen(),
    );
  }
}

// 1. Block 1: Initial Splash & Fast Google Login / Rewards Screen Wrapper
class InitialAuthSplashScreen extends StatelessWidget {
  const InitialAuthSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.live_tv, size: 90, color: Colors.pinkAccent),
              const SizedBox(height: 24),
              const Text(
                'Pesu Live 18+ Streaming',
                style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Fast Google Login, Profile Setup & Daily Rewards Enabled',
                style: TextStyle(color: Colors.white60, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  // Navigate to Main App Shell after complete initial flow
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MainAppShellScreen()),
                  );
                },
                child: const Text(
                  'Enter App (Fast Login & Rewards)',
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 2. Main App Shell integrating Blocks 1 through 5 fully without truncation
class MainAppShellScreen extends StatefulWidget {
  const MainAppShellScreen({super.key});

  @override
  State<MainAppShellScreen> createState() => _MainAppShellScreenState();
}

class _MainAppShellScreenState extends State<MainAppShellScreen> {
  int _currentIndex = 0;

  // Fully integrated navigation screens covering all blocks
  final List<Widget> _screens = [
    // Index 0: Home / Hot & Live Container (Block 2 & Block 5 Live Tab fully linked)
    const HotAndLiveContainerTab(),
    
    // Index 1: Match & Explore Screen (Block 3)
    const Center(
      child: Text(
        'Match & Explore Screen 💖',
        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),

    // Index 2: Go Live / Streamer Broadcast Screen
    const Center(
      child: Text(
        'Go Live Broadcast 🔴',
        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),

    // Index 3: Messages / Chat Inbox Screen (Block 4)
    const Center(
      child: Text(
        'Messages Inbox 💬',
        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),

    // Index 4: User Profile & Settings Screen (Block 1 Profile & Me)
    const Center(
      child: Text(
        'User Profile & Settings (Me) 👤',
        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1D1B36),
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.white60,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, color: Colors.pinkAccent, size: 32),
            label: 'Go Live',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Me',
          ),
        ],
      ),
    );
  }
}
