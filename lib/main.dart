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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
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
              const Text('Allow required permissions for video calls.', style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 24),
              const ListTile(leading: Icon(Icons.videocam, color: Color(0xFFFFD700)), title: Text('Camera'), subtitle: Text('For video calls and streaming')),
              const ListTile(leading: Icon(Icons.mic, color: Color(0xFFFFD700)), title: Text('Microphone'), subtitle: Text('For voice talk')),
              const ListTile(leading: Icon(Icons.notifications, color: Color(0xFFFFD700)), title: Text('Notification'), subtitle: Text('For call alerts')),
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
  final List<String> _cats = ['Hot', 'Live', 'Party', 'Match'];
  int _cat = 0;

  final List<Map<String, String>> _hosts = [
    {'name': 'Pooja', 'id': '78921', 'status': 'Live', 'level': 'LV7', 'img': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400'},
    {'name': 'Ananya', 'id': '65412', 'status': 'Busy', 'level': 'LV6', 'img': 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400'},
    {'name': 'Sneha', 'id': '99421', 'status': 'Active', 'level': 'LV8', 'img': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400'},
    {'name': 'Kavya', 'id': '33109', 'status': 'Live', 'level': 'LV5', 'img': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF101016),
        title: const Text('Fizz Live Pro', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Color(0xFFFFD700)), onPressed: () {}),
        ],
      ),
      body: _tab == 0
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(_cats.length, (i) {
                    return TextButton(
                      onPressed: () => setState(() => _cat = i),
                      child: Text(
                        _cats[i],
                        style: TextStyle(
                          color: _cat == i ? const Color(0xFFFFD700) : Colors.grey,
                          fontWeight: _cat == i ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  }),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _hosts.length,
                    itemBuilder: (context, i) {
                      final h = _hosts[i];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (c) => LiveRoomScreen(host: h)));
                        },
                        child: ClipRRect(
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(h['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                    Text("ID: ${h['id']} • ${h['level']}", style: const TextStyle(color: Colors.grey, fontSize: 10)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
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

class LiveRoomScreen extends StatefulWidget {
  final Map<String, String> host;
  const LiveRoomScreen({super.key, required this.host});

  @override
  State<LiveRoomScreen> createState() => _LiveRoomScreenState();
}

class _LiveRoomScreenState extends State<LiveRoomScreen> {
  int _gems = 1200;
  final List<String> _msgs = ['Welcome to Live Room!', 'Rahul: Hi dear 💕'];

  void _openGifts() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF14141E),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Gems Balance: $_gems', style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _giftItem('Kiss', 180, Icons.favorite),
                  _giftItem('Rose', 99, Icons.local_florist),
                  _giftItem('Car', 999, Icons.directions_car),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _giftItem(String name, int cost, IconData icon) {
    return InkWell(
      onTap: () {
        if (_gems >= cost) {
          setState(() {
            _gems -= cost;
            _msgs.add('You sent $name 🎁');
          });
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Low balance!')));
        }
      },
      child: Column(
        children: [
          CircleAvatar(backgroundColor: const Color(0xFF1E1E2C), child: Icon(icon, color: const Color(0xFFFF2E93))),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 12)),
          Text('$cost', style: const TextStyle(color: Color(0xFFFFD700), fontSize: 11)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(child: Image.network(widget.host['img']!, fit: BoxFit.cover)),
          Positioned.fill(child: Container(color: Colors.black45)),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => Navigator.pop(context)),
                      CircleAvatar(radius: 16, backgroundImage: NetworkImage(widget.host['img']!)),
                      const SizedBox(width: 8),
                      Text(widget.host['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2E93)),
                        child: const Text('Follow'),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  height: 100,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    itemCount: _msgs.length,
                    itemBuilder: (c, i) => Text(_msgs[i], style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(hintText: 'Say hi...', hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.card_giftcard, color: Color(0xFFFFD700), size: 30),
                        onPressed: _openGifts,
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
