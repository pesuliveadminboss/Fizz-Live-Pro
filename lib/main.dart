import 'package:flutter/material.dart';

// Import all blocks and navigation containers safely
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
      home: const MainShellScreen(),
    );
  }
}

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;

  // Complete integrated screens for all blocks (Blocks 1 to 5)
  final List<Widget> _screens = [
    // Index 0: Home / Hot & Live Container (Integrated with Block 2 & Block 5 Live Tab)
    const HotAndLiveContainerTab(),
    
    // Index 1: Explore / Match Screen
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

    // Index 3: Messages / Chat Inbox Screen
    const Center(
      child: Text(
        'Messages Inbox 💬',
        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),

    // Index 4: Profile / Me Settings Screen
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

