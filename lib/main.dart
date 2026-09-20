import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Zego Init placeholder (Replace with your Zego AppID & AppSign)
  // await ZegoExpressEngine.createEngineWithProfile(ZegoEngineProfile(123456789, ZegoScenario.General, appSign: "YOUR_ZEGO_APPSIGN"));
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Splash()));
}

class GiftItem {
  final String name, iconUrl, emoji;
  final int gems;
  const GiftItem(this.name, this.gems, {this.iconUrl = '', this.emoji = '🎁'});
}

final Map<String, List<GiftItem>> giftCategories = {
  'Hot': [
    const GiftItem('Champagne', 50, emoji: '🍾'),
    const GiftItem('Loving Girl', 900, emoji: '💃'),
  ],
  'Wealth': [const GiftItem('Cruise Eve', 3700, emoji: '🚢')],
};

class Host {
  final String name, pic, tag, flag, status;
  final int id;
  const Host({required this.name, required this.pic, required this.tag, required this.flag, required this.status, required this.id});
}

final List<Host> mockHosts = [
  const Host(name: 'Sneha', pic: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200', tag: 'Fast Match', flag: '🇮🇳', status: 'Online', id: 101),
  const Host(name: 'Priya', pic: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200', tag: 'VIP Host', flag: '🇮🇳', status: 'Online', id: 102),
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
    Future.delayed(const Duration(milliseconds: 1500), () {
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
            Text('1800 Gems/Min Edition', style: TextStyle(fontSize: 12, color: Colors.white54)),
          ],
        ),
      ),
    );
  }
}

class CustomLoginScreen extends StatelessWidget {
  const CustomLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0713),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.video_call_rounded, size: 90, color: Colors.pinkAccent),
              const SizedBox(height: 20),
              const Text('Fizz Live Pro', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Dashboard())),
                child: Container(
                  width: double.infinity, height: 52,
                  decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.purpleAccent]), borderRadius: BorderRadius.circular(26)),
                  alignment: Alignment.center,
                  child: const Text('Fast Login (Guest/UPI)', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom 1800 Gems / min Call Screen
class CustomCallScreen extends StatefulWidget {
  final Host host;
  const CustomCallScreen({super.key, required this.host});
  @override
  State<CustomCallScreen> createState() => _CustomCallScreenState();
}

class _CustomCallScreenState extends State<CustomCallScreen> {
  int gemsRemaining = 4050; // User starts with 4050 gems
  Timer? _billingTimer;
  final int burnRatePerMin = 1800;

  @override
  void initState() {
    super.initState();
    _startBillingLoop();
  }

  void _startBillingLoop() {
    _billingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        int burnPerSec = burnRatePerMin ~/ 60; // 30 gems/sec
        if (gemsRemaining > burnPerSec) {
          gemsRemaining -= burnPerSec;
        } else {
          gemsRemaining = 0;
          _endCall();
        }
      });
    });
  }

  void _endCall() {
    _billingTimer?.cancel();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Call ended / Insufficient Gems (1800/min burn limit reached)')));
  }

  String get formattedTimeLeft {
    int totalSecLeft = (gemsRemaining / (burnRatePerMin / 60)).floor();
    int mins = totalSecLeft ~/ 60;
    int secs = totalSecLeft % 60;
    return '${mins}m ${secs}s';
  }

  @override
  void dispose() {
    _billingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(widget.host.pic, fit: BoxFit.cover),
          ),
          Container(color: Colors.black.withOpacity(0.35)),
          // Top balance & countdown pill
          Positioned(
            top: 50, left: 20, right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                  child: Text('💎 $gemsRemaining gems', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.red.withOpacity(0.8), borderRadius: BorderRadius.circular(20)),
                  child: Text('Time Left: $formattedTimeLeft', style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ],
            ),
          ),
          // Host info overlay
          Positioned(
            bottom: 110, left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${widget.host.name} ${widget.host.flag}', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const Text('Rate: 1800 gems/min (₹20-₹60 payout equivalent)', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          // Bottom controls
          Positioned(
            bottom: 40, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(icon: const Icon(Icons.mic, color: Colors.white), onPressed: () {}),
                IconButton(
                  icon: const Icon(Icons.call_end, color: Colors.white, size: 36),
                  style: IconButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: _endCall,
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
      backgroundColor: const Color(0xFF0F0C1B),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Fizz Live Pro', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('💎 4,050', style: TextStyle(color: Colors.amber[300], fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
      body: _navIndex == 0
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CustomCallScreen(host: mockHosts.first))),
                    child: Container(
                      width: double.infinity, height: 60,
                      decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.purpleAccent]), borderRadius: BorderRadius.circular(30)),
                      alignment: Alignment.center,
                      child: const Text('Start Random Video Call (1800 gems/min)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Align(alignment: Alignment.centerLeft, child: Text('Online Streamers Ready', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: mockHosts.length,
                      itemBuilder: (ctx, i) {
                        final h = mockHosts[i];
                        return Card(
                          color: const Color(0xFF1B152E),
                          child: ListTile(
                            leading: CircleAvatar(backgroundImage: NetworkImage(h.pic)),
                            title: Text('${h.name} ${h.flag}', style: const TextStyle(color: Colors.white)),
                            subtitle: Text('Status: ${h.status} • 1800 gems/min', style: const TextStyle(color: Colors.white54)),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CustomCallScreen(host: h))),
                              child: const Text('Call', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: Text('Section Ready', style: TextStyle(color: Colors.white))),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black, selectedItemColor: Colors.pinkAccent, unselectedItemColor: Colors.white54, currentIndex: _navIndex, type: BottomNavigationBarType.fixed,
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
