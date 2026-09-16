import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Splash()));
}

class Splash extends StatefulWidget {
  const Splash({super.key});
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PinGate()));
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
            Icon(Icons.videocam, size: 75, color: Color(0xFFFF2E93)),
            SizedBox(height: 16),
            Text('FIZZ LIVE PRO', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 3, color: Color(0xFFFFD700))),
          ],
        ),
      ),
    );
  }
}

class PinGate extends StatefulWidget {
  const PinGate({super.key});
  @override
  State<PinGate> createState() => _PinGateState();
}

class _PinGateState extends State<PinGate> {
  final _c = TextEditingController();
  String _msg = "";
  void _check() {
    if (_c.text.trim() == "7777") {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Login()));
    } else {
      setState(() => _msg = "Invalid PIN!");
      _c.clear();
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
              const SizedBox(height: 16),
              const Text('Admin Verification (7777)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              TextField(
                controller: _c,
                keyboardType: TextInputType.number,
                obscureText: true,
                textAlign: TextAlign.center,
                maxLength: 4,
                style: const TextStyle(color: Color(0xFFFFD700), fontSize: 24, letterSpacing: 8),
                decoration: const InputDecoration(counterText: "", filled: true, fillColor: Color(0xFF14141E), hintText: "••••", border: OutlineInputBorder()),
              ),
              if (_msg.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_msg, style: const TextStyle(color: Colors.redAccent))),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _check,
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

