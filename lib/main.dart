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
              const CircleAvatar(radius: 45, backgroundColor: Color(0xFF1E1E2C), child: Icon(Icons.person, size: 45, color: Colors.white)),
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

  Future<void> _requestAndContinue(BuildContext context) async {
    await [Permission.camera, Permission.microphone].request();
    if (context.mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const MainDashboardScreen()));
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
                  onPressed: () => _requestAndContinue(context),
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
    _startZegoCall();
  }

  Future<void> _startZegoCall() async {
    const int appID = 710176630;
    const String appSign = '0b8b0f4adab85c101698f21f4e7c7b1aa477c901ac58d80a75e54c17ed05ad8a';

    await ZegoExpressEngine.createEngineWithProfile(ZegoEngineProfile(
      appID,
      ZegoScenario.StandardVideoCall,
      appSign: appSign,
    ));

    await ZegoExpressEngine.instance.createCanvasView((viewID) {
      _localViewID = viewID;
      ZegoExpressEngine.instance.startPreview(canvas: ZegoCanvas(viewID));
    }).then((widgetView) {
      setState(() {
        _localView = widgetView;
      });
    });

    final user = ZegoUser('user_${DateTime.now().millisecondsSinceEpoch % 10000}', 'GuestUser');
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
                        child: Text(
                          widget.hostName,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(12)),
                        child: const Text('LIVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
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
                      icon: const Icon(Icons.call_end, color: Colors.white, size: 30),
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
  int _selectedPack = 0;

  final List<String> _names = const ['Pooja', 'Ananya', 'Sneha', 'Kavya'];

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

  void _callHost(String name) {
    if (_userGems >= 1800) {
      setState(() => _userGems -= 1800);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (c) => LiveCallScreen(
            hostName: name,
            roomID: 'room_${name.toLowerCase()}',
          ),
        ),
      );
    } else {
      _showRechargeSheet();
    }
  }

  Widget _tabZero() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _names.length,
      itemBuilder: (context, i) {
        final n = _names[i];
        return Container(
          decoration: BoxDecoration(color: const Color(0xFF14141E), borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(radius: 35, backgroundColor: Color(0xFF1E1E2C), child: Icon(Icons.person, size: 40, color: Colors.white54)),
              const SizedBox(height: 8),
              Text(n, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('Online • LV7', style: TextStyle(color: Colors.greenAccent, fontSize: 11)),
              IconButton(
                icon: const Icon(Icons.video_call_rounded, color: Color(0xFFFF2E93), size: 28),
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
            leading: const CircleAvatar(backgroundColor: Color(0xFF1E1E2C), child: Icon(Icons.person, color: Colors.white54)),
            title: Text(n, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: const Text('Following • Active now', style: TextStyle(color: Colors.grey)),
            trailing: ElevatedButton(
              onPressed: () => _callHost(n),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2E93)),
              child: const Text('Call', style: TextStyle(fontSize: 12)),
            ),
          ),
        );
      },
    );
  }

  Widget _tabTwo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            color: const Color(0xFF14141E),
            child: ListTile(
              leading: const Icon(Icons.casino_rounded, color: Color(0xFFFFD700), size: 36),
              title: const Text('Lucky Wheel Spin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: const Text('Play with 100 gems & win gems', style: TextStyle(color: Colors.grey)),
              trailing: ElevatedButton(
                onPressed: () {
                  if (_userGems >= 100) {
                    setState(() => _userGems += 200);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Won 300 Gems!')));
                  } else {
                    _showRechargeSheet();
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700), foregroundColor: Colors.black),
                child: const Text('Play'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabThree() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: const [
        Card(
          color: Color(0xFF14141E),
          child: ListTile(
            leading: Icon(Icons.notifications, color: Color(0xFFFFD700)),
            title: Text('System Announcement', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text('Welcome to Fizz Live Pro!', style: TextStyle(color: Colors.grey)),
          ),
        ),
      ],
    );
  }

  Widget _tabFour() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const ListTile(
            leading: CircleAvatar(rad
