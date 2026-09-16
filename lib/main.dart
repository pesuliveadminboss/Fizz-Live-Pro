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

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _scale = CurvedAnimation(parent: _anim, curve: Curves.easeOutBack);
    _anim.forward();

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PinGate()));
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07070A),
      body: Center(
        child: ScaleTransition(
          scale: _scale,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFFFF2E93).withOpacity(0.4), blurRadius: 26, spreadRadius: 3),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: Image.network(
                    'https://i.ibb.co/3k5fB0K/fizz-logo.png',
                    errorBuilder: (ctx, err, stack) => const Icon(Icons.videocam_rounded, size: 85, color: Color(0xFFFF2E93)),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text('FIZZ LIVE PRO', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 3, color: Color(0xFFFFD700))),
              const SizedBox(height: 6),
              const Text('18+ Private Live Video Chat', style: TextStyle(fontSize: 12, color: Colors.white54, letterSpacing: 1)),
            ],
          ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
                        child: Text(widget.host, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(6)),
                        child: const Text('1800/min', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(icon: const Icon(Icons.call_end, color: Colors.red, size: 40), onPressed: () => Navigator.pop(context)),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MatchScreen extends StatefulWidget {
  final List<Map<String, String>> hosts;
  final Function(String) onMatched;
  const MatchScreen({super.key, required this.hosts, required this.onMatched});
  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  String status = "Searching for nearby hosts...";
  @override
  void initState() {
    super.initState();
    _startMatching();
  }

  void _startMatching() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        final randHost = widget.hosts[Random().nextInt(widget.hosts.length)];
        setState(() => status = "Matched with ${randHost['name']}!");
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            Navigator.pop(context);
            widget.onMatched(randHost['name']!);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A12),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(strokeWidth: 4, color: Color(0xFFFF2E93)),
            ),
            const SizedBox(height: 24),
            Text(status, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Quick Random Video Match", style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ],
        ),
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
    {'name': 'Sneha', 'city': 'Chennai', 'lvl': 'Lv.6', 'status': 'Online', 'bio': 'Tamil ponnu! Always happy to make new friends ✨', 'followers': '9.8k'},
    {'name': 'Kavya', 'city': 'Bangalore', 'lvl': 'Lv.8', 'status': 'Online', 'bio': 'Party lover & fashion vlogger. Call for fun!', 'followers': '19.4k'},
    {'name': 'Rhea', 'city': 'Hyderabad', 'lvl': 'Lv.5', 'status': 'Online', 'bio': 'Sweet & naughty. 1-on-1 private talk only 💋', 'followers': '7.1k'},
    {'name': 'Divya', 'city': 'Kolkata', 'lvl': 'Lv.7', 'status': 'Online', 'bio': 'Singer & artist. Chill vibes only 🎵', 'followers': '12.5k'},
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
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added ${p['gems']} Gems!'), backgroundColor: Colors.green));
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
      Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen(host: name, room: 'room_${name.toLowerCase()}')));
    } else {
      _showRecharge();
    }
  }

  void _openHostProfile(Map<String, String> h) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF101018),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 46,
                backgroundColor: const Color(0xFFFF2E93),
                child: const CircleAvatar(radius: 43, backgroundColor: Color(0xFF1E1E2C), child: Icon(Icons.person, size: 50, color: Colors.white)),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(h['name']!, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: const Color(0xFFFFD700), borderRadius: BorderRadius.circular(6)),
                    child: Text(h['lvl']!, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text('${h['city']} • ${h['followers']} Followers', style: const TextStyle(color: Colors.white54, fontSize: 13)),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFF181824), borderRadius: BorderRadius.circular(12)),
                child: Text(h['bio']!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Followed ${h['name']}!'), backgroundColor: Colors.pink));
                      },
                      icon: const Icon(Icons.favorite, color: Color(0xFFFF2E93)),
                      label: const Text('Follow', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _dial(h['name']!);
                      },
                      icon: const Icon(Icons.videocam, color: Colors.white),
                      label: const Text('Call Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2E93)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _startRandomMatch() {
    if (_gems < 1800) {
      _showRecharge();
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => MatchScreen(hosts: _hosts, onMatched: (name) => _dial(name))));
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _startRandomMatch,
                icon: const Icon(Icons.radar, color: Colors.white),
                label: const Text('Start Random Video Match (1800 gems)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2E93)),
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
                    onTap: () => _openHostProfile(h),
                    child: Card(
                      color: const Color(0xFF14141E),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircleAvatar(radius: 26, child: Icon(Icons.person)),
                          const SizedBox(height: 4),
                          Text(h['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text('${h['city']} • ${h['lvl']}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                          const SizedBox(height: 4),
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
              onTap: () => _openHostProfile(h),
              leading: const CircleAvatar(child: Icon(Ic