class Login extends StatelessWidget {
  const Login({super.key});
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
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Perms())),
                  child: const Text('Fast Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Agree to Terms & Privacy Policy', style: TextStyle(color: Colors.white38, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}

class Perms extends StatelessWidget {
  const Perms({super.key});
  Future<void> _ask(BuildContext context) async {
    await [Permission.camera, Permission.microphone].request();
    if (context.mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Dashboard()));
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
              const Text('Authorization', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              const Text('Allow Camera & Mic for 1-on-1 calls.', style: TextStyle(color: Colors.grey)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => _ask(context),
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

class CallScreen extends StatefulWidget {
  final String host;
  final String room;
  const CallScreen({super.key, required this.host, required this.room});
  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  Widget? _v;
  int? _vid;
  @override
  void initState() {
    super.initState();
    _start();
  }
  Future<void> _start() async {
    const appID = 710176630;
    const appSign = '0b8b0f4adab85c101698f21f4e7c7b1aa477c901ac58d80a75e54c17ed05ad8a';
    await ZegoExpressEngine.createEngineWithProfile(ZegoEngineProfile(appID, ZegoScenario.StandardVideoCall, appSign: appSign));
    await ZegoExpressEngine.instance.createCanvasView((id) {
      _vid = id;
      ZegoExpressEngine.instance.startPreview(canvas: ZegoCanvas(id));
    }).then((w) => setState(() => _v = w));
    final u = ZegoUser('u_${DateTime.now().millisecondsSinceEpoch % 10000}', 'Guest');
    await ZegoExpressEngine.instance.loginRoom(widget.room, u);
    await ZegoExpressEngine.instance.startPublishingStream('s_${u.userID}');
  }
  @override
  void dispose() {
    if (_vid != null) ZegoExpressEngine.instance.destroyCanvasView(_vid!);
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
          Positioned.fill(child: _v ?? const Center(child: CircularProgressIndicator(color: Color(0xFFFF2E93)))),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)), child: Text(widget.host, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      const Chip(label: Text('LIVE', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: CircleAvatar(radius: 30, backgroundColor: Colors.red, child: IconButton(icon: const Icon(Icons.call_end, color: Colors.white), onPressed: () => Navigator.pop(context))),
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
  int _tab = 0;
  int _cat = 0;
  int _gems = 1670;

  final _cats = const ['Popular', 'Nearby', 'New', 'Follow'];
  final _hosts = const [
    {'name': 'Pooja', 'city': 'Mumbai', 'lvl': 'Lv.7'},
    {'name': 'Ananya', 'city': 'Delhi', 'lvl': 'Lv.9'},
    {'name': 'Sneha', 'city': 'Chennai', 'lvl': 'Lv.6'},
    {'name': 'Kavya', 'city': 'Bangalore', 'lvl': 'Lv.8'},
  ];

  final _packs = const [
    {'gems': 4050, 'price': 100},
    {'gems': 8100, 'price': 200},
    {'gems': 16380, 'price': 400},
    {'gems': 32940, 'price': 800},
    {'gems': 66600, 'price': 1600},
    {'gems': 167400, 'price': 4000},
  ];

  void _showRecharge() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF14141E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recharge Gems', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('My Gems: $_gems', style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              for (var p in _packs)
                Card(
                  color: const Color(0xFF1E1E2C),
                  child: ListTile(
                    leading: const Icon(Icons.diamond, color: Color(0xFFFFD700)),
                    title: Text('${p['gems']} Gems', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    trailing: ElevatedButton(
                      onPressed: () {
                        setState(() => _gems += (p['gems'] as int));
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added ${p['gems']} Gems!'), backgroundColor: Colors.green));
                      },
                      child: Text('₹${p['price']}'),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _dial(String name) {
    if (_gems >= 1800) {
      setState(() => _gems -= 1800);
      Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen(host: name, room: 'room_${name.toLowerCase()}')));
    } else {
      _showRecharge();
    }
  }

  Widget _buildBody() {
    if (_tab == 0) {
      return Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _cats.length,
              itemBuilder: (ctx, i) {
                final sel = _cat == i;
                return GestureDetector(
                  onTap: () => setState(() => _cat = i),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(color: sel ? const Color(0xFFFF2E93) : const Color(0xFF14141E), borderRadius: BorderRadius.circular(16)),
                    alignment: Alignment.center,
                    child: Text(_cats[i], style: TextStyle(color: sel ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.82,
              padding: const EdgeInsets.all(10),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                for (var h in _hosts)
                  Container(
                    decoration: BoxDecoration(color: const Color(0xFF14141E), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(radius: 32, backgroundColor: Color(0xFF1E1E2C), child: Icon(Icons.person, size: 36, color: Colors.white)),
                        const SizedBox(height: 6),
                        Text(h['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text('${h['city']} • ${h['lvl']}', style: const TextStyle(color: Colors.white54, fontSize: 11)),
                        const SizedBox(height: 6),
                        ElevatedButton.icon(
                          onPressed: () => _dial(h['name']!),
                          icon: const Icon(Icons.video_call, size: 16),
                          label: const Text('Call', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    } else if (_tab == 1) {
      return ListView(
        padding: const EdgeInsets.all(12),
        children: [
          for (var h in _hosts)
            Card(
              color: const Color(0xFF14141E),
              child: ListTile(
                leading: const CircleAvatar(backgroundColor: Color(0xFF1E1E2C), child: Icon(Icons.person, color: Colors.white)),
                title: Text(h['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text('${h['city']} • Online now', style: const TextStyle(color: Colors.greenAccent, fontSize: 12)),
                trailing: ElevatedButton(onPressed: () => _dial(h['name']!), child: const Text('Call')),
              ),
            ),
        ],
      );
    } else if (_tab == 2) {
      return Center(
        child: Card(
          color: const Color(0xFF14141E),
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.casino, size: 60, color: Color(0xFFFFD700)),
                const SizedBox(height: 12),
                const Text('Lucky Wheel Spin', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                const Text('Spin and win bonus gems', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() => _gems += 150);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Won 150 Gems!'), backgroundColor: Colors.green));
                  },
                  child: const Text('Play Spin', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (_tab == 3) {
      return ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          Card(
            color: Color(0xFF14141E),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Color(0xFFFF2E93), child: Icon(Icons.notifications, color: Colors.white)),
              title: Text('System Message', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Text('Welcome to Fizz Live Pro! Start live calling now.', style: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFF14141E), borderRadius: BorderRadius.circular(12)),
              child: const Row(
                children: [
                  CircleAvatar(radius: 28, backgroundColor: Color(0xFF1E1E2C), child: Icon(Icons.person, size: 32, color: Colors.white)),
                  SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pesulive User', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('ID: 207183 • Lv.4 VIP', style: TextStyle(color: Color(0xFFFFD700), fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFF14141E), borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('My Gems Balance', style: TextStyle(color: Colors.white, fontSize: 15)),
                  Text('$_gems', style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _showRecharge,
                icon: const Icon(Icons.diamond),
                label: const Text('Recharge / Buy Gems', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07070A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101016),
        title: const Text('Fizz Live Pro', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          GestureDetector(
            onTap: _showRecharge,
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: const Color(0xFF1E1E2C), borderRadius: BorderRadius.circular(14)),
              child: Row(
                children: [
                  const Icon(Icons.diamond, color: Color(0xFFFFD700), size: 16),
                  const SizedBox(width: 4),
                  Text('$_gems', style: const TextStyle(color: Color(0xFFFFD700), font
