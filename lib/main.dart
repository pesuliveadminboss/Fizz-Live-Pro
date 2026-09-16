import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminGatewayScreen()),
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
            Text(
              'FIZZ LIVE PRO',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                color: Color(0xFFFFD700),
              ),
            ),
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
        MaterialPageRoute(builder: (_) => const LoginScreen()),
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
              if (_err.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(_err, style: const TextStyle(color: Colors.redAccent)),
                ),
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
            children: [
              const Spacer(),
              const CircleAvatar(radius: 40, backgroundColor: Color(0xFF1E1E2C), child: Icon(Icons.person, size: 40, color: Colors.white)),
              const SizedBox(height: 12),
              const Text('Meet Real Friends Nearby', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const AuthorizationScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2E93)),
                  child: const Text('Fast Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthorizationScreen extends StatelessWidget {
  const AuthorizationScreen({super.key});

  Future<void> _requestAndContinue(BuildContext context) async {
    await [Permission.camera, Permission.microphone].request();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainDashboardScreen()),
      );
    }
  }

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
              const Text('Permissions Required', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              const Text('Allow Camera & Mic for 1-on-1 calls.', style: TextStyle(color: Colors.grey)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => _requestAndContinue(context),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E5FF), foregroundColor: Colors.black),
                  child: const Text('Allow permissions', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LiveCallScreen extends StatefulWidget {
  final String hostName;
  final String roomID;
  const LiveCallScreen({super.key, required this.hostName, required this.roomID});

  @override
  State<LiveCallScreen> createState() => _LiveCallScreenState();
}

class _LiveCallScreenState extends State<LiveCallScreen> {
  Widget? _localView;
  int? _localViewID;

  @override
  void initState() {
    super.initState();
    _startZego();
  }

  Future<void> _startZego() async {
    const int appID = 710176630;
    const String appSign = '0b8b0f4adab85c101698f21f4e7c7b1aa477c901ac58d80a75e54c17ed05ad8a';

    await ZegoExpressEngine.createEngineWithProfile(
      ZegoEngineProfile(appID, ZegoScenario.StandardVideoCall, appSign: appSign),
    );

    await ZegoExpressEngine.instance.createCanvasView((viewID) {
      _localViewID = viewID;
      ZegoExpressEngine.instance.startPreview(canvas: ZegoCanvas(viewID));
    }).then((widgetView) {
      setState(() => _localView = widgetView);
    });

    final user = ZegoUser('user_${DateTime.now().millisecondsSinceEpoch % 10000}', 'Guest');
    await ZegoExpressEngine.instance.loginRoom(widget.roomID, user);
    await ZegoExpressEngine.instance.startPublishingStream('stream_${user.userID}');
  }

  @override
  void dispose() {
    if (_localViewID != null) {
      ZegoExpressEngine.instance.destroyCanvasView(_localViewID!);
    }
    ZegoExpressEngine.instance.stopPreview();
    ZegoExpressEngine.instance.logoutRoom();
    ZegoExpressEngine.destroyEngine();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: _localView ?? const Center(child: CircularProgressIndicator(color: Color(0xFFFF2E93))),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(16)),
                        child: Text(widget.hostName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(12)),
                        child: const Text('LIVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.red,
                    child: IconButton(
                      icon: const Icon(Icons.call_end, color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
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
  final List<String> _names = const ['Pooja', 'Ananya', 'Sneha', 'Kavya'];

  void _showRechargeSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add Gems for Calling', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  setState(() => _userGems += 4050);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFBA28A9)),
                child: const Text('Get 4,050 Gems (₹100)', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _callHost(String name) {
    if (_userGems >= 1800) {
      setState(() => _userGems -= 1800);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => LiveCallScreen(hostName: name, roomID: 'room_${name.toLowerCase()}'),
        ),
      );
    } else {
      _showRechargeSheet();
    }
  }

  Widget _tabZero() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _names.length,
      itemBuilder: (context, i) {
        final n = _names[i];
        return Container(
          decoration: BoxDecoration(color: const Color(0xFF14141E), borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(radius: 30, backgroundColor: Color(0xFF1E1E2C), child: Icon(Icons.person, color: Colors.white)),
              const SizedBox(height: 8),
              Text(n, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              IconButton(
                icon: const Icon(Icons.video_call_rounded, color: Color(0xFFFF2E93), size: 30),
                onPressed: () => _callHost(n),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tabOne() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _names.length,
      itemBuilder: (context, i) {
        final n = _names[i];
        return Card(
          color: const Color(0xFF14141E),
          child: ListTile(
            leading: const CircleAvatar(backgroundColor: Color(0xFF1E1E2C), child: Icon(Icons.person, color: Colors.white)),
            title: Text(n, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            trailing: ElevatedButton(
              onPressed: () => _callHost(n),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2E93)),
              child: const Text('Call', style: TextStyle(color: Colors.white)),
            ),
          ),
        );
      },
    );
  }

  Widget _tabTwo() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          setState(() => _userGems += 100);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Free 100 Gems Claimed!')));
        },
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700), foregroundColor: Colors.black),
        child: const Text('Spin & Win Gems'),
      ),
    );
  }

  Widget _tabThree() {
    return const Center(
      child: Text('Welcome to Fizz Live Messages', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _tabFour() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const ListTile(
            leading: CircleAvatar(backgroundColor: Color(0xFF1E1E2C), child: Icon(Icons.person, color: Colors.white)),
            title: Text('Pesulive User', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text('ID: 207183', style: TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 12),
          Card(
            color: const Color(0xFF14141E),
            child: ListTile(
              title: const Text('My Gems', style: TextStyle(color: Colors.white)),
              trailing: Text('$_userGems', style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold, fontSize: 16)),
              onTap: _showRechargeSheet,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget pageBody;
    if (_tab == 0) pageBody = _tabZero();
    else if (_tab == 1) pageBody = _tabOne();
    else if (_tab == 2) pageBody = _tabTwo();
    else if (_tab == 3) pageBody = _tabThree();
    else pageBody = _tabFour();

    return Scaffold(
      backgroundColor: const Color(0xFF07070A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101016),
        title: const Text('Fizz Live Pro', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          GestureDetector(
            onTap: _showRechargeSheet,
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFF1E1E2C), borderRadius: BorderRadius.circular(14)),
              child: Row(
                children: [
                  const Icon(Icons.diamond, color: Color(0xFFFFD700), size: 16),
                  const SizedBox(width: 4),
                  Text('$_userGems', style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
      body: pageBody,
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

