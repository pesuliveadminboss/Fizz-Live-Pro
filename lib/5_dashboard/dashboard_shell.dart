import 'package:flutter/material.dart';
import '../1_core/core_data.dart';
import '../3_discovery/discovery_feed.dart';
import '../4_interactions/call_and_party_screens.dart';
import '../wallet/wallet_screen.dart';
import 'post_login_popups.dart';

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});
  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int idx = 0;
  final pages = [
    const DiscoveryFeedView(), // For You (Hot, Live, Party, Match tabs + search + world + gift box)
    const Center(child: Text('Follow Streamers Feed', style: TextStyle(color: Colors.white))), // Follow
    const Center(child: Text('Games Hub', style: TextStyle(color: Colors.white))), // Game
    const Center(child: Text('Messages Inbox', style: TextStyle(color: Colors.white))), // Messages
    const WalletScreen(), // Me / Wallet & Profile
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PostLoginPopupManager.showSequentialPopups(context);
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: pages[idx],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: AppTheme.primaryPink,
        unselectedItemColor: Colors.white54,
        currentIndex: idx,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => idx = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'For You'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Follow'),
          BottomNavigationBarItem(icon: Icon(Icons.games_outlined), label: 'Game'),
          BottomNavigationBarItem(icon: Icon(Icons.message_outlined), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Me'),
        ],
      ),
    );
  }
}
