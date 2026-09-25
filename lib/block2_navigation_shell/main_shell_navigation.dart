import 'package:flutter/material.dart';
import '../block3_hot_tab/hot_tab_grid_screen.dart';
import '../block4_live_tab_filters/live_tab_screen.dart';

class MainShellNavigation extends StatefulWidget {
  const MainShellNavigation({super.key});

  @override
  State<MainShellNavigation> createState() => _MainShellNavigationState();
}

class _MainShellNavigationState extends State<MainShellNavigation> {
  int _currentIndex = 0;
  bool _isFemaleStreamer = true; // Set true for Female streamer to show Go Live

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HotAndLiveContainerTab(),
      const Center(child: Text('Follow Screen', style: TextStyle(color: Colors.white))),
      if (_isFemaleStreamer) const Center(child: Text('Go Live Screen', style: TextStyle(color: Colors.white))),
      const Center(child: Text('Game Screen', style: TextStyle(color: Colors.white))),
      const Center(child: Text('Messages Screen', style: TextStyle(color: Colors.white))),
      const Center(child: Text('Me Profile Screen', style: TextStyle(color: Colors.white))),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: SafeArea(child: pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E1E2C),
        selectedItemColor: const Color(0xFFE94057),
        unselectedItemColor: Colors.white54,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (val) => setState(() => _currentIndex = val),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.thumb_up), label: 'For You'),
          const BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Follow'),
          if (_isFemaleStreamer) const BottomNavigationBarItem(icon: Icon(Icons.live_tv, color: Colors.pinkAccent), label: 'Go Live'),
          const BottomNavigationBarItem(icon: Icon(Icons.games), label: 'Game'),
          const BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}

class HotAndLiveContainerTab extends StatelessWidget {
  const HotAndLiveContainerTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          AppBar(
            backgroundColor: const Color(0xFF0F0F1A),
            title: const Text('Fizz Live Pro', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            actions: [
              IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
              IconButton(icon: const Icon(Icons.public, color: Colors.white), onPressed: () {}),
            ],
            bottom: const TabBar(
              indicatorColor: Color(0xFFE94057),
              labelColor: Color(0xFFE94057),
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(text: 'Hot'),
                Tab(text: 'Live'),
                Tab(text: 'Party'),
                Tab(text: 'Match'),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [
                HotTabGridScreen(),
                LiveTabScreen(),
                Center(child: Text('Party Screen', style: TextStyle(color: Colors.white))),
                Center(child: Text('Match Screen', style: TextStyle(color: Colors.white))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
