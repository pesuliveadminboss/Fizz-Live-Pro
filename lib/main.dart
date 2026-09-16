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

// 1. SPLASH SCREEN
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1200), () {
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
            Icon(Icons.videocam_rounded, size: 75, color: Color(0xFFFF2E93)),
            SizedBox(height: 16),
            Text('FIZZ LIVE PRO', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 3, color: Color(0xFFFFD700))),
          ],
        ),
      ),
    );
  }
}

// 2. ADMIN GATEWAY (PIN: 7777)
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
                style: const TextStyle(color: Color(0xFFFFD700), fontSize: 24, letterSpacing: 10),
                decoration: const InputDecoration(
                  counterText: "",
                  filled: true,
                  fillColor: Color(0xFF14141E),
                  hintText: "••••",
                  border: OutlineInputBorder(),
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
                  child: const Text('Unlock App', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 3. FAST LOGIN SCREEN
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
              const CircleAvatar(radius: 45, backgroundColor: Color(0xFF1E1E2C), child: Icon(Icons.person, size: 45, color: Colors.white)),
              const SizedBox(height: 16),
              const Text('Meet Real Friends Nearby', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Live video calls with beauties 24/7', style: TextStyle(color: Colors.grey, fontSize: 13)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
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
              const SizedBox(height: 12),
              const Text('By continuing, you agree to Terms & Privacy Policy', style: TextStyle(color: Colors.white38, fontSize: 11)),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

// 4. PERMISSIONS SCREEN
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
              const Text('Authorization Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              const Text('Allow permissions for 1-on-1 private video calls.', style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 24),
              const ListTile(
                leading: Icon(Icons.videocam, color: Color(0xFFFFD700), size: 28),
                title: Text('Camera', style: TextStyle(color: Colors.white)),
                subtitle: Text('For live streaming and video chat', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
              const ListTile(
                leading: Icon(Icons.mic, color: Color(0xFFFFD700), size: 28),
                title: Text('Microphone', style: TextStyle(color: Colors.white)),
                subtitle: Text('For high-definition voice talk', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => _requestAndContinue(context),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E5FF), foregroundColor: Colors.black),
                  child: const Text('Allow all permissions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 5. ZEGO RTC LIVE VIDEO CALL SCREEN
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
    await ZegoExpressEngine.instance.startPublishingStream('s_${user.userID}');
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

// 6. MAIN DASHBOARD (5 Bottom Tabs, Top Categories, Wallet & 6 Recharge Packs)
class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});
  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _currentTab = 0;
  int _categoryIndex = 0;
  int _userGems = 1670;
  int _selectedPack = 0;

  final List<String> _categories = const ['Popular', 'Nearby', 'New', 'Follow'];

  final List<Map<String, String>> _hosts = const [
    {'name': 'Pooja', 'age': '22', 'city': 'Mumbai', 'level': 'Lv.7'},
    {'name': 'Ananya', 'age': '21', 'city': 'Delhi', 'level': 'Lv.9'},
    {'name': 'Sneha', 'age': '23', 'city': 'Chennai', 'level': 'Lv.6'},
    {'name': 'Kavya', 'age': '20', 'city': 'Bangalore', 'level': 'Lv.8'},
    {'name': 'Riya', 'age': '24', 'city': 'Hyderabad', 'level': 'Lv.5'},
    {'name': 'Diya', 'age': '22', 'city': 'Kolkata', 'level': 'Lv.7'},
  ];

  final List<Map<String, dynamic>> _rechargePacks = const [
    {'gems': 4050, 'price': '100'},
    {'gems': 8100, 'price': '200'},
    {'gems': 16380, 'price': '400'},
    {'gems': 32940, 'price': '800'},
    {'gems': 66600, 'price': '1600'},
    {'gems': 167400, 'price': '4000'},
  ];

  void _showRechargeSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF14141E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Recharge Gems', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          const Icon(Icons.diamond, color: Color(0xFFFFD700), size: 18),
                          const SizedBox(width: 4),
                          Text('$_userGems', style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Make 1-on-1 private video calls with gems', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _rechargePacks.length,
                    itemBuilder: (context, i) {
                      final pack = _rechargePacks[i];
                      final isSelected = _selectedPack == i;
                      return GestureDetector(
                        onTap: () => setSheetState(() => _selectedPack = i),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF2A2035) : const Color(0xFF1E1E2C),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? const Color(0xFFFFD700) : Colors.white12,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.diamond, color: Color(0xFFFFD700), size: 24),
                              const SizedBox(height: 4),
                              Text('${pack['gems']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                              const SizedBox(height: 2),
                              Text('₹${pack['price']}', style: const TextStyle(color: Color(0xFFFF2E93), fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        final added = _rechargePacks[_selectedPack]['gems'] as int;
                        setState(() => _userGems += added);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added $added Gems successfully!'), backgroundColor: Colors.green),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF2E93),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Pay ₹${_rechargePacks[_selectedPack]['price']} & Add Gems',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
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
          builder: (_) => LiveCallScreen(hostName: name, roomID: 'room_${name.toLowerCase()}'),
        ),
      );
    } else {
      _showRechargeSheet();
    }
  }

  // TAB 0: FOR YOU
  Widget _buildForYouTab() {
    return Column(
      children: [
        Container(
          height: 42,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _categories.length,
            itemBuilder: (context, i) {
              final isSel = _categoryIndex == i;
              return GestureDetector(
                onTap: () => setState(() => _categoryIndex = i),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSel ? const Color(0xFFFF2E93) : const Color(0xFF14141E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      _categories[i],
                      style: TextStyle(
                        color: isSel ? Colors.white : Colors.grey,
                        fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.78,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10
