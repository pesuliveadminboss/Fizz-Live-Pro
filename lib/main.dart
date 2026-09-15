import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const AdminGatewayScreen()));
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
              if (_err.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_err, style: const TextStyle(color: Colors.redAccent))),
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
              const ListTile(leading: Icon(Icons.videocam, color: Color(0xFFFFD700)), title: Text('Camera', style: TextStyle(color: Colors.white)), subtitle: Text('For video calls and streaming', style: TextStyle(color: Colors.grey))),
              const ListTile(leading: Icon(Icons.mic, color: Color(0xFFFFD700)), title: Text('Microphone', style: TextStyle(color: Colors.white)), subtitle: Text('For voice talk', style: TextStyle(color: Colors.grey))),
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
  int _userGems = 1670;
  int _selectedPack = 0;

  final List<Map<String, String>> _hosts = const [
    {'name': 'Pooja', 'id': '78921', 'status': 'Live', 'level': 'LV7', 'img': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400'},
    {'name': 'Ananya', 'id': '65412', 'status': 'Busy', 'level': 'LV6', 'img': 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400'},
    {'name': 'Sneha', 'id': '99421', 'status': 'Active', 'level': 'LV8', 'img': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400'},
    {'name': 'Kavya', 'id': '33109', 'status': 'Live', 'level': 'LV5', 'img': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400'},
  ];

  final List<Map<String, dynamic>> _rechargePacks = const [
    {'gems': 4050, 'price': '100.00'},
    {'gems': 8100, 'price': '200.00'},
    {'gems': 16380, 'price': '400.00'},
    {'gems': 32940, 'price': '800.00'},
    {'gems': 66600, 'price': '1600.00'},
    {'gems': 167400, 'price': '4000.00'},
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
                  const Text('Make video calls with Gems', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                  const Text('Call beauties with Gems', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.0,
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
                              Text('${pack['gems']}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              Text('₹${pack['price']}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  Text('My Gems: $_userGems', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14)),
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
                      child: const Text('Continue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

  void _callHost(Map<String, String> h) {
    if (_userGems >= 1800) {
      setState(() => _userGems -= 1800);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Connected to ${h['name']}! (1800 Gems spent)')));
    } else {
      _showRechargeSheet();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      // 0: For You (Host Grid)
      GridView.builder(
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
                      Text(h['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.video_call_rounded, color: Color(0xFFFF2E93), size: 28),
                        onPressed: () => _callHost(h),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),

      // 1: Follow Page
      ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _hosts.length,
        itemBuilder: (context, i) {
          final h = _hosts[i];
          return Card(
            color: const Color(0xFF14141E),
            child: ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(h['img']!)),
              title: Text(h['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Text("Level: ${h['level']} • Status: ${h['status']}", style: const TextStyle(color: Colors.grey)),
              trailing: ElevatedButton(
                onPressed: () => _callHost(h),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2E93)),
                child: const Text('Call', style: TextStyle(fontSize: 12)),
              ),
            ),
          );
        },
      ),

      // 2: Game Tab (Lucky Spin & Mini Games)
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: const Color(0xFF14141E),
              child: ListTile(
                leading: const Icon(Icons.casino_rounded, color: Color(0xFFFFD700), size: 36),
                title: const Text('Lucky Wheel Spin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: const Text('Spin with 100 gems & win up to 5000 gems!', style: TextStyle(color: Colors.grey, fontSize: 12)),
                trailing: ElevatedButton(
                  onPressed: () {
                    if (_userGems >= 100) {
                      setState(() => _userGems += 200); // Net win +100
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Jackpot! You won 300 Gems!')));
                    } else {
                      _showRechargeSheet();
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700), foregroundColor: Colors.black),
                  child: const Text('Play', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: const Color(0xFF14141E),
              child: ListTile(
                leading: const Icon(Icons.card_giftcard, color: Color(0xFFFF2E93), size: 36),
                title: const Text('Treasure Box', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: const Text('Open secret box to get SVIP Badge', style: TextStyle(color: Colors.grey, fontSize: 12)),
                trailing: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('SVIP Entry Effect Unlocked!')));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E5FF), foregroundColor: Colors.black),
                  child: const Text('Open', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),

      // 3: Messages Tab (Inbox & System Alerts)
      ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Card(
            color: const Color(0xFF14141E),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Color(0xFFFFD700), child: Icon(Icons.notifications, color: Colors.black)),
              title: Text('System Announcement', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Text('Welcome to Fizz Live Pro! 50 Free gems credited.', style: TextStyle(color: Colors.grey)),
            ),
          ),
          const SizedBox(height: 6),
          Card(
            color: const Color(0xFF14141E),
            child: ListTile(
              leading: const CircleAvatar(backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200')),
              title: const Text('Pooja (Host)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: const Text('Hey! Missed your call, are you online now?', style: TextStyle(color: Colors.greenAccent)),
              trailing: IconButton(
                icon: const Icon(Icons.video_call, color: Color(0xFFFF2E93)),
                onPressed: () => _callHost(_hosts[0]),
              ),
            ),
          ),
          Card(
            color: const Color(0xFF14141E),
            child: ListTile(
              leading: const CircleAvatar(backgroundImage: NetworkImage('https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200')),
              title: const Text('Ananya (Host)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: const Text('Thanks for the Kiss gift earlier 💕', style: TextStyle(color: Colors.grey)),
              trailing: IconButton(
                icon: const Icon(Icons.video_call, color: Color(0xFFFF2E93)),
                onPressed: () => _callHost(_hosts[1]),
              ),
            ),
          ),
        ],
      ),

      // 4: Me Profile Tab
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const ListTile(
              leading: CircleAvatar(radius: 28, backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200')),
       
