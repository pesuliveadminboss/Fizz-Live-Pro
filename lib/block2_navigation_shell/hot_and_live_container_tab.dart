import 'package:flutter/material.dart';
import 'hot_tab_grid_screen.dart';
import '../block5_live_streaming/live_tab_screen.dart';

class HotAndLiveContainerTab extends StatefulWidget {
  const HotAndLiveContainerTab({super.key});

  @override
  State<HotAndLiveContainerTab> createState() => _HotAndLiveContainerTabState();
}

class _HotAndLiveContainerTabState extends State<HotAndLiveContainerTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // 4 Tabs: Hot, Live, Party, Match
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121026),
        elevation: 0,
        title: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.pinkAccent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Hot'),
            Tab(text: 'Live'),
            Tab(text: 'Party'),
            Tab(text: 'Match'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. Hot Tab (Original Grid Screen)
          const HotTabGridScreen(),
          
          // 2. Live Tab (Directly linked to Block 5 LiveTabScreen)
          const LiveTabScreen(),
          
          // 3. Party Tab Placeholder
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.party_mode, size: 64, color: Colors.white24),
                SizedBox(height: 12),
                Text('Party Rooms Coming Soon 🎉', style: TextStyle(color: Colors.white60, fontSize: 14)),
              ],
            ),
          ),
          
          // 4. Match Tab Placeholder
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.people_alt, size: 64, color: Colors.white24),
                SizedBox(height: 12),
                Text('Matchmaking Coming Soon 💖', style: TextStyle(color: Colors.white60, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
