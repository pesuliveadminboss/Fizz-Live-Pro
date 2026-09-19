import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Splash()));
}

class GiftItem {
  final String name, iconUrl, emoji;
  final int gems;
  const GiftItem(this.name, this.gems, {this.iconUrl = '', this.emoji = '🎁'});
}

final Map<String, List<GiftItem>> giftCategories = {
  'Hot': [
    const GiftItem('Champagne', 50, emoji: '🍾', iconUrl: 'https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=100'),
    const GiftItem('Loving Girl', 900, emoji: '💃', iconUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100'),
  ],
  'Lucky': [const GiftItem('Mystery Box', 360, emoji: '🎁')],
  'Svip': [],
  'Intimacy': [
    const GiftItem('In My Hand', 300, emoji: '🤝'),
    const GiftItem('Kiss', 180, emoji: '💋'),
  ],
  'Wealth': [const GiftItem('Cruise Eve', 3700, emoji: '🚢')],
  'Festival': [const GiftItem('Puppy', 180, emoji: '🐶')],
  'Bag': [const GiftItem('Rose', 20, emoji: '🌹')],
};

class Host {
  final String name, pic, cat, tag, flag, status;
  final int id;
  const Host({required this.name, required this.pic, required this.cat, required this.tag, required this.flag, required this.status, required this.id});
}

class PartyRoom {
  final String title, hostName, avatar, membersCount;
  final int onlineCount;
  const PartyRoom({required this.title, required this.hostName, required this.avatar, required this.membersCount, required this.onlineCount});
}

final List<PartyRoom> mockPartyRooms = [
  const PartyRoom(title: 'kaiman acho sabai 😍', hostName: 'Beauty', avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200', membersCount: '12', onlineCount: 9517),
  const PartyRoom(title: 'Mahfil a isha 💖', hostName: 'Mahfil', avatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200', membersCount: '10', onlineCount: 13589),
];

class Splash extends StatefulWidget {
  const Splash({super.key});
  @override
  State<Splash> createState() => _SplashState();
}
class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CustomLoginScreen()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.live_tv, size: 75, color: Colors.pinkAccent),
            SizedBox(height: 14),
            Text('FIZZ LIVE PRO', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.amber, letterSpacing: 1.5)),
            SizedBox(height: 6),
            Text('Private Live Video & Party Audio Chat', style: TextStyle(fontSize: 12, color: Colors.white54)),
          ],
        ),
      ),
    );
  }
}

class CustomLoginScreen extends StatelessWidget {
  const CustomLoginScreen({super.key});

  final List<Map<String, dynamic>> _bubbles = const [
    {'img': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200', 'top': 40, 'left': 30, 'size': 68},
    {'img': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200', 'top': 30, 'right': 40, 'size': 62},
    {'img': 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200', 'top': 180, 'left': 50, 'size': 85},
    {'img': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200', 'top': 195, 'right': 35, 'size': 82},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0713),
      body: Stack(
        children: [
          ..._bubbles.map((b) => Positioned(
            top: (b['top'] as num).toDouble(),
            left: b.containsKey('left') ? (b['left'] as num).toDouble() : null,
            right: b.containsKey('right') ? (b['right'] as num).toDouble() : null,
            child: Container(
              width: (b['size'] as num).toDouble(),
              height: (b['size'] as num).toDouble(),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                image: DecorationImage(image: NetworkImage(b['img'] as String), fit: BoxFit.cover),
              ),
            ),
          )),
          Positioned(
            bottom: 40, left: 24, right: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Dashboard())),
                  child: Container(
                    width: double.infinity, height: 52,
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.purpleAccent]), borderRadius: BorderRadius.circular(26)),
                    alignment: Alignment.center,
                    child: const Text('Fast Login', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}
class _DashboardState extends State<Dashboard> {
  int _navIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: const Center(child: Text('Dashboard Ready', style: TextStyle(color: Colors.white))),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black, selectedItemColor: Colors.pink, unselectedItemColor: Colors.white54, currentIndex: _navIndex, type: BottomNavigationBarType.fixed,
        onTap: (idx) => setState(() => _navIndex = idx),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'For You'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Follow'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_esports), label: 'Game'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}
