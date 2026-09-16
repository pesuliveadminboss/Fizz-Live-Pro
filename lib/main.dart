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
              width: 110,
              height: 110,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(22)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.network(
                  'https://i.ibb.co/3k5fB0K/fizz-logo.png',
                  errorBuilder: (c, e, s) => const Icon(Icons.videocam, size: 75, color: Color(0xFFFF2E93)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('FIZZ LIVE PRO', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2, color: Color(0xFFFFD700))),
            const SizedBox(height: 6),
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
              const Text('Admin Verification (7777)', style: TextStyle(fontSize: 18, color: Colors.white)),
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
              if (_msg.isNotEmpty) Text(_msg, style: const TextStyle(color: Colors.redAccent)),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _check, child: const Text('Unlock App')),
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
              const Text('Meet Real Friends Nearby', style: TextStyle(color: Colors.white, fontSize: 20)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Perms())),
                  child: const Text('Fast Login'),
                ),
              ),
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
      body: Center(
        child: ElevatedButton(
          onPressed: () => _ask(context),
          child: const Text('Allow Camera & Mic Permissions'),
        ),
      ),
    );
  }
}

class CallScreen extends StatefulWidget {
  final String host;
  final String room;
  final int userGems;
  final Function(int) onGemsUpdated;
  const CallScreen({super.key, required this.host, required this.room, required this.userGems, required this.onGemsUpdated});
  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  Widget? _v;
  int? _vid;
  late int _gems;
  String _giftBanner = "";

  @override
  void initState() {
    super.initState();
    _gems = widget.userGems;
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

  void _sendGift(String name, int cost, String icon) {
    if (_gems >= cost) {
      setState(() {
        _gems -= cost;
        _giftBanner = "Sent $icon $name to ${widget.host}!";
      });
      widget.onGemsUpdated(_gems);
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => _giftBanner = "");
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not enough gems for this gift!'), backgroundColor: Colors.red));
    }
  }

