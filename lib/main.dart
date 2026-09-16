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
    Future.delayed(const Duration(milliseconds: 1000), () {
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
            Text('FIZZ LIVE PRO', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFFD700))),
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
        MaterialPageRoute(builder: (_) => const AuthorizationScreen()),
      );
    } else {
      setState(() => _err = "Invalid PIN!");
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
              const Icon(Icons.admin_panel_settings, size: 60, color: Color(0xFFFFD700)),
              const SizedBox(height: 12),
              const Text('Admin PIN (7777)', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: _pin,
                keyboardType: TextInputType.number,
                obscureText: true,
                textAlign: TextAlign.center,
                maxLength: 4,
                style: const TextStyle(color: Color(0xFFFFD700), fontSize: 24),
                decoration: const InputDecoration(
                  counterText: "",
                  filled: true,
                  fillColor: Color(0xFF14141E),
                  border: OutlineInputBorder(),
                ),
              ),
              if (_err.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_err, style: const TextStyle(color: Colors.redAccent))),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _checkPin,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700), foregroundColor: Colors.black),
                child: const Text('Unlock Fizz Live Pro'),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.security, size: 60, color: Color(0xFF00E5FF)),
              const SizedBox(height: 12),
              const Text('Permissions Required', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Allow Camera & Mic to start 1-on-1 calls.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _requestAndContinue(context),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E5FF), foregroundColor: Colors.black),
                child: const Text('Allow permissions'),
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
    _startCall();
  }

  Future<void> _startCall() async {
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

    final user = ZegoUser('u_${DateTime.now().millisecondsSinceEpoch % 10000}', 'Guest');
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
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
                        child: Text(widget.hostName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      const Chip(label: Text('LIVE', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.red,
                    child: IconButton(
                      icon: const Icon(Icons.call_end, color: Colors.white),
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
  int _gems = 1670;

  final List<String> _hosts = const ['Pooja', 'Ananya', 'Sneha', 'Kavya'];

  final List<Map<String, dynamic>> _packs = const [
    {'gems': 4050, 'price': 100},
    {'gems': 8100, 'price': 200},
    {'gems': 16380, 'price': 400},
    {'gems': 32940, 'price': 800},
    {'gems': 66600, 'price': 1600},
    {'gems': 167400, 'price': 4000},
  ];

  void _openRecharge() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF14141E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Purchase Gems', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ..._packs.map((p) {
                return Card(
                  color: const Color(0xFF1E1E2C),
                  child: ListTile(
                    leading: const Icon(Icons.diamond, color: Color(0xFFFFD700)),
                    title: Text('${p['gems']} Gems', style: const TextStyle(color: Colors.white)),
                    trailing: ElevatedButton(
                      onPressed: () {
                        setState(() => _gems += (p['gems'] as int));
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added ${p['gems']} Gems!'), backgroundColor: Colors.green),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2E93)),
                      child: Text('₹${p['price']}', style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _call(String name) {
    if (_gems >= 1800) {
      setState(() => _gems -= 1800);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LiveCallScreen(hostName: name, roomID: 'room_${name.toLowerCase()}')),
      );
    } else {
      _openRecharge();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_tab == 0) {
      content = GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _hosts.length,
        itemBuilder: (ctx, i) {
          final n = _hosts[i];
          return Container(
            decoration: BoxDecoration(color: const Color(0xFF14141E), borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(radius: 28, backgroundColor: Color(0xFF1E1E2C), child: Icon(Icons.person, color: Colors.white)),
                const SizedBox(height: 6),
                Text(n, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.video_call, color: Color(0xFFFF2E93), size: 28),
                  onPressed: () => _call(n),
                ),
              ],
            ),
          );
        },
      );
    } else if (_tab == 1) {
      content = Center(
        child: ElevatedButton(
          onPressed: () {
            setState(() => _gems += 100);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Won 100 Gems!')));
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700), foregroundColor: Colors.black),
          child: const Text('Play Spin & Win 100 Gems'),
        ),
      );
    } else {
      content = Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Card(
              color: Color(0xFF14141E),
              child: ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text('User ID: 207183', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: const Color(0xFF14141E),
              child: ListTile(
                title: const Text('Total Gems', style: TextStyle(color: Colors.white)),
                trailing: Text('$_gems', style: const TextStyle(color: Color(0xFFFFD700), fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                onPressed: _openRecharge,
                icon: const Icon(Icons.diamond, color: Colors.black),
                label: const Text('Buy / Recharge Gems', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700)),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF07070A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101016),
        title: const Text('Fizz Live Pro', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          TextButton.icon(
            onPressed: _openRecharge,
            icon: const Icon(Icons.diamond, color: Color(0xFFFFD700), size: 18),
            label: Text('$_gems', style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: content,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        backgroundColor: const Color(0xFF0E0E14),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.video_camera_front), label: 'Live Hosts'),
          BottomNavigationBarItem(icon: Icon(Icons.casino), label: 'Games'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile & Wallet'),
        ],
      ),
    );
  }
}
