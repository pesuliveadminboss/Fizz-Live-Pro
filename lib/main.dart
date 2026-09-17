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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
      backgroundColor: Colors.black,
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
  bool _mic = true, _frontCam = true;
  int _sec = 0;
  int _pingMs = 45;
  double _beautySmooth = 80.0;
  double _audioVolume = 100.0;
  String _activeFilter = 'Normal';
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
        if (_g >= 1800) {
          setState(() => _g -= 1800);
          widget.onGems(_g);
        } else {
          _exitCall();
        }
      }
    });
    _netTimer = Timer.periodic(const Duration(seconds: 3), (t) {
      if (!mounted) return;
      setState(() {
        _pingMs = 35 + (DateTime.now().second % 40);
      });
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
      backgroundColor: Colors.grey,
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

  void _showBeautyDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          padding: const EdgeInsets.all(20),
          height: 340,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Beauty & Audio FX ✨', style: TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Text('Skin Smoothing / Beauty Level', style: TextStyle(color: Colors.white70, fontSize: 13)),
              Slider(
                value: _beautySmooth,
                min: 0,
                max: 100,
                activeColor: Colors.pink,
                inactiveColor: Colors.grey,
                onChanged: (val) {
                  setModalState(() => _beautySmooth = val);
                  setState(() => _beautySmooth = val);
                },
              ),
              const SizedBox(height: 10),
              const Text('Call Volume / Gain', style: TextStyle(color: Colors.white70, fontSize: 13)),
              Slider(
                value: _audioVolume,
                min: 0,
                max: 200,
                activeColor: Colors.amber,
                inactiveColor: Colors.grey,
                onChanged: (val) {
                  setModalState(() => _audioVolume = val);
                  setState(() => _audioVolume = val);
                },
              ),
              const SizedBox(height: 10),
              const Text('Video Filter Mode', style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['Normal', 'Glow', 'Pinkish', 'Vintage'].map((f) => ChoiceChip(
                  label: Text(f, style: const TextStyle(fontSize: 11)),
                  selected: _activeFilter == f,
                  selectedColor: Colors.pink,
                  labelStyle: TextStyle(color: _activeFilter == f ? Colors.white : Colors.white70),
                  onSelected: (selected) {
                    if (selected) {
                      setModalState(() => _activeFilter = f);
                      setState(() => _activeFilter = f);
                    }
                  },
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReportDialog() {
    final reasonCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text('Report / Block ${widget.host}', style: const TextStyle(color: Colors.redAccent)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select reason or describe issue:', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 10),
            TextField(controller: reasonCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(filled: true, fillColor: Colors.grey, hintText: 'Reason')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${widget.host} reported & blocked')));
            },
            child: const Text('Report & Block'),
          ),
        ],
      ),
    );
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
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(widget.pic), fit: BoxFit.cover)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(radius: 40, backgroundImage: NetworkImage(widget.pic)),
                    const SizedBox(height: 8),
                    Text(widget.host, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('${_sec ~/ 60}:${(_sec % 60).toString().padLeft(2, '0')}', style: const TextStyle(color: Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.bold)),
                    if (_activeFilter != 'Normal') Text('Filter: $_activeFilter (Glow ${_beautySmooth.toInt()}%)', style: const TextStyle(color: Colors.pinkAccent, fontSize: 10)),
                  ],
                ),
              ),
            ),
          ),
          Positioned(top: 40, right: 16, width: 85, height: 115, child: ClipRRect(borderRadius: BorderRadius.circular(8), child: _cam ?? const CircularProgressIndicator())),
          Positioned(top: 40, left: 16, child: IconButton(icon: const Icon(Icons.flag, color: Colors.redAccent), onPressed: _showReportDialog)),
          Positioned(
            top: 40,
            left: 70,
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
                IconButton(icon: const Icon(Icons.face_retouching_natural, color: Colors.amberAccent, size: 28), onPressed: _showBeautyDialog),
                IconButton(icon: const Icon(Icons.flip_camera_ios, color: Colors.white), onPressed: () => ZegoExpressEngine.instance.useFrontCamera(_frontCam = !_frontCam)),
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

class Host {
  final String name, city, views, cat, pic, bio;
  const Host({required this.name, required this.city, required this.views, required this.cat, required this.pic, required this.bio});
}
class HostRank {
  final int rank;
  final String name, pic, gems;
  const HostRank({required this.rank, required this.name, required this.pic, required this.gems});
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _cat = 0;
  int _gems = 1670;
  String _userName = 'User7789';
  String _userBio = 'VIP Member & Live Chat Lover';
  int _hostEarningsINR = 12500;
  int _hostGemsEarned = 25000;

  final List<String> _history = ['Recharge: +4050 Gems', 'Video Call: -1800 Gems'];
  final List<Host> _favorites = [];
  final List<Map<String, String>> _notifications = [
    {'title': 'VIP Bonus Unlocked!', 'desc': 'Claim +500 free gems in profile tab.', 'time': '10m ago'},
    {'title': 'New Host Alert', 'desc': 'Pooja is live now in Hot Live category.', 'time': '1h ago'},
    {'title': 'Recharge Offer', 'desc': 'Get +25% extra gems on ₹1000 pack today.', 'time': '3h ago'},
  ];
  final List<HostRank> _leaderboard = const [
    HostRank(rank: 1, name: 'Ananya', pic: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200', gems: '145k 💎'),
    HostRank(rank: 2, name: 'Pooja', pic: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200', gems: '120k 💎'),
    HostRank(rank: 3, name: 'Divya', pic: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200', gems: '98k 💎'),
  ];

  final _cats = const ['Popular', 'Hot Live', 'Party Match', 'Nearby'];
  final List<Host> _allHosts = const [
    Host(name: 'Pooja', city: 'Mumbai', views: '3.2k', cat: 'Popular', pic: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200', bio: 'Model & live streamer ❤️'),
    Host(name: 'Ananya', city: 'Delhi', views: '5.1k', cat: 'Hot Live', pic: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200', bio: 'Dance lover ✨'),
  ];
  final _packs = const [
    {'gems': 4050, 'price': 100, 'tag': ''},
    {'gems': 8100, 'price': 200, 'tag': 'Popular'},
    {'gems': 21000, 'price': 500, 'tag': '+15% Extra'},
    {'gems': 45000, 'price': 1000, 'tag': '+25% Extra'},
    {'gems': 95000, 'price': 2000, 'tag': 'Best Value'},
    {'gems': 250000, 'price': 5000, 'tag': 'Mega VIP'},
  ];

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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Notifications & Activity 🔔', style: TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
                Icon(Icons.mark_email_read, color: Colors.pink),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _notifications.length,
                itemBuilder: (ctx, i) {
                  final n = _notifications[i];
                  return Card(
                    color: Colors.grey[850],
                    child: ListTile(
                      leading: const Icon(Icons.notifications_active, color: Colors.pinkAccent),
                      title: Text(n['title']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text(n['desc']!, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      trailing: Text(n['time']!, style: const TextStyle(color: Colors.white54, fontSize: 10)),
                    ),
                  );
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
            const SizedBox(height: 16),
            const Text('Payout Method: UPI / Bank Transfer', style: TextStyle(color: Colors.white54, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), style: TextButton.styleFrom(foregroundColor: Colors.white), child: const Text('Close')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payout request submitted for ₹12,500!')));
            },
            child: const Text('Request Payout'),
          ),
        ],
      ),
    );
  }

  void _showSummary(String host, String dur, int sec) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey,
        title: Text('Call Ended with $host', style: const TextStyle(color: Colors.white)),
        content: Text('Duration: $dur\nBalance: $_gems 💎', style: const TextStyle(color: Colors.white70)),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
      ),
    );
  }

  void _toggleFavorite(Host h) {
    setState(() {
      if (_favorites.contains(h)) {
        _favorites.remove(h);
      } else {
        _favorites.add(h);
      }
    });
  }

  void _openRandomMatch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RandomMatchScreen(
          onMatched: (n, p) {
            Navigator.pop(context);
            _dial(n, p);
          },
        ),
      ),
    );
  }
    void _editProfile() {
    final nameCtrl = TextEditingController(text: _userName);
    final bioCtrl = TextEditingController(text: _userBio);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: bioCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Bio')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _userName = nameCtrl.text;
                _userBio = bioCtrl.text;
              });
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showHostProfile(Host h) {
    final isFav = _favorites.contains(h);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 35, backgroundImage: NetworkImage(h.pic)),
            const SizedBox(height: 8),
            Text(h.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            Text(h.bio, style: const TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () { Navigator.pop(ctx); _toggleFavorite(h); },
                  child: Text(isFav ? 'Favorited' : 'Favorite', style: const TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () { Navigator.pop(ctx); _dial(h.name, h.pic); },
                  child: const Text('Call'),
                ),
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
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        height: 420,
        child: Column(
          children: [
            const Text('Recharge Gems 💎', style: TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2.2, crossAxisSpacing: 10, mainAxisSpacing: 10),
                itemCount: _packs.length,
                itemBuilder: (ctx, i) {
                  final p = _packs[i];
                  final tag = p['tag'] as String;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _gems += (p['gems'] as int);
                        _history.insert(0, 'Recharge: +${p['gems']} Gems');
                      });
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      decoration: BoxDecoration(color: Colors.grey[850], borderRadius: BorderRadius.circular(12), border: tag.isNotEmpty ? Border.all(color: Colors.pink, width: 1.5) : null),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(children: [const Icon(Icons.diamond, color: Colors.amber, size: 16), const SizedBox(width: 4), Text('${p['gems']} Gems', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
                              const SizedBox(height: 4),
                              Text('₹${p['price']}', style: const TextStyle(color: Colors.greenAccent, fontSize: 14)),
                            ],
                          ),
                          if (tag.isNotEmpty) Positioned(top: 0, right: 0, child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.pink, borderRadius: BorderRadius.circular(6)), child: Text(tag, style: const TextStyle(color: Colors.white, fontSize: 8))))
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _dial(String n, String p) {
    if (_gems >= 1800) {
      setState(() {
        _gems -= 1800;
        _history.insert(0, 'Video Call with $n: -1800 Gems');
      });
      Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen(host: n, pic: p, gems: _gems, onGems: (g) => setState(() => _gems = g), onEnd: (d, s) => _showSummary(n, d, s))));
    } else {
      _recharge();
    }
  }

  @override
  Widget build(BuildContext context) {
    final curCat = _cats[_cat];
    final list = _allHosts.where((h) => _cat == 0 || h.cat == curCat).toList();

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Fizz Live Pro'),
          actions: [
            IconButton(icon: const Icon(Icons.notifications, color: Colors.amber), onPressed: _showNotifications),
            TextButton(
              onPressed: _recharge,
              child: Text('💎 $_gems', style: const TextStyle(color: Colors.amber)),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.pink,
            labelColor: Colors.pink,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.favorite)),
              Tab(icon: Icon(Icons.emoji_events, textAttr: 'Ranking')),
              Tab(icon: Icon(Icons.chat)),
              Tab(icon: Icon(Icons.person)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 38,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _cats.length,
                    itemBuilder: (ctx, i) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ActionChip(
                        label: Text(_cats[i]),
                        backgroundColor: _cat == i ? Colors.pink : Colors.grey,
                        onPressed: () => setState(() => _cat = i),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                    onPressed: _openRandomMatch,
                    child: const Text('Random Match (1800 gems)'),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                    ),
                    padding: const EdgeInsets.all(6),
                    itemCount: list.length,
                    itemBuilder: (ctx, i) {
                      final h = list[i];
                      return GestureDetector(
                        onTap: () => _showHostProfile(h),
                        child: Card(
                          color: Colors.grey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundImage: NetworkImage(h.pic),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                h.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => _dial(h.name, h.pic),
                                child: const Text(
                                  'Call',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            _favorites.isEmpty
                ? const Center(child: Text('No Favorites yet!', style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    itemCount: _favorites.length,
                    itemBuilder: (ctx, i) {
                      final h = _favorites[i];
                      return ListTile(
                        leading: CircleAvatar(backgroundImage: NetworkImage(h.pic)),
                        title: Text(h.name, style: const TextStyle(color: Colors.white)),
                        trailing: ElevatedButton(
                          onPressed: () => _dial(h.name, h.pic),
                          child: const Text('Call'),
                        ),
                      );
                    },
                  ),
            // Leaderboard / Ranking Tab
            ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _leaderboard.length,
              itemBuilder: (ctx, i) {
                final r = _leaderboard[i];
                final color = r.rank == 1 ? Colors.amber : (r.rank == 2 ? Colors.white70 : Colors.brown);
                return Card(
                  color: Colors.grey[900],
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: color, child: Text('#${r.rank}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                    title: Row(
                      children: [
                        CircleAvatar(backgroundImage: NetworkImage(r.pic), radius: 18),
                        const SizedBox(width: 8),
                        Text(r.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    trailing: Text(r.gems, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
            ListView.builder(
              itemCount: _allHosts.length,
              itemBuilder: (ctx, i) {
                final h = _allHosts[i];
                return ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(h.pic)),
                  title: Text(h.name, style: const TextStyle(color: Colors.white)),
                  onTap: () => _dial(h.name, h.pic),
                );
              },
            ),
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(radius: 30, child: Icon(Icons.person)),
                      const SizedBox(height: 6),
                      Text(_userName, style: const TextStyle(color: Colors.white, fontSize: 16)),
                      Text(_userBio, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                      const SizedBox(height: 6),
                      const Text('👑 VIP Lv.5', style: TextStyle(color: Colors.amber)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  color: Colors.grey[850],
                  child: ListTile(
                    leading: const Icon(Icons.account_balance_wallet, color: Colors.greenAccent),
                    title: Text('Host Earnings: ₹$_hostEarningsINR', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text('Gems Earned: $_hostGemsEarned 💎', style: const TextStyle(color: Colors.amber)),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: _showPayoutModal,
                      child: const Text('Payout'),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _editProfile,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                  child: const Text('Edit Profile'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _showNotifications,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800]),
                  child: const Text('Activity & Notifications 🔔'),
                ),
                const SizedBox(height: 20),
                const Text('Wallet History:', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16)),
                ..._history.map((item) => Card(color: Colors.grey, child: ListTile(title: Text(item, style: const TextStyle(color: Colors.white))))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
