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
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.live_tv, size: 70, color: Colors.pinkAccent),
            const SizedBox(height: 10),
            const Text('FIZZ LIVE PRO', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
            const Text('18+ Private Live Video & PK Chat', style: TextStyle(fontSize: 11, color: Colors.white54)),
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
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Admin PIN (7777)', style: TextStyle(fontSize: 18, color: Colors.white)),
              const SizedBox(height: 10),
              TextField(controller: _c, keyboardType: TextInputType.number, obscureText: true, textAlign: TextAlign.center, style: const TextStyle(color: Colors.amber, fontSize: 22), decoration: const InputDecoration(filled: true, fillColor: Colors.grey, hintText: "••••")),
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

  void _showAuthSheet(BuildContext context, String type) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Continue with $type', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (type == 'Google') ListTile(leading: const Icon(Icons.g_mobiledata, color: Colors.amber, size: 32), title: const Text('Chandran S (chandran@gmail.com)', style: TextStyle(color: Colors.white)), onTap: () { Navigator.pop(ctx); Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Dashboard())); }),
            if (type == 'Phone') Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: TextField(style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'Enter Phone Number', hintStyle: TextStyle(color: Colors.white54)))),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Dashboard()));
              },
              child: const Text('Confirm Login'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.live_tv, size: 70, color: Colors.pinkAccent),
              const SizedBox(height: 12),
              const Text('Fast Login', style: TextStyle(color: Colors.amber, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[850]), icon: const Icon(Icons.g_mobiledata, color: Colors.redAccent), label: const Text('Google', style: TextStyle(color: Colors.white)), onPressed: () => _showAuthSheet(context, 'Google')),
                  ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[850]), icon: const Icon(Icons.phone, color: Colors.greenAccent), label: const Text('Phone', style: TextStyle(color: Colors.white)), onPressed: () => _showAuthSheet(context, 'Phone')),
                  ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[850]), icon: const Icon(Icons.person_outline, color: Colors.blueAccent), label: const Text('Guest', style: TextStyle(color: Colors.white)), onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Dashboard()))),
                ],
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  await [Permission.camera, Permission.microphone].request();
                  if (context.mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Dashboard()));
                },
                child: const Text('Fast Login & Permissions', style: TextStyle(color: Colors.white54, fontSize: 12)),
              ),
            ],
          ),
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
  bool _mic = true, _frontCam = true;
  int _sec = 0;
  int _pingMs = 45;
  Timer? _t, _netTimer;

  @override
  void initState() {
    super.initState();
    _g = widget.gems;
    _initZego();
    _t = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _sec++);
      if (_sec > 0 && _sec % 60 == 0) {
        if (_g >= 1800) { setState(() => _g -= 1800); widget.onGems(_g); } else { _exitCall(); }
      }
    });
    _netTimer = Timer.periodic(const Duration(seconds: 3), (t) {
      if (!mounted) return;
      setState(() => _pingMs = 35 + (DateTime.now().second % 40));
    });
  }

  void _exitCall() {
    _t?.cancel();
    _netTimer?.cancel();
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
      setState(() { _g -= cost; _gift = 'Sent $em $name!'; });
      widget.onGems(_g);
      Future.delayed(const Duration(seconds: 2), () { if (mounted) setState(() => _gift = ''); });
    }
  }

  @override
  void dispose() {
    _t?.cancel();
    _netTimer?.cancel();
    if (_vid != null) ZegoExpressEngine.instance.destroyCanvasView(_vid!);
    ZegoExpressEngine.instance.stopPreview();
    ZegoExpressEngine.destroyEngine();
    super.dispose();
  }

  Color get _netColor => _pingMs < 60 ? Colors.greenAccent : (_pingMs < 120 ? Colors.amber : Colors.redAccent);
  IconData get _netIcon => _pingMs < 60 ? Icons.signal_cellular_4_bar : (_pingMs < 120 ? Icons.signal_cellular_alt : Icons.signal_cellular_alt_2_bar);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(child: Image.network(widget.pic, fit: BoxFit.cover)),
          Positioned(top: 40, right: 16, width: 85, height: 115, child: ClipRRect(borderRadius: BorderRadius.circular(8), child: _cam ?? const CircularProgressIndicator())),
          Positioned(
            top: 40, left: 70,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Icon(_netIcon, color: _netColor, size: 16),
                  const SizedBox(width: 4),
                  Text('${_pingMs}ms', style: TextStyle(color: _netColor, fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          if (_gift.isNotEmpty) Positioned(top: 100, left: 20, child: Container(padding: const EdgeInsets.all(6), color: Colors.pink, child: Text(_gift, style: const TextStyle(color: Colors.white)))),
          Positioned(
            bottom: 20, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(icon: Icon(_mic ? Icons.mic : Icons.mic_off, color: Colors.white), onPressed: () => setState(() => _mic = !_mic)),
                IconButton(icon: const Icon(Icons.flip_camera_ios, color: Colors.white), onPressed: () => ZegoExpressEngine.instance.useFrontCamera(_frontCam = !_frontCam)),
                IconButton(icon: const Icon(Icons.call_end, color: Colors.red, size: 36), onPressed: _exitCall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LiveStreamPKRoom extends StatefulWidget {
  final String streamer1Name, streamer1Pic, streamer2Name, streamer2Pic;
  final bool isPK;
  final Function(String) onCloseWithPiP;
  const LiveStreamPKRoom({
    super.key,
    required this.streamer1Name,
    required this.streamer1Pic,
    required this.streamer2Name,
    required this.streamer2Pic,
    required this.isPK,
    required this.onCloseWithPiP,
  });

  @override
  State<LiveStreamPKRoom> createState() => _LiveStreamPKRoomState();
}

class _LiveStreamPKRoomState extends State<LiveStreamPKRoom> {
  final List<Map<String, String>> _messages = [
    {'user': 'bosi', 'msg': 'Hi!'},
    {'user': 'system', 'msg': 'Rules apply!'},
  ];
  final _msgCtrl = TextEditingController();

  void _sendMessage() {
    if (_msgCtrl.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({'user': 'You', 'msg': _msgCtrl.text.trim()});
        _msgCtrl.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: widget.isPK
                ? Column(
                    children: [
                      Container(
                        height: 28,
                        color: Colors.grey[900],
                        child: Row(
                          children: [
                            Container(width: MediaQuery.of(context).size.width * 0.48, color: Colors.cyan),
                            Container(padding: const EdgeInsets.symmetric(horizontal: 8), color: Colors.pink, child: const Text('PK 02:00', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                            Expanded(child: Container(color: Colors.pink[700])),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(widget.streamer1Pic), fit: BoxFit.cover)),
                                child: Align(alignment: Alignment.bottomLeft, child: Container(color: Colors.black54, padding: const EdgeInsets.all(4), child: Text(widget.streamer1Name, style: const TextStyle(color: Colors.amber, fontSize: 11)))),
                              ),
                            ),
                            Container(width: 2, color: Colors.black),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(widget.streamer2Pic), fit: BoxFit.cover)),
                                child: Align(alignment: Alignment.bottomLeft, child: Container(color: Colors.black54, padding: const EdgeInsets.all(4), child: Text(widget.streamer2Name, style: const TextStyle(color: Colors.amber, fontSize: 11)))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(
                    decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(widget.streamer1Pic), fit: BoxFit.cover)),
                  ),
          ),
          if (widget.isPK) Positioned(top: MediaQuery.of(context).size.height * 0.45, left: 0, right: 0, child: Center(child: CircleAvatar(radius: 24, backgroundColor: Colors.pink.withOpacity(0.8), child: const Text('PK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))))),
          Positioned(
            top: 40, left: 16, right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: 18, backgroundImage: NetworkImage(widget.streamer1Pic)),
                    const SizedBox(width: 6),
                    Text(widget.streamer1Name, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(
                  icon: const CircleAvatar(radius: 12, backgroundColor: Colors.black54, child: Icon(Icons.close, color: Colors.white, size: 14)),
                  onPressed: () { widget.onCloseWithPiP(widget.streamer1Name); Navigator.pop(context); },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16, left: 16, right: 16,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    decoration: InputDecoration(
                      filled: true, fillColor: Colors.black54, hintText: 'Say something...', hintStyle: const TextStyle(color: Colors.white54, fontSize: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(icon: const Icon(Icons.card_giftcard, color: Colors.pinkAccent), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Host {
  final String name, pic, cat, tag, city, bio;
  const Host({required this.name, required this.pic, required this.cat, required this.tag, this.city = '', this.bio = ''});
}
class HostRank {
  final int rank;
  final String name, pic, gems;
  const HostRank({required this.rank, required this.name, required this.pic, required this.gems});
}
// Placeholder bridge
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _navIndex = 0;
  int _cat = 0;
  int _gems = 1670;
  final String _userName = 'User7789';
  final String _userBio = 'VIP Member & Live Chat Lover';
  int _hostEarningsINR = 12500;
  int _hostGemsEarned = 25000;
  bool _dailyRewardClaimed = false;

  bool _hasMiniPlayer = false;
  String _miniStreamerName = '';
  String _miniStreamerPic = '';
  bool _isMiniPK = false;

  final List<String> _history = ['Recharge: +4050 Gems', 'Video Call: -1800 Gems'];
  final List<Host> _favorites = [];
  final List<Map<String, String>> _notifications = [
    {'title': 'VIP Bonus Unlocked!', 'desc': 'Claim +500 free gems in profile tab.', 'time': '10m ago'},
    {'title': 'New Host Alert', 'desc': 'Anitha & Malar are live in Co-Host mode!', 'time': '1h ago'},
  ];

  final List<String> _cats = const ['Hot', 'Live', 'Party', 'Match'];
  
  final List<Host> _allHosts = const [
    Host(name: 'AvniHotnessDil', pic: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300', cat: 'Hot', tag: 'Exotic', city: 'Mumbai', bio: 'Model 💋'),
    Host(name: 'Shiny Sanya', pic: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=300', cat: 'Hot', tag: 'Party', city: 'Delhi', bio: 'Dance ✨'),
    Host(name: 'Anitha', pic: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=300', cat: 'Live', tag: 'FREE', city: 'Chennai', bio: 'Full screen ❤️'),
  ];

  final _exactPacks = const [
    {'gems': 4050, 'price': 100.0, 'tag': '17% of'},
    {'gems': 8100, 'price': 200.0, 'tag': '17% of'},
    {'gems': 16380, 'price': 400.0, 'tag': '17% of'},
    {'gems': 32940, 'price': 800.0, 'tag': '17% of'},
    {'gems': 66600, 'price': 1600.0, 'tag': '30% of'},
    {'gems': 167400, 'price': 4000.0, 'tag': '60% of'},
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), _showDailyRewardDialog);
  }

  void _showDailyRewardDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Daily Rewards 🎁', style: TextStyle(color: Colors.amber)),
        content: const Text('Sign in for daily bonuses!', style: TextStyle(color: Colors.white70)),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _dailyRewardClaimed ? Colors.grey : Colors.amber),
            onPressed: _dailyRewardClaimed ? null : () {
              setState(() { _gems += 40; _dailyRewardClaimed = true; });
              Navigator.pop(ctx);
            },
            child: Text(_dailyRewardClaimed ? 'Claimed' : 'Check-in (+40 Gems)'),
          ),
        ],
      ),
    );
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        height: 380,
        child: Column(
          children: [
            const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Notifications & Activity 🔔', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)), Icon(Icons.mark_email_read, color: Colors.pink)]),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _notifications.length,
                itemBuilder: (ctx, i) {
                  final n = _notifications[i];
                  return Card(color: Colors.grey[850], child: ListTile(title: Text(n['title']!, style: const TextStyle(color: Colors.white)), subtitle: Text(n['desc']!, style: const TextStyle(color: Colors.white70))));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPayoutModal() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Host Earnings & Payout 💰', style: TextStyle(color: Colors.amber)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Earned Gems: $_hostGemsEarned 💎', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text('Withdrawable Balance: ₹$_hostEarningsINR', style: const TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green), onPressed: () { Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payout requested!'))); }, child: const Text('Request Payout')),
        ],
      ),
    );
  }

  void _showRechargeModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        height: 480,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                const Text('Recharge and continue💋', style: TextStyle(color: Colors.white70, fontSize: 11)),
                IconButton(icon: const Icon(Icons.close, color: Colors.white54, size: 18), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.8, crossAxisSpacing: 10, mainAxisSpacing: 10),
                itemCount: _exactPacks.length,
                itemBuilder: (ctx, i) {
                  final p = _exactPacks[i];
                  final isFirst = i == 0;
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(color: isFirst ? Colors.amber[900] : Colors.grey[850], borderRadius: BorderRadius.circular(12), border: isFirst ? Border.all(color: Colors.amber, width: 2) : null),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(children: [const Icon(Icons.diamond, color: Colors.amber, size: 16), const SizedBox(width: 4), Text('${p['gems']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))]),
                            const SizedBox(height: 6),
                            Text('₹${p['price']}', style: TextStyle(color: isFirst ? Colors.white : Colors.amberAccent, fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Positioned(top: 0, right: 0, child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: const BoxDecoration(color: Colors.pink, borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(8))), child: Text(p['tag'] as String, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)))),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                onPressed: () { setState(() => _gems += 4050); Navigator.pop(ctx); },
                child: const Text('Continue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openPKRoom({required String name, required String pic, required bool isPK}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LiveStreamPKRoom(
          streamer1Name: name, streamer1Pic: pic, streamer2Name: 'An...', streamer2Pic: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=300', isPK: isPK,
          onCloseWithPiP: (closed) { setState(() { _hasMiniPlayer = true; _miniStreamerName = closed; _miniStreamerPic = pic; _isMiniPK = isPK; }); },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _allHosts.where((h) => _cat == 0 || h.cat == _cats[_cat]).toList();

    Widget bodyContent;
    if (_navIndex == 0) {
      bodyContent = Column(
        children: [
          Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _cats.asMap().entries.map((e) => GestureDetector(
                onTap: () => setState(() => _cat = e.key),
                child: Text(e.value, style: TextStyle(color: _cat == e.key ? Colors.pink : Colors.white70, fontWeight: FontWeight.bold, fontSize: 16)),
              )).toList(),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.82, crossAxisSpacing: 6, mainAxisSpacing: 6),
              padding: const EdgeInsets.all(6),
              itemCount: list.length,
              itemBuilder: (ctx, i) {
                final h = list[i];
                return GestureDetector(
                  onTap: () => _openPKRoom(name: h.name, pic: h.pic, isPK: false),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(h.pic, fit: BoxFit.cover),
                        Positioned(top: 8, right: 8, child: CircleAvatar(radius: 12, backgroundColor: Colors.black54, child: Icon(h.tag == 'FREE' ? Icons.card_giftcard : Icons.videocam, color: Colors.pinkAccent, size: 14))),
                        Positioned(bottom: 6, left: 6, child: Text(h.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                        Positioned(bottom: 6, right: 6, child: InkWell(onTap: () => _openPKRoom(name: h.name, pic: h.pic, isPK: true), child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(8)), child: const Text('PK', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold))))),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    } else if (_navIndex == 1) {
      bodyContent = _favorites.isEmpty ? const Center(child: Text('No Followed hosts yet!', style: TextStyle(color: Colors.grey))) : ListView.builder(itemCount: _favorites.length, itemBuilder: (ctx, i) => ListTile(title: Text(_favorites[i].name)));
    } else if (_navIndex == 2) {
      bodyContent = ListView.builder(
        itemCount: _allHosts.length,
        itemBuilder: (ctx, i) => ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(_allHosts[i].pic)),
          title: Text('${_allHosts[i].name} (Dual Co-Host)', style: const TextStyle(color: Colors.white)),
          trailing: ElevatedButton(onPressed: () => _openPKRoom(name: _allHosts[i].name, pic: _allHosts[i].pic, isPK: true), child: const Text('Dual Live')),
        ),
      );
    } else if (_navIndex == 3) {
      bodyContent = ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          ListTile(leading: CircleAvatar(backgroundColor: Colors.pink, child: Icon(Icons.favorite)), title: Text('Like Me / Date', style: TextStyle(color: Colors.white)), subtitle: Text('Find your match 💖')),
        ],
      );
    } else {
      bodyContent = ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(child: Column(children: [const CircleAvatar(radius: 30, child: Icon(Icons.person)), const SizedBox(height: 6), Text(_userName, style: const TextStyle(color: Colors.white, fontSize: 16)), Text(_userBio, style: const TextStyle(color: Colors.white54, fontSize: 12))])),
          const SizedBox(height: 10),
          Card(color: Colors.grey[850], child: ListTile(leading: const Icon(Icons.account_balance_wallet, color: Colors.greenAccent), title: Text('Host Earnings: ₹$_hostEarningsINR', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), trailing: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green), onPressed: _showPayoutModal, child: const Text('Payout')))),
          const SizedBox(height: 20),
          const Text('Wallet History:', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16)),
          ..._history.map((item) => Card(color: Colors.grey, child: ListTile(title: Text(item, style: const TextStyle(color: Colors.white))))),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('FIZZ LIVE', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.notifications, color: Colors.amber), onPressed: _showNotifications),
          IconButton(icon: const Icon(Icons.diamond, color: Colors.amber), onPressed: _showRechargeModal),
        ],
      ),
      body: Stack(
        children: [
          bodyContent,
          if (_hasMiniPlayer)
            Positioned(
              bottom: 20, right: 20,
              child: GestureDetector(
                onTap: () { setState(() => _hasMiniPlayer = false); _openPKRoom(name: _miniStreamerName, pic: _miniStreamerPic, isPK: _isMiniPK); },
                child: Container(
                  width: 110, height: 150,
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.pink, width: 2)),
                  child: Stack(
                    children: [
                      ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(_miniStreamerPic, fit: BoxFit.cover, width: 110, height: 150)),
                      Positioned(top: 2, right: 2, child: InkWell(onTap: () => setState(() => _hasMiniPlayer = false), child: const CircleAvatar(radius: 9, backgroundColor: Colors.black54, child: Icon(Icons.close, size: 10, color: Colors.white)))),
                      Positioned(bottom: 4, left: 4, child: Text('Mini 🎙️\n($_miniStreamerName)', style: const TextStyle(color: Colors.amber, fontSize: 8, fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.white54,
        currentIndex: _navIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (idx) => setState(() => _navIndex = idx),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Follow'),
          BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'Live'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}

