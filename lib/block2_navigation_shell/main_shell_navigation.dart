import 'package:flutter/material.dart';
import '../block1_auth_onboarding/login_auth_screen.dart';
import 'hot_and_live_container_tab.dart';

class MainShellNavigation extends StatefulWidget {
  const MainShellNavigation({super.key});

  @override
  State<MainShellNavigation> createState() => _MainShellNavigationState();
}

class _MainShellNavigationState extends State<MainShellNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    bool isFemaleStreamer = (GlobalAuthRegistry.userGender == 'Female');

    final List<Widget> pages = [
      const HotAndLiveContainerTab(),
      const Center(child: Text('Follow Screen', style: TextStyle(color: Colors.white))),
      if (isFemaleStreamer) const Center(child: Text('Go Live Screen', style: TextStyle(color: Colors.white))),
      const Center(child: Text('Game Screen', style: TextStyle(color: Colors.white))),
      const Center(child: Text('Messages Screen', style: TextStyle(color: Colors.white))),
      const Center(child: Text('Me Profile Screen', style: TextStyle(color: Colors.white))),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1D1B36),
        selectedItemColor: const Color(0xFFF97316),
        unselectedItemColor: Colors.white54,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (val) => setState(() => _currentIndex = val),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.thumb_up), label: 'For You'),
          const BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Follow'),
          if (isFemaleStreamer) const BottomNavigationBarItem(icon: Icon(Icons.live_tv, color: Colors.pinkAccent), label: 'Go Live'),
          const BottomNavigationBarItem(icon: Icon(Icons.games), label: 'Game'),
          const BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}

