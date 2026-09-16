import 'dart:async';
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
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PinGate()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07070A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network('https://i.ibb.co/3k5fB0K/fizz-logo.png', errorBuilder: (c, e, s) => const Icon(Icons.videocam, size: 50, color: Colors.pink)),
              ),
            ),
            const SizedBox(height: 8),
            const Text('FIZZ LIVE PRO', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
            const Text('18+ Private Live Video Chat', style: TextStyle(fontSize: 11, color: Colors.white54)),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07070A),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Admin PIN (7777)', style: TextStyle(fontSize: 18, color: Colors.white)),
              const SizedBox(height: 10),
              TextField(controller: _c, keyboardType: TextInputType.number, obscureText: true, textAlign: TextAlign.center, style: const TextStyle(color: Colors.amber, fontSize: 22), decoration: const InputDecoration(filled: true, fillColor: Color(0xFF14141E), hintText: "••••")),
              const SizedBox(height: 10),
              ElevatedButton(onPressed: () { if (_c.text.trim() == "7777") Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Login())); }, child: const Text('Unlock')),
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
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await [Permission.camera, Permission.microphone].request();
            if (context.mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Dashboard()));
          },
          child: const Text('Fast Login & Permissions'),
        ),
      ),
    );
  }
}

class RandomMatchScreen extends StatefulWidget {
  final Function(String, String) onMatched;
  const RandomMatchScreen({super.key, required this.onMatched});
  @override
  State<RandomMatchScreen> createState() => _RandomMatchScreenState();
}

class _RandomMatchScreenState extends State<RandomMatchScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) widget.onMatched('Pooja', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200');
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
            CircularProgressIndicator(color: Colors.pink),
            SizedBox(height: 20),
            Text('Finding random host...', style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class CallScreen extends StatefulWidget {
  final String host, pic;
  final int gems;
  final Function(int) onGems;
  final Function(String, int) onEnd;
  const CallScreen({super.key, required this.host, required this.pic, required this.gems, required this.onGems, required this.onEnd});
  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  Widget? _cam;
  int? _vid;
  late int _g;
  String _gift = "";
  bool _mic = true, _glow = false, _frontCam = true;
  int _sec = 0;
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _g = widget.gems;
    _initZego();
    _t = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _sec++);
      if (_sec > 0 && _sec % 60 == 0) {
        if (_g >= 1800) {
          setState(() => _g -= 1800);
          widget.onGems(_g);
        } else {
          _exitCall();
        }
      }
    });
  }

  void _exitCall() {
    _t?.cancel();
    final dur = '${_sec ~/ 60}:${(_sec % 60).toString().padLeft(2, '0')}';
    Navigator.pop(context);
    widget.onEnd(dur, _sec);
  }

  Future<void> _initZego() async {
    await ZegoExpressEngine.createEngineWithProfile(ZegoEngineProfile(710176630, ZegoScenario.StandardVideoCall, appSign: '0b8b0f4adab85c101698f21f4e7c7b1aa477c901ac58d80a75e54c17ed05ad8a'));
    await ZegoExpressEngine.instance.enableCamera(true);
    await ZegoExpressEngine.instance.useFrontCamera(true);
    final w = await ZegoExpressEngine.instance.createCanvasView((id) {
      _vid = id;
      ZegoExpressEngine.instance.startPreview(canvas: ZegoCanvas(id));
    });
    if (mounted) setState(() => _cam = w);
  }

  @override
  void dispose() {
    _t?.cancel();
    if (_vid != null) ZegoExpressEngine.instance.destroyCanvasView(_vid!);
    ZegoExpressEngine.instance.stopPreview();
    ZegoExpressEngine.destroyEngine();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(child: Container(decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(widget.pic), fit: BoxFit.cover)))),
          Positioned(top: 40, right: 16, width: 85, height: 115, child: ClipRRect(borderRadius: BorderRadius.circular(8), child: _cam ?? const CircularProgressIndicator())),
          Positioned(bottom: 20, left: 0, right: 0, child: Center(child: IconButton(icon: const Icon(Icons.call_end, color: Colors.red, size: 40), onPressed: _exitCall))),
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

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  int _gems = 1670;
  final List<String> _history = ['Recharge: +4050 Gems'];
  final List<Map<String, String>> _favorites = [];

  final _allHosts = const [
    {'name': 'Pooja', 'city': 'Mumbai', 'views': '3.2k', 'pic': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200'},
    {'name': 'Ananya', 'city': 'Delhi', 'views': '5.1k', 'pic': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200'},
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  void _dial(String n, String p) {
    if (_gems >= 1800) {
      setState(() {
        _gems -= 1800;
        _history.insert(0, 'Call with $n: -1800 Gems');
      });
      Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen(host: n, pic: p, gems: _gems, onGems: (g) => setState(() => _gems = g), onEnd: (d, s) {})));
    } else {
      setState(() => _gems += 4050);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07070A),
      appBar: AppBar(
        title: const Text('Fizz Live Pro'),
        actions: [TextButton(onPressed: () => setState(() => _gems += 4050), child: Text('💎 $_gems', style: const TextStyle(color: Colors.amber)))],
        bottom: TabBar(controller: _tabCtrl, indicatorColor: Colors.pink, labelColor: Colors.pink, unselectedLabelColor: Colors.grey, tabs: const [Tab(icon: Icon(Icons.home)), Tab(icon: Icon(Icons.favorite)), Tab(icon: Icon(Icons.person))]),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(6),
            children: [
              for (var h in _allHosts)
                Card(
                  color: const Color(0xFF14141E),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(radius: 24, backgroundImage: NetworkImage(h['pic']!)),
                      Text(h['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ElevatedButton(onPressed: () => _dial(h['name']!, h['pic']!), child: const Text('Call')),
                    ],
                  ),
                ),
            ],
          ),
          _favorites.isEmpty ? const Center(child: Text('No Favorites yet!', style: TextStyle(color: Colors.grey))) : ListView(children: [for (var h in _favorites) ListTile(title: Text(h['name']!))]),
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Center(child: Column(children: [CircleAvatar(radius: 30, child: Icon(Icons.person)), SizedBox(height: 6), Text('User7789', style: TextStyle(color: Colors.white, fontSize: 16)), Text('👑 VIP Lv.5', style: TextStyle(color: Colors.amber))])),
              const SizedBox(height: 20),
              const Text('Wallet History:', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
              for (var item in _history) ListTile(title: Text(item, style: const TextStyle(color: Colors.white))),
            ],
          ),
        ],
      ),
    );
  }
}
