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
          MaterialPageRoute(builder: (c) => const AdminGatewayScreen()),
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

class OneOnOneCallScreen extends StatefulWidget {
  final Map<String, String> host;
  final Function(int spent) onCallEnded;
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
          Positioned.fill(child: Image.network(widget.host['img']!, fit: BoxFit.cover)),
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

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _tab = 0;
  int _userGems = 1670;
  int _selectedPack = 0;

  final List<Map<String, String>> _hosts = [
    {'name': 'Pooja', 'id': '78921', 'status': 'Live', 'level': 'LV7', 'img': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400'},
    {'name': 'Ananya', 'id': '65412', 'status': 'Busy', 'level': 'LV6', 'img': 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400'},
    {'name': 'Sneha', 'id': '99421', 'status': 'Active', 'level': 'LV8', 'img': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400'},
    {'name': 'Kavya', 'id': '33109', 'status': 'Live', 'level': 'LV5', 'img': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400'},
  ];

  final List<Map<String, dynamic>> _rechargePacks = [
    {'gems': 4050, 'price': '100.00', 'discount': ''},
    {'gems': 8100, 'price': '200.00', 'discount': '17% off'},
    {'gems': 16380, 'price': '400.00', 'discount': '17% off'},
    {'gems': 32940, 'price': '800.00', 'discount': '17% off'},
    {'gems': 66600, 'price': '1600.00', 'discount': '30% off'},
    {'gems': 167400, 'price': '4000.00', 'discount': '60% off'},
  ];

  void _showRechargeSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 24),
                      const Column(
                        children: [
                          Text('Make video calls with Gems', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('Call beauties with Gems', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      IconButton(icon: const Icon(Icons.close, color: Colors.grey, size: 20), onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.95,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _rechargePacks.length,
                    itemBuilder: (context, i) {
                      final pack = _rechargePacks[i];
                      final isSelected = _selectedPack == i;
                      return GestureDetector(
                        onTap: () => setSheetState(() => _selectedPack = i),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFFFF2DC) : const Color(0xFFF7F7F9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isSelected ? const Color(0xFFFFA500) : Colors.transparent, width: 1.5),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.diamond, color: Color(0xFFFFA500), size: 24),
                              const SizedBox(height: 4),
                              Text('${pack['gems']}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)),
                              Text('₹${pack['price']}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.diamond, color: Color(0xFFFFA500), size: 16),
                      const SizedBox(width: 4),
                      Text('My Gems: $_userGems', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        final int added = _rechargePacks[_selectedPack]['gems'] as int;
                        setState(() => _userGems += added);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFBA28A9)),
                      child: const Text('Continue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _startPrivateCall(Map<String, String> host) {
    if (_userGems >= 1800) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (c) => OneOnOneCallScreen(
            host: host,
            onCallEnded: (int spent) {
              setState(() => _userGems -= spent);
            },
          ),
        ),
      );
    } else {
      _showRechargeSheet();
    }
  }

  Widget _buildMeProfile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Row(
            children: [
              CircleAvatar(radius: 32, backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200')),
              SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pesulive User', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 4),
                  Text('ID: 207183 • Lv.4', style: TextStyle(color: Color(0xFFFFD700), fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF14141E), borderRadius: BorderRadius.circular(16)),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('My Level: Lv.4', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('Lv.5', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(value: 0.74, backgroundColor: Colors.white12, color: Color(0xFFFFD700)),
                SizedBox(height: 6),
                Text('Top up more to 278817 gems level up', style: TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFF14141E), borderRadius: BorderRadius.circular(14)),
                  child: Column(
                    childr
