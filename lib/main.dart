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
            if (type == 'Google') ListTile(leading: const Icon(Icons.g_mobiledata, color: Colors.amber, size: 32), title: const Text('Chandran S (chandran6222@gmail.com)', style: TextStyle(color: Colors.white)), onTap: () { Navigator.pop(ctx); Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Dashboard())); }),
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
      setState(() {
        _g -= cost;
        _gift = 'Sent $em $name!';
      });
      widget.onGems(_g);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _gift = '');
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

  @override
  void dispose() {
    _t?.cancel();
    _netTimer?.cancel();
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
              decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(widget.pic), fit: BoxFit.cover)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(radius: 40, backgroundImage: NetworkImage(widget.pic)),
                    const SizedBox(height: 8),
                    Text(widget.host, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('${_sec ~/ 60}:${(_sec % 60).toString().padLeft(2, '0')}', style: const TextStyle(color: Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.bold)),
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

class LiveStreamDualRoom extends StatefulWidget {
  final String streamer1Name, streamer1Pic, streamer2Name, streamer2Pic;
  final bool isDual;
  final Function(String) onCloseWithPiP;
  const LiveStreamDualRoom({
    super.key,
    required this.streamer1Name,
    required this.streamer1Pic,
    required this.streamer2Name,
    required this.streamer2Pic,
    required this.isDual,
    required this.onCloseWithPiP,
  });

  @override
  State<LiveStreamDualRoom> createState() => _LiveStreamDualRoomState();
}

class _LiveStreamDualRoomState extends State<LiveStreamDualRoom> {
  final List<Map<String, String>> _messages = [
    {'user': 'Rahul', 'msg': 'Hi super! 💖'},
    {'user': 'Kavi', 'msg': 'Awesome live! 🔥'},
  ];
  final TextEditingController _msgCtrl = TextEditingController();
  bool _isFollowing = false;

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
            child: widget.isDual
                ? Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(widget.streamer1Name == 'Anitha' ? 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200' : widget.streamer1Pic), fit: BoxFit.cover)),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(color: Colors.black54, padding: const EdgeInsets.all(6), child: Text(widget.streamer1Name, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))),
                          ),
                        ),
                      ),
                      Container(width: 2, color: Colors.pinkAccent),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(widget.streamer2Pic), fit: BoxFit.cover)),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(color: Colors.black54, padding: const EdgeInsets.all(6), child: Text(widget.streamer2Name, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(widget.streamer1Pic), fit: BoxFit.cover)),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(color: Colors.black54, padding: const EdgeInsets.all(12), child: Text(widget.streamer1Name, style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold))),
                    ),
                  ),
          ),
          Positioned(
            top: 40, left: 16, right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(backgroundImage: NetworkImage(widget.streamer1Pic)),
                    const SizedBox(width: 8),
                    Text(widget.streamer1Name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: _isFollowing ? Colors.grey : Colors.pink, minimumSize: const Size(60, 30)),
                      onPressed: () => setState(() => _isFollowing = !_isFollowing),
                      child: Text(_isFollowing ? 'Following' : 'Follow', style: const TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
                IconButton(
                  icon: const CircleAvatar(backgroundColor: Colors.black54, child: Icon(Icons.close, color: Colors.white, size: 18)),
                  onPressed: () {
                    widget.onCloseWithPiP(widget.streamer1Name);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 80, left: 16, right: 100, height: 150,
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (ctx, i) {
                final m = _messages[i];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(8)),
                  child: Text('${m['user']}: ${m['msg']}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                );
              },
            ),
          ),
          Positioned(
            bottom: 20, left: 16, right: 16,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true, fillColor: Colors.grey[850], hintText: 'Say something...', hintStyle: const TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(icon: const Icon(Icons.send, color: Colors.pinkAccent), onPressed: _sendMessage),
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
  bool _dailyRewardClaimed = false;

  bool _hasMiniPlayer = false;
  String _miniStreamerName = '';
  String _miniStreamerPic = '';
  bool _isMiniDual = false;

  final List<String> _history = ['Recharge: +4050 Gems', 'Video Call: -1800 Gems'];
  final List<Host> _favorites = [];
  final List<Map<String, String>> _notifications = [
    {'title': 'VIP Bonus Unlocked!', 'desc': 'Claim +500 free gems in profile tab.', 'time': '10m ago'},
    {'title': 'New Host Alert', 'desc': 'Anitha & Malar are live in Co-Host mode!', 'time': '1h ago'},
  ];

  final _cats = const ['Hot', 'Live', 'Party', 'Match'];
  final List<Host> _allHosts = const [
    Host(name: 'Anitha', city: 'Chennai', views: '5.1k', cat: 'Live', pic: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200', bio: 'Full screen live stream ❤️'),
    Host(name: 'Malar', city: 'Madurai', views: '4.8k', cat: 'Live', pic: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200', bio: 'Co-host dual live partner ✨'),
    Host(name: 'Pooja', city: 'Mumbai', views: '3.2k', cat: 'Hot', pic: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200', bio: 'Model & live streamer 💋'),
    Host(name: 'Divya', city: 'Jaipur', views: '6.2k', cat: 'Party', pic: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200', bio: 'VIP Party Room 👑'),
  ];
  final _packs = const [
    {'gems': 4050, 'price': 100, 'tag': ''},
    {'gems': 8100, 'price': 200, 'tag': 'Popular'},
    {'gems': 21000, 'price': 500, 'tag': '+15% Extra'},
    {'gems': 45000, 'price': 1000, 'tag': '+25% Extra'},
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.card_giftcard, size: 50, color: Colors.pinkAccent),
            SizedBox(height: 10),
            Text('Sign in for daily bonuses!', style: TextStyle(color: Colors.white70, fontSize: 13)),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _dailyRewardClaimed ? Colors.grey : Colors.amber),
            onPressed: _dailyRewardClaimed ? null : () {
              setState(() {
                _gems += 40;
                _dailyRewardClaimed = true;
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Claimed +40 Gems!')));
            },
            child: Text(_dailyRewardClaimed ? 'Claimed' : 'Check-in (+40 Gems)'),
          ),
        ],
      ),
    );
  }

  void _openLiveRoom({required String name, required String pic, required bool isDual}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LiveStreamDualRoom(
          streamer1Name: name,
          streamer1Pic: pic,
          streamer2Name: 'Malar',
          streamer2Pic: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200',
          isDual: isDual,
          onCloseWithPiP: (closedStreamer) {
            setState(() {
              _hasMiniPlayer = true;
              _miniStreamerName = closedStreamer;
              _miniStreamerPic = pic;
              _isMiniDual = isDual;
            });
          },
        ),
      ),
    );
  }

  void _showHostProfile(Host h) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _openLiveRoom(name: h.name, pic: h.pic, isDual: false);
                  },
                  child: const Text('Live Stream'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _openLiveRoom(name: h.name, pic: h.pic, isDual: true);
                  },
                  child: const Text('Dual Live ⚡'),
                ),
              ],
            ),
          ],
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
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _gems += (p['gems'] as int);
                        _history.insert(0, 'Recharge: +${p['gems']} Gems');
                      });
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      decoration: BoxDecoration(color: Colors.grey[850], borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(children: [const Icon(Icons.diamond, color: Colors.amber, size: 16), const SizedBox(width: 4), Text('${p['gems']} Gems', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
                          const SizedBox(height: 4),
                          Text('₹${p['price']}', style: const TextStyle(color: Colors.greenAccent, fontSize: 14)),
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
      Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen(host: n, pic: p, gems: _gems, onGems: (g) => setState(() => _gems = g), onEnd: (d, s) {})));
    } else {
      _recharge();
    }
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
            IconButton(icon: const Icon(Icons.card_giftcard, color: Colors.pinkAccent), onPressed: _showDailyRewardDialog),
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
              Tab(icon: Icon(Icons.favorite), child: Text('For You', style: TextStyle(fontSize: 10))),
              Tab(icon: Icon(Icons.people), child: Text('Follow', style: TextStyle(fontSize: 10))),
              Tab(icon: Icon(Icons.live_tv), child: Text('Live', style: TextStyle(fontSize: 10))),
              Tab(icon: Icon(Icons.message), child: Text('Messages', style: TextStyle(fontSize: 10))),
              Tab(icon: Icon(Icons.person), child: Text('Me', style: TextStyle(fontSize: 10))),
            ],
          ),
        ),
        body: Stack(
          children: [
            TabBarView(
              children: [
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.8),
                  padding: const EdgeInsets.all(6),
                  itemCount: list.length,
                  itemBuilder: (ctx, i) {
                    final h = list[i];
                    return GestureDetector(
                      onTap: () => _showHostProfile(h),
                      child: Card(
                        color: Colors.grey[850],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(radius: 28, backgroundImage: NetworkImage(h.pic)),
                            const SizedBox(height: 4),
                            Text(h.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, minimumSize: const Size(60, 28)),
                                  onPressed: () => _openLiveRoom(name: h.name, pic: h.pic, isDual: false),
                                  child: const Text('Live', style: TextStyle(fontSize: 10)),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, minimumSize: const Size(60, 28)),
                                  onPressed: () => _openLiveRoom(name: h.name, pic: h.pic, isDual: true),
                                  child: const Text('Dual', style: TextStyle(fontSize: 10)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const Center(child: Text('No Followed hosts yet!', style: TextStyle(color: Colors.grey))),
                ListView.builder(
                  itemCount: _allHosts.length,
                  itemBuilder: (ctx, i) {
                    final h = _allHosts[i];
                    return ListTile(
                      leading: CircleAvatar(backgroundImage: NetworkImage(h.pic)),
                      title: Text('${h.name} - Live Stream', style: const TextStyle(color: Colors.white)),
                      subtitle: const Text('Tap to join live room 🎙️', style: TextStyle(color: Colors.amber, fontSize: 11)),
                      onTap: () => _openLiveRoom(name: h.name, pic: h.pic, isDual: false),
                    );
                  },
                ),
                ListView(
                  padding: const EdgeInsets.all(12),
                  children: const [
                    ListTile(leading: CircleAvatar(backgroundColor: Colors.pink, child: Icon(Icons.favorite)), title: Text('Like Me / Date', style: TextStyle(color: Colors.white)), subtitle: Text('Find your match 💖')),
                  ],
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
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (_hasMiniPlayer)
              Positioned(
                bottom: 20, right: 20,
                child: GestureDetector(
                  onTap: () {
                    setState(() => _hasMiniPlayer = false);
                    _openLiveRoom(name: _miniStreamerName, pic: _miniStreamerPic, isDual: _isMiniDual);
                  },
                  child: Container(
                    width: 130, height: 180,
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.pinkAccent, width: 2), boxShadow: const [BoxShadow(color: Colors.black87, blurRadius: 10)]),
                    child: Stack(
                      children: [
                        ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.network(_miniStreamerPic, fit: BoxFit.cover, width: 130, height: 180)),
                        Positioned(
                          top: 4, right: 4,
                          child: InkWell(
                            onTap: () => setState(() => _hasMiniPlayer = false),
                            child: const CircleAvatar(radius: 10, backgroundColor: Colors.black54, child: Icon(Icons.close, size: 12, color: Colors.white)),
                          ),
                        ),
                        Positioned(
                          bottom: 6, left: 6,
                          child: Text('Mini PiP 🎙️\n($_miniStreamerName)', style: const TextStyle(color: Colors.amber, fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
