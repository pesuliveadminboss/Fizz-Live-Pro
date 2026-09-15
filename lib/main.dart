import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FizzLiveProApp());
}

class FizzLiveProApp extends StatelessWidget {
  const FizzLiveProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fizz Live Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF07070A),
        primaryColor: const Color(0xFFFFD700),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminGatewayScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF07070A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam_rounded, size: 70, color: Color(0xFFFF2E93)),
            SizedBox(height: 16),
            Text('FIZZ LIVE PRO', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 4, color: Color(0xFFFFD700))),
          ],
        ),
      ),
    );
  }
}

class AdminGatewayScreen extends StatefulWidget {
  const AdminGatewayScreen({super.key});

  @override
  State<AdminGatewayScreen> createState() => _AdminGatewayScreenState();
}

class _AdminGatewayScreenState extends State<AdminGatewayScreen> {
  final TextEditingController _pin = TextEditingController();
  String _err = "";

  void _checkPin() {
    if (_pin.text.trim() == "7777") {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const LoginScreen()));
    } else {
      setState(() => _err = "Invalid PIN! Access Denied.");
      _pin.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07070A),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.admin_panel_settings_rounded, size: 60, color: Color(0xFFFFD700)),
              const SizedBox(height: 16),
              const Text('Admin Verification', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              TextField(
                controller: _pin,
                keyboardType: TextInputType.number,
                obscureText: true,
                textAlign: TextAlign.center,
                maxLength: 4,
                style: const TextStyle(color: Color(0xFFFFD700), fontSize: 26, letterSpacing: 12),
                decoration: InputDecoration(
                  counterText: "",
                  filled: true,
                  fillColor: const Color(0xFF14141E),
                  hintText: "••••",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              if (_err.isNotEmpty) Text(_err, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _checkPin,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700), foregroundColor: Colors.black),
                  child: const Text('Unlock App', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07070A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Spacer(),
              const CircleAvatar(radius: 45, backgroundImage: NetworkImage("https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200")),
              const SizedBox(height: 12),
              const Text('Meet Real Friends Nearby', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const AuthorizationScreen()));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2E93)),
                  child: const Text('Fast Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Agree to Terms & Privacy Policy', style: TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthorizationScreen extends StatelessWidget {
  const AuthorizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07070A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text('Authorization Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              const Text('Allow permissions for 1-on-1 private video calls.', style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 24),
              const ListTile(leading: Icon(Icons.videocam, color: Color(0xFFFFD700)), title: Text('Camera'), subtitle: Text('For video calls and streaming')),
              const ListTile(leading: Icon(Icons.mic, color: Color(0xFFFFD700)), title: Text('Microphone'), subtitle: Text('For voice talk')),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const MainDashboardScreen()));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E5FF), foregroundColor: Colors.black),
                  child: const Text('Allow all permissions', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _tab = 0;
  int _userGems = 2500;

  final List<Map<String, String>> _hosts = [
    {'name': 'Pooja', 'id': '78921', 'status': 'Live', 'level': 'LV7', 'img': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400'},
    {'name': 'Ananya', 'id': '65412', 'status': 'Busy', 'level': 'LV6', 'img': 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400'},
    {'name': 'Sneha', 'id': '99421', 'status': 'Active', 'level': 'LV8', 'img': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400'},
    {'name': 'Kavya', 'id': '33109', 'status': 'Live', 'level': 'LV5', 'img': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400'},
  ];

  void _startPrivateCall(Map<String, String> host) {
    if (_userGems >= 1800) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (c) => OneOnOneCallScreen(
            host: host,
            onCallEnded: (spent) => setState(() => _userGems -= spent),
          ),
        ),
      );
    } else {
      _showRechargeDialog();
    }
  }

  void _showRechargeDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF14141E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (c) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.diamond_outlined, color: Color(0xFFFFD700), size: 40),
            const SizedBox(height: 10),
            const Text('Insufficient Gems!', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Private call requires 1800 Gems/min.', style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 16),
            _rechargeOption('₹100', '1,200 Gems + 200 Free', () {
              setState(() => _userGems += 1400);
              Navigator.pop(context);
            }),
            const SizedBox(height: 8),
            _rechargeOption('₹300', '4,000 Gems + 800 Free', () {
              setState(() => _userGems += 4800);
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }

  Widget _rechargeOption(String price, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: const Color(0xFF1E1E2C), borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2E93)),
              child: Text(price),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF101016),
        title: const Text('Fizz Live Pro', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFF1E1E2C), borderRadius: BorderRadius.circular(14)),
              child: Row(
                children: [
                  const Icon(Icons.diamond, color: Color(0xFFFFD700), size: 16),
                  const SizedBox(width: 4),
                  Text('$_userGems', style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
      body: _tab == 0
          ? GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _hosts.length,
              itemBuilder: (context, i) {
                final h = _hosts[i];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(h['img']!, fit: BoxFit.cover),
                      Container(color: Colors.black26),
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
                          child: Text(h['status']!, style: const TextStyle(color: Colors.greenAccent, fontSize: 10)),
                        ),
                      ),
                      Positioned(
                        bottom: 6,
                        left: 6,
                        right: 6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(h['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                Text(h['level']!, style: const TextStyle(color: Color(0xFFFFD700), fontSize: 10)),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.video_call_rounded, color: Color(0xFFFF2E93), size: 28),
                              onPressed: () => _startPrivateCall(h),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(child: Text('Tab: $_tab', style: const TextStyle(color: Colors.grey))),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0E0E14),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.local_fire_department), label: 'For You'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Follow'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_esports), label: 'Game'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// புள்ளி 31-34: 1-on-1 பிரைவேட் வீடியோ கால் திரை
// -------------------------------------------------------------
class OneOnOneCallScreen extends StatefulWidget {
  final Map<String, String> host;
  final Function(int) onCallEnded;
  const OneOnOneCallScreen({super.key, required this.host, required this.onCallEnded});

  @override
  State<OneOnOneCallScreen> createState() => _OneOnOneCallScreenState();
}

class _OneOnOneCallScreenState extends State<OneOnOneCallScreen> {
  int _seconds = 0;
  Timer? _timer;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _seconds++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int sec) {
    final m = (sec ~/ 60).toString().padLeft(2, '0');
    final s = (sec % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(widget.host['img']!, fit: BoxFit.cover),
          ),
          Positioned.fill(child: Container(color: Colors.black38)),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.host['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          const Text('1800 Gems / min', style: TextStyle(color: Color(0xFFFFD700), fontSize: 12)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(12)),
                        child: Text(_formatTime(_seconds), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: _isMuted ? Colors.red : Colors.white24,
                        child: IconButton(
                          icon: Icon(_isMuted ? Icons.mic_off : Icons.mic, color: Colors.white),
                          onPressed: () => setState(() => _isMuted = !_isMuted),
                        ),
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.red,
                        child: IconButton(
                          icon: const Icon(Icons.call_end, color: Colors.white, size: 28),
                          onPressed: () {
                            widget.onCallEnded(1800);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white24,
                        child: IconButton(
                          icon: const Icon(Icons.cameraswitch, color: Colors.white),
                          onPressed: () {},
                        ),
                      ),
                    ],
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
