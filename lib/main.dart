import 'dart:math';
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
              width: 90, height: 90,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network('https://i.ibb.co/3k5fB0K/fizz-logo.png', errorBuilder: (c, e, s) => const Icon(Icons.videocam, size: 60, color: Colors.pink)),
              ),
            ),
            const SizedBox(height: 10),
            const Text('FIZZ LIVE PRO', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber)),
            const Text('18+ Private Live Video Chat', style: TextStyle(fontSize: 12, color: Colors.white54)),
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
          child: const Text('Fast Login & Allow Permissions'),
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
  final _chatCtrl = TextEditingController();
  final List<String> _roomChat = ['System: Welcome to Live Room! ❤️', 'Pooja: Hello sweet friends!'];
  final List<Widget> _floatingHearts = [];

  @override
  void initState() {
    super.initState();
    _g = widget.gems;
  }

  void _addHeart() {
    setState(() {
      _likes++;
      final key = UniqueKey();
      _floatingHearts.add(
        Positioned(
          key: key,
          bottom: 80 + Random().nextDouble() * 40,
          right: 20 + Random().nextDouble() * 30,
          child: const Icon(Icons.favorite, color: Colors.pinkAccent, size: 28),
        ),
      );
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _floatingHearts.removeWhere((w) => w.key == _floatingHearts.last.key));
    });
  }

  void _sendGift(String name, int cost, String em) {
    if (_g >= cost) {
      setState(() { _g -= cost; _gift = "Sent $em $name!"; });
      widget.onGems(_g);
      Future.delayed(const Duration(seconds: 2), () { if (mounted) setState(() => _gift = ""); });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _addHeart,
        child: Stack(
          children: [
            Positioned.fill(child: Image.network(widget.host['pic']!, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.grey[900]))),
            Container(color: Colors.black38),
            ..._floatingHearts,
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(radius: 18, backgroundImage: NetworkImage(widget.host['pic']!)),
                        const SizedBox(width: 8),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(widget.host['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text('❤️ $_likes likes', style: const TextStyle(color: Colors.pinkAccent, fontSize: 11)),
                        ]),
                        const Spacer(),
                        IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
                      ],
                    ),
                  ),
                  if (_gift.isNotEmpty) Container(padding: const EdgeInsets.all(8), color: Colors.pink, child: Text(_gift, style: const TextStyle(color: Colors.white))),
                  const Spacer(),
                  Container(
                    height: 90, width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ListView.builder(itemCount: _roomChat.length, itemBuilder: (ctx, i) => Text(_roomChat[i], style: const TextStyle(color: Colors.white70, fontSize: 12))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(child: TextField(controller: _chatCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'Tap screen to like ❤️', filled: true, fillColor: Colors.black54))),
                        IconButton(icon: const Icon(Icons.send, color: Colors.amber), onPressed: () { if (_chatCtrl.text.isNotEmpty) { setState(() => _roomChat.add('You: ${_chatCtrl.text}')); _chatCtrl.clear(); } }),
                        IconButton(icon: const Icon(Icons.card_giftcard, color: Colors.pink), onPressed: () => _sendGift('Car', 1000, '🏎️')),
                        ElevatedButton(onPressed: widget.onCall, style: ElevatedButton.styleFrom(backgroundColor: Colors.pink), child: const Text('Call')),
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
  const CallScreen({super.key, required this.host, required this.pic, required this.gems, required this.onGems});
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

  @override
  void initState() {
    super.initState();
    _g = widget.gems;
    _start();
  }

  Future<void> _start() async {
    await ZegoExpressEngine.createEngineWithProfile(ZegoEngineProfile(710176630, ZegoScenario.StandardVideoCall, appSign: '0b8b0f4adab85c101698f21f4e7c7b1aa477c901ac58d80a75e54c17ed05ad8a'));
    await ZegoExpressEngine.instance.createCanvasView((id) {
      _vid = id;
      ZegoExpressEngine.instance.startPreview(canvas: ZegoCanvas(id));
    }).then((w) => setState(() => _cam = w));
  }

  void _flipCam() {
    setState(() => _frontCam = !_frontCam);
    ZegoExpressEngine.instance.useFrontCamera(_frontCam);
  }

  @override
  void dispose() {
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
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.pic),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(_glow ? 0.3 : 0.5), BlendMode.darken),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(radius: 45, backgroundImage: NetworkImage(widget.pic)),
                    const SizedBox(height: 10),
                    Text('${widget.host} is live', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    if (_glow) const Text('✨ Glow Filter ON', style: TextStyle(color: Colors.amber, fontSize: 11)),
                  ],
                ),
              ),
            ),
          ),
          Positioned(top: 40, right: 16, width: 85, height: 115, child: ClipRRect(borderRadius: BorderRadius.circular(10), child: _cam ?? const CircularProgressIndicator())),
          if (_gift.isNotEmpty) Positioned(top: 100, left: 20, child: Container(padding: const EdgeInsets.all(8), color: Colors.pink, child: Text(_gift, style: const TextStyle(color: Colors.white)))),
          Positioned(
            bottom: 20, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(icon: Icon(_mic ? Icons.mic : Icons.mic_off, color: Colors.white), onPressed: () => setState(() => _mic = !_mic)),
                IconButton(icon: const Icon(Icons.flip_camera_ios, color: Colors.white), onPressed: _flipCam),
                IconButton(icon: Icon(Icons.auto_awesome, color: _glow ? Colors.amber : Colors.white), onPressed: () => setState(() => _glow = !_glow)),
                IconButton(icon: const Icon(Icons.call_end, color: Colors.red, size: 36), onPressed: () => Navigator.pop(context)),
                IconButton(icon: const Icon(Icons.card_giftcard, color: Colors.amber, size: 34), onPressed: () { if (_g >= 1000) { setState(() { _g -= 1000; _gift = "Sent 🏎️ Car!"; }); widget.onGems(_g); } }),
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

  final _cats = const ['Popular', 'Hot Live', 'Party Match', 'Nearby'];
  final _allHosts = const [
    {'name': 'Pooja', 'city': 'Mumbai', 'views': '3.2k', 'cat': 'Popular', 'pic': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200'},
    {'name': 'Ananya', 'city': 'Delhi', 'views': '5.1k', 'cat': 'Hot Live', 'pic': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200'},
    {'name': 'Sneha', 'city': 'Chennai', 'views': '2.4k', 'cat': 'Party Match', 'pic': 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200'},
    {'name': 'Kavya', 'city': 'Bangalore', 'views': '4.3k', 'cat': 'Nearby', 'pic': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200'},
  ];

  final _packs = const [
    {'gems': 4050, 'price': 100},
    {'gems': 8100, 'price': 200},
    {'gems': 16380, 'price': 400},
    {'gems': 32940, 'price': 800},
    {'gems': 66600, 'price': 1600},
    {'gems': 167400, 'price': 4000},
  ];

  void _recharge() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF14141E),
      builder: (ctx) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('My Gems: $_gems', style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          for (var p in _packs)
            ListTile(
              leading: const Icon(Icons.diamond, color: Colors.amber),
              title: Text('${p['gems']} Gems', style: const TextStyle(color: Colors.white)),
              trailing: ElevatedButton(onPressed: () { setState(() => _gems += (p['gems'] as int)); Navigator.pop(ctx); }, child: Text('₹${p['price']}')),
            ),
        ],
      ),
    );
  }

  void _dial(String name, String pic) {
    if (_gems >= 1800) {
      setState(() => _gems -= 1800);
      Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen(host: name, pic: pic, gems: _gems, onGems: (g) => setState(() => _gems = g))));
    } else {
      _recharge();
    }
  }

  void _watchLive(Map<String, String> h) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => LiveStreamRoom(host: h, gems: _gems, onGems: (g) => setState(() => _gems = g), onCall: () { Navigator.pop(context); _dial(h['name']!, h['pic']!); })));
  }

  Widget _buildBody() {
    if (_tab == 0) {
      final curCat = _cats[_cat];
      final list = _allHosts.where((h) => _cat == 0 || h['cat'] == curCat).toList();
      return Column(children: [
        SizedBox(height: 40, child: ListView(scrollDirection: Axis.horizontal, children: [
          for (int i = 0; i < _cats.length; i++)
            Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: ActionChip(label: Text(_cats[i]), backgroundColor: _cat == i ? Colors.pink : const Color(0xFF14141E), onPressed: () => setState(() => _cat = i)))
        ])),
        Padding(padding: const EdgeInsets.all(8), child: SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () => _dial(_allHosts[0]['name']!, _allHosts[0]['pic']!), icon: const Icon(Icons.radar), label: const Text('Random Match (1800 gems)')))),
        Expanded(child: GridView.count(crossAxisCount: 2, padding: const EdgeInsets.all(8), children: [
          for (var h in (list.isEmpty ? _allHosts : list))
            GestureDetector(
              onTap: () => _watchLive(h),
              child: Card(color: const Color(0xFF14141E), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                CircleAvatar(radius: 26, backgroundImage: NetworkImage(h['pic']!)),
                const SizedBox(height: 4),
                Text(h['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text('🔴 LIVE • ${h['views']}', style: const TextStyle(color: Colors.greenAccent, fontSize: 10)),
                const SizedBox(height: 4),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  OutlinedButton(onPressed: () => _watchLive(h), child: const Text('Watch', style: TextStyle(fontSize: 10, color: Colors.white))),
                  const SizedBox(width: 4),
                  ElevatedButton(onPressed: () => _dial(h['name']!, h['pic']!), child: const Text('Call', style: TextStyle(fontSize: 10))),
                ]),
              ])),
            )
        ])),
      ]);
    } else if (_tab == 1) {
      return ListView(children: [for (var h in _allHosts) ListTile(leading: CircleAvatar(backgroundImage: NetworkImage(h['pic']!)), title: Text(h['name']!, style: const TextStyle(color: Colors.white)), subtitle: Text(h['city']!, style: const TextStyle(color: Colors.grey)), trailing: ElevatedButton(onPressed: () => _dial(h['name']!, h['pic']!), child: const Text('Call')))]);
    } else if (_tab == 2) {
      return Center(child: ElevatedButton(onPressed: () => setState(() => _gems += 150), child: const Text('Spin & Win 150 Gems')));
    } else if (_tab == 3) {
      return ListView(children: [for (var h in _allHosts) ListTile(leading: CircleAvatar(backgroundImage: NetworkImage(h['pic']!)), title: Text(h['name']!, style: const TextStyle(color: Colors.white)), subtitle: const Text('Online • Tap to chat', style: TextStyle(color: Colors.greenAccent)), onTap: () => _dial(h['name']!, h['pic']!))]);
    } else {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const CircleAvatar(radius: 36, child: Icon(Icons.person, size: 40)),
        const SizedBox(height: 8),
        const Text('User7789', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(12)), child: const Text('👑 VIP Lv.5', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12))),
        const SizedBox(height: 10),
        Text('Gems: $_gems', style: const TextStyle(color: Colors.amber, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 14),
        ElevatedButton(onPressed: _recharge, child: const Text('Buy Gems')),
      ]));
    }
  }

  @override
  Widget build(BuildContext context) {
    const icons = [Icons.home, Icons.favorite, Icons.casino, Icons.chat, Icons.person];
    return Scaffold(
      backgroundColor: const Color(0xFF07070A),
      appBar: AppBar(title: const Text('Fizz Live Pro'), actions: [TextButton(onPressed: _recharge, child: Text('💎 $_gems', style: const TextStyle(color: Colors.amber)))]),
      body: _buildBody(),
      bottomNavigationBar: Container(height: 50, color: const Color(0xFF0E0E14), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [for (int i = 0; i < icons.length; i++) IconButton(icon: Icon(icons[i], color: _tab == i ? Colors.pink : Colors.grey), onPressed: () => setState(() => _tab = i))])),
    );
  }
}

