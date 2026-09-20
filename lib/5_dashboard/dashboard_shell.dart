import 'package:flutter/material.dart';
import '../1_core/core_data.dart';
import '../3_discovery/discovery_feed.dart';
import '../4_interactions/call_and_party_screens.dart';
import '../wallet/wallet_screen.dart';
import 'post_login_popups.dart'; // import this

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});
  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int idx = 0;
  final pages = [
    const DiscoveryFeedView(), 
    const PartyRoomGridWidget(), 
    const Center(child: Text('Messages', style: TextStyle(color: Colors.white))), 
    const WalletScreen()
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Fizz Live Pro', style: TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold)),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ValueListenableBuilder<int>(
                valueListenable: globalWallet,
                builder: (_, val, __) => Text('💎 $val', style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
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
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Party'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}
