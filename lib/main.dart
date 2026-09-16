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
  bool _mic = true;
  bool _glow = false;
  bool _frontCam = true;
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

  void _sendGift(String name, int cost, String em) {
    if (_g >= cost) {
      setState(() {
        _g -= cost;
        _gift = "Sent $em $name!";
      });
      widget.onGems(_g);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _gift = "");
      });
    }
  }

  void _showGiftBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF14141E),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(onPressed: () { Navigator.pop(ctx); _sendGift('Rose', 50, '🌹'); }, child: const Text('🌹 50')),
            ElevatedButton(onPressed: () { Navigator.pop(ctx); _sendGift('Ring', 200, '💎'); }, child: const Text('💎 200')),
            ElevatedButton(onPressed: () { Navigator.pop(ctx); _sendGift('Car', 1000, '🏎️'); }, child: const Text('🏎️ 1000')),
          ],
        ),
      ),
    );
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
                    Text('${_sec ~/ 60}:${(_sec % 60).toString().padLeft(2, '0')}', style: const TextStyle(color: Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.bold)),
                    if (_g < 1800) const Text('⚠️ Low Gems!', style: TextStyle(color: Colors.orangeAccent, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
          Positioned(top: 40, right: 16, width: 85, height: 115, child: ClipRRect(borderRadius: BorderRadius.circular(8), child: _cam ?? const CircularProgressIndicator())),
          if (_gift.isNotEmpty) Positioned(top: 100, left: 20, child: Container(padding: const EdgeInsets.all(6), color: Colors.pink, child: Text(_gift, style: const TextStyle(color: Colors.white)))),
          Positioned(
            bottom: 20, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(icon: Icon(_mic ? Icons.mic : Icons.mic_off, color: Colors.white), onPressed: () => setState(() => _mic = !_mic)),
                IconButton(icon: const Icon(Icons.flip_camera_ios, color: Colors.white), onPressed: () => ZegoExpressEngine.instance.useFrontCamera(_frontCam = !_frontCam)),
                IconButton(icon: Icon(Icons.auto_awesome, color: _glow ? Colors.amber : Colors.white), onPressed: () => setState(() => _glow = !_glow)),
                IconButton(icon: const Icon(Icons.card_giftcard, color: Colors.amber, size: 32), onPressed: _showGiftBottomSheet),
                IconButton(icon: const Icon(Icons.call_end, color: Colors.red, size: 36), onPressed: _exitCall),
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
  int _cat = 0;
  int _gems = 1670;
  final List<String> _history = ['Recharge: +4050 Gems', 'Video Call: -1800 Gems'];

  final _cats = const ['Popular', 'Hot Live', 'Party Match', 'Nearby'];
  final _allHosts = const [
    {'name': 'Pooja', 'city': 'Mumbai', 'views': '3.2k', 'cat': 'Popular', 'pic': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200', 'bio': 'Professional model & live streamer ❤️'},
    {'name': 'Ananya', 'city': 'Delhi', 'views': '5.1k', 'cat': 'Hot Live', 'pic': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200', 'bio': 'Dance lover & friendly host ✨'},
  ];

  final _packs = const [
    {'gems': 4050, 'price': 100},
    {'gems': 8100, 'price': 200},
    {'gems': 16380, 'price': 400},
    {'gems': 32940, 'price': 800},
    {'gems': 66600, 'price': 1600},
    {'gems': 167400, 'price': 4000},
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 5, vsync: this);
  }

  void _showHostProfile(Map<String, String> h) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF14141E),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 35, backgroundImage: NetworkImage(h['pic']!)),
            const SizedBox(height: 8),
            Text(h['name']!, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            Text('${h['city']} • 🔴 LIVE', style: const TextStyle(color: Colors.greenAccent, fontSize: 12)),
            const SizedBox(height: 8),
            Text(h['bio']!, style: const TextStyle(color: Colors.white70, fontSize: 13), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(onPressed: () { Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Following Host!'))); }, icon: const Icon(Icons.favorite, color: Colors.pink), label: const Text('Follow', style: TextStyle(color: Colors.white))),
                ElevatedButton.icon(onPressed: () { Navigator.pop(ctx); _dial(h['name']!, h['pic']!); }, icon: const Icon(Icons.videocam), label: const Text('Direct Call (1800)'), style: ElevatedButton.styleFrom(backgroundColor: Colors.pink)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _recharge() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF14141E),
      builder: (ctx) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('My Gems: $_gems', style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (var p in _packs)
            ListTile(
              leading: const Icon(Icons.diamond, color: Colors.amber),
              title: Text('${p['gems']} Gems', style: const TextStyle(color: Colors.white)),
              trailing: ElevatedButton(onPressed: () {
                setState(() {
                  _gems += (p['gems'] as int);
                  _history.insert(0, 'Recharge: +${p['gems']} Gems');
                });
                Navigator.pop(ctx);
              }, child: Text('₹${p['price']}')),
            ),
        ],
      ),
    );
  }

  void _dial(String n, String p) {
    if (_gems >= 1800) {
      setState(() {
        _gems -= 1800;
        _history.insert(0, 'Video Call with $n: -1800 Gems');
      });
      Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen(host: n, pic: p, gems: _gems, onGems: (g) => setState(() => _gems = g), onEnd: (d, s) {})));
    } else {
      _recharge();
    }
  }

  @override
  Widget build(BuildContext context) {
    final curCat = _cats[_cat];
    final list = _allHosts.where((h) => _cat == 0 || h['cat'] == curCat).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF07070A),
      appBar: AppBar(
        title: const Text('Fizz Live Pro'),
        actions: [TextButton(onPressed: _recharge, child: Text('💎 $_gems', style: const TextStyle(color: Colors.amber)))],
        bottom: TabBar(controller: _tabCtrl, indicatorColor: Colors.pink, labelColor: Colors.pink, unselectedLabelColor: Colors.grey, tabs: const [Tab(icon: Icon(Icons.home)), Tab(icon: Icon(Icons.favorite)), Tab(icon: Icon(Icons.casino)), Tab(icon: Icon(Icons.chat)), Tab(icon: Icon(Icons.person))]),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          Column(
            children: [
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [for (int i = 0; i < _cats.length; i++) Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: ActionChip(label: Text(_cats[i]), backgroundColor: _cat == i ? Colors.pink : const Color(0xFF14141E), onPressed: () => setState(() => _cat = i)))],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RandomMatchScreen(onMatched: (n, p) { Navigator.pop(context); _dial(n, p); }))),
                  icon: const Icon(Icons.radar),
                  label: const Text('Random Match (1800 gems)'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(6),
                  childAspectRatio: 0.8,
                  children: [
                    for (var h in (list.isEmpty ? _allHosts : list))
                      GestureDetector(
                        onTap: () => _showHostProfile(h),
                        child: Card(
                          color: const Color(0xFF14141E),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(radius: 28, backgroundImage: NetworkImage(h['pic']!)),
                              const SizedBox(height: 4),
                              Text(h['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              Text('🔴 LIVE • ${h['views']}', style: const TextStyle(color: Colors.greenAccent, fontSize: 10)),
                              const SizedBox(height: 6),
                              ElevatedButton(onPressed: () => _dial(h['name']!, h['pic']!), child: const Text('Call', style: TextStyle(fontSize: 10))),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          ListView(children: [for (var h in _allHosts) ListTile(leading: CircleAvatar(backgroundImage: NetworkImage(h['pic']!)), title: Text(h['name']!, style: const TextStyle(color: Colors.white)), subtitle: Text(h['city']!, style: const TextStyle(color: Colors.grey)), trailing: ElevatedButton(onPressed: () => _dial(h['name']!, h['pic']!), child: const Text('Call')))]),
          Center(child: ElevatedButton(onPressed: () => setState(() => _gems += 150), child: const Text('Spin & Win 150 Gems'))),
          ListView(children: [for (var h in _allHosts) ListTile(leading: CircleAvatar(backgroundImage: NetworkImage(h['pic']!)), title: Text(h['name']!, style: const TextStyle(color: Colors.white)), subtitle: const Text('Online • Tap to chat', style: TextStyle(color: Colors.greenAccent)), onTap: () => _dial(h['name']!, h['pic']!))]),
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Center(child: Column(children: [CircleAvatar(radius: 30, child: Icon(Icons.person)), SizedBox(height: 6), Text('User7789', style: TextStyle(color: Colors.white, fontSize: 16)), Text('👑 VIP Lv.5 (Special Badge Active)', style: TextStyle(color: Colors.amber, fontSize: 12))])),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => setState(() => _gems += 500),
                icon: const Icon(Icons.card_giftcard),
                label: const Text('Claim Daily VIP Bonus (+500 Gems)'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
              ),
              const SizedBox(height: 20),
              const Text('Wallet History:', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              for (var item in _history)
                Card(color: const Color(0xFF14141E), child: ListTile(leading: const Icon(Icons.history, color: Colors.pink), title: Text(item, style: const TextStyle(color: Colors.white)))),
            ],
          ),
        ],
      ),
    );
  }
}