  void _openGiftSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF14141E),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Send Virtual Gifts', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Gems: $_gems', style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _giftBtn('Rose', 50, '🌹', () { Navigator.pop(ctx); _sendGift('Rose', 50, '🌹'); }),
                  _giftBtn('Ring', 200, '💎', () { Navigator.pop(ctx); _sendGift('Ring', 200, '💎'); }),
                  _giftBtn('Car', 1000, '🏎️', () { Navigator.pop(ctx); _sendGift('Supercar', 1000, '🏎️'); }),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _giftBtn(String name, int cost, String em, VoidCallback tap) {
    return InkWell(
      onTap: tap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1E1E2C), borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text(em, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            Text(name, style: const TextStyle(color: Colors.white, fontSize: 12)),
            Text('$cost gems', style: const TextStyle(color: Color(0xFFFFD700), fontSize: 10)),
          ],
        ),
      ),
    );
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
          Positioned.fill(child: _v ?? const Center(child: CircularProgressIndicator())),
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
                        child: Text(widget.host, style: const TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(6)),
                        child: const Text('1800/min', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
                if (_giftBanner.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: const Color(0xFFFF2E93).withOpacity(0.85), borderRadius: BorderRadius.circular(20)),
                    child: Text(_giftBanner, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(icon: const Icon(Icons.call_end, color: Colors.red, size: 40), onPressed: () => Navigator.pop(context)),
                      IconButton(icon: const Icon(Icons.card_giftcard, color: Color(0xFFFFD700), size: 38), onPressed: _openGiftSheet),
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
    {'name': 'Pooja', 'city': 'Mumbai', 'lvl': 'Lv.7', 'status': 'Online', 'bio': 'Dancer & model. Love late night video chats! ❤️', 'followers': '14.2k'},
    {'name': 'Ananya', 'city': 'Delhi', 'lvl': 'Lv.9', 'status': 'Online', 'bio': 'College girl. Free now, call me darling 😘', 'followers': '28.9k'},
    {'name': 'Sneha', 'city': 'Chennai', 'lvl': 'Lv.6', 'status': 'Online', 'bio': 'Tamil ponnu! Happy to make friends ✨', 'followers': '9.8k'},
    {'name': 'Kavya', 'city': 'Bangalore', 'lvl': 'Lv.8', 'status': 'Online', 'bio': 'Fashion vlogger. Call for fun!', 'followers': '19.4k'},
    {'name': 'Rhea', 'city': 'Hyderabad', 'lvl': 'Lv.5', 'status': 'Online', 'bio': 'Sweet & talkative. Private calls only 💋', 'followers': '7.1k'},
    {'name': 'Divya', 'city': 'Kolkata', 'lvl': 'Lv.7', 'status': 'Online', 'bio': 'Music lover. Chill vibes only 🎵', 'followers': '12.5k'},
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
      backgroundColor: const Color(0xFF14141E),
      builder: (ctx) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('My Gems: $_gems', style: const TextStyle(color: Color(0xFFFFD700), fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            for (var p in _packs)
              ListTile(
                title: Text('${p['gems']} Gems', style: const TextStyle(color: Colors.white)),
                trailing: ElevatedButton(
                  onPressed: () {
                    setState(() => _gems += (p['gems'] as int));
                    Navigator.pop(ctx);
                  },
                  child: Text('₹${p['price']}'),
                ),
              ),
          ],
        );
      },
    );
  }

  void _dial(String name) {
    if (_gems >= 1800) {
      setState(() => _gems -= 1800);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CallScreen(
            host: name,
            room: 'room_${name.toLowerCase()}',
            userGems: _gems,
            onGemsUpdated: (g) => setState(() => _gems = g),
          ),
        ),
      );
    } else {
      _showRecharge();
    }
  }

  void _openProfile(Map<String, String> h) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF101018),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(radius: 36, child: Icon(Icons.person, size: 40)),
              const SizedBox(height: 10),
              Text('${h['name']} • ${h['lvl']}', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              Text('${h['city']} • ${h['followers']} Fans', style: const TextStyle(color: Colors.white54, fontSize: 12)),
              const SizedBox(height: 10),
              Text(h['bio']!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Followed ${h['name']}!')));
                      },
                      child: const Text('Follow'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _dial(h['name']!);
                      },
                      child: const Text('Call (1800)'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    if (_tab == 0) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int i = 0; i < _cats.length; i++)
                ActionChip(
                  label: Text(_cats[i]),
                  backgroundColor: _cat == i ? const Color(0xFFFF2E93) : const Color(0xFF14141E),
                  onPressed: () => setState(() => _cat = i),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final rand = _hosts[Random().nextInt(_hosts.length)];
                  _dial(rand['name']!);
                },
                icon: const Icon(Icons.radar),
                label: const Text('Random Match (1800 gems)'),
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(8),
              children: [
                for (var h in _hosts)
                  GestureDetector(
                    onTap: () => _openProfile(h),
                    child: Card(
                      color: const Color(0xFF14141E),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircleAvatar(radius: 26, child: Icon(Icons.person)),
                          Text(h['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text('${h['city']} • ${h['lvl']}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                          ElevatedButton(onPressed: () => _dial(h['name']!), child: const Text('Call')),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    } else if (_tab == 1) {
      return ListView(
        children: [
          for (var h in _hosts)
            ListTile(
              onTap: () => _openProfile(h),
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(h['name']!, style: const TextStyle(color: Colors.white)),
              subtitle: Text('${h['city']} • ${h['status']}', style: const TextStyle(color: Colors.greenAccent, fontSize: 12)),
              trailing: ElevatedButton(onPressed: () => _dial(h['name']!), child: const Text('Call')),
            ),
        ],
      );
    } else if (_tab == 2) {
      return Center(
        child: ElevatedButton(
          onPressed: () => setState(() => _gems += 150),
          child: const Text('Play Spin & Win 150 Gems'),
        ),
      );
    } else if (_tab == 3) {
      return const Center(child: Text('Welcome to Fizz Live Pro Messages!', style: TextStyle(color: Colors.white)));
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 36, child: Icon(Icons.person, size: 36)),
            const SizedBox(height: 8),
            const Text('Pesulive User • VIP Lv.4', style: TextStyle(color: Colors.white)),
            Text('Gems: $_gems', style: const TextStyle(color: Color(0
