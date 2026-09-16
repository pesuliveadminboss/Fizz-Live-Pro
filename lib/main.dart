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
            const Text('18+ Private Video Chat', style: TextStyle(fontSize: 11, color: Colors.white54)),
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
          child: const Text('Fast Login'),
        ),
      ),
    );
  }
}

class LiveStreamRoom extends StatefulWidget {
  final Map<String, String> host;
  final int gems;
  final Function(int) onGems;
  final VoidCallback onCall;
  const LiveStreamRoom({super.key, required this.host, required this.gems, required this.onGems, required this.onCall});
  @override
  State<LiveStreamRoom> createState() => _LiveStreamRoomState();
}

class _LiveStreamRoomState extends State<LiveStreamRoom> {
  late int _g;
  String _gift = "";
  int _likes = 120;

  @override
  void initState() {
    super.initState();
    _g = widget.gems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => setState(() => _likes++),
        child: Stack(
          children: [
            Positioned.fill(child: Image.network(widget.host['pic']!, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.grey[900]))),
            Container(color: Colors.black38),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(radius: 16, backgroundImage: NetworkImage(widget.host['pic']!)),
                        const SizedBox(width: 8),
                        Text('${widget.host['name']} (❤️ $_likes)', style: const TextStyle(color: Colors.white)),
                        const Spacer(),
                        IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
                      ],
                    ),
                  ),
                  if (_gift.isNotEmpty) Container(padding: const EdgeInsets.all(6), color: Colors.pink, child: Text(_gift, style: const TextStyle(color: Colors.white))),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Expanded(child: Text('Tap screen to like ❤️', style: TextStyle(color: Colors.white70))),
                        ElevatedButton(onPressed: widget.onCall, child: const Text('Call')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CallScreen extends StatefulWidget {
  final String host;
  final String pic;
  final int gems;
  final Function(int) onGems;
  final Function(String, int) onCallEnd;
  const CallScreen({super.key, required this.host, required this.pic, required this.gems, required this.onGems, required this.onCallEnd});
  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  Widget? _camView;
  int? _viewID;
  late int _g;
  String _gift = "";
  bool _mic = true;
  bool _glow = false;
  bool _frontCam = true;
  int _sec = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _g = widget.gems;
    _initZego();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _sec++);
      if (_sec > 0 && _sec % 60 == 0) {
        if (_g >= 1800) {
          setState(() => _g -= 1800);
          widget.onGems(_g);
        } else {
          _closeCall();
        }
      }
    });
  }

  void _closeCall() {
    _timer?.cancel();
    final dur = '${_sec ~/ 60}:${(_sec % 60).toString().padLeft(2, '0')}';
    Navigator.pop(context);
    widget.onCallEnd(dur, _sec);
  }

  Future<void> _initZego() async {
    await [Permission.camera, Permission.microphone].request();
    await ZegoExpressEngine.createEngineWithProfile(ZegoEngineProfile(710176630, ZegoScenario.StandardVideoCall, appSign: '0b8b0f4adab85c101698f21f4e7c7b1aa477c901ac58d80a75e54c17ed05ad8a'));
    await ZegoExpressEngine.instance.enableCamera(true);
    await ZegoExpressEngine.instance.useFrontCamera(true);
    final w = await ZegoExpressEngine.instance.createCanvasView((id) {
      _viewID = id;
      ZegoExpressEngine.instance.startPreview(canvas: ZegoCanvas(id));
    });
    if (mounted) setState(() => _camView = w);
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (_viewID != null) ZegoExpressEngine.instance.destroyCanvasView(_viewID!);
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
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(widget.pic), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withOpacity(_glow ? 0.3 : 0.5), BlendMode.darken))),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(radius: 40, backgroundImage: NetworkImage(widget.pic)),
                    const SizedBox(height: 8),
                    Text(widget.host, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('${_sec ~/ 60}:${(_sec % 60).toString().padLeft(2, '0')}', style: const TextStyle(color: Colors.greenAccent, fontSize: 14)),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 40, right: 16, width: 85, height: 115,
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.pink, width: 2), borderRadius: BorderRadius.circular(8)),
              child: ClipRRect(borderRadius: BorderRadius.circular(6), child: _camView ?? const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.pink))),
            ),
          ),
          Positioned(
            bottom: 20, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(icon: Icon(_mic ? Icons.mic : Icons.mic_off, color: Colors.white), onPressed: () => setState(() => _mic = !_mic)),
                IconButton(icon: const Icon(Icons.flip_camera_ios, color: Colors.white), onPressed: () => ZegoExpressEngine.instance.useFrontCamera(_frontCam = !_frontCam)),
                IconButton(icon: Icon(Icons.auto_awesome, color: _glow ? Colors.amber : Colors.white), onPressed: () => setState(() => _glow = !_glow)),
                IconButton(icon: const Icon(Icons.call_end, color: Colors.red, size: 34), onPressed: _closeCall),
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

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  int _gems = 1670;

  final _hosts = const [
    {'name': 'Pooja', 'views': '3.2k', 'pic': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200'},
    {'name': 'Ananya', 'views': '5.1k', 'pic': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200'},
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  void _showSummary(String host, String dur) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF14141E),
        title: Text('Call Ended with $host', style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Duration: $dur', style: const TextStyle(color: Colors.greenAccent)),
            const SizedBox(height: 6),
            const Text('Rating: ⭐⭐⭐⭐⭐', style: TextStyle(fontSize: 16)),
          ],
        ),
        actions: [ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
      ),
    );
  }

  void _dial(String name, String pic) {
    if (_gems >= 1800) {
      setState(() => _gems -= 1800);
      Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen(host: name, pic: pic, gems: _gems, onGems: (g) => setState(() => _gems = g), onCallEnd: (d, s) => _showSummary(name, d))));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not enough gems!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07070A),
      appBar: AppBar(
        title: const Text('Fizz Live Pro'),
        actions: [TextButton(onPressed: () => setState(() => _gems += 4050), child: Text('💎 $_gems', style: const TextStyle(color: Colors.amber)))],
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: Colors.pink,
          labelColor: Colors.pink,
          unselectedLabelColor: Colors.grey,
          tabs: const [Tab(icon: Icon(Icons.home)), Tab(icon: Icon(Icons.chat)), Tab(icon: Icon(Icons.person))],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(6),
            children: [
              for (var h in _hosts)
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
          ListView(children: [for (var h in _hosts) ListTile(leading: CircleAvatar(backgroundImage: NetworkImage(h['pic']!)), title: Text(h['name']!, style: const TextStyle(color: Colors.white)), onTap: () => _dial(h['name']!, h['pic']!))]),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(radius: 34, child: Icon(Icons.person)),
                const SizedBox(height: 6),
                const Text('User7789', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const Text('👑 VIP Lv.5', style: TextStyle(color: Colors.amber)),
                const SizedBox(height: 6),
                Text('Gems: $_gems', style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
