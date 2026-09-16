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
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PinGate()),
        );
      }
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
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  'https://i.ibb.co/3k5fB0K/fizz-logo.png',
                  errorBuilder: (c, e, s) => const Icon(
                    Icons.videocam,
                    size: 60,
                    color: Colors.pink,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'FIZZ LIVE PRO',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            const Text(
              '18+ Private Live Video Chat',
              style: TextStyle(fontSize: 12, color: Colors.white54),
            ),
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
              const Text(
                'Admin PIN (7777)',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _c,
                keyboardType: TextInputType.number,
                obscureText: true,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.amber, fontSize: 22),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF14141E),
                  hintText: "••••",
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_c.text.trim() == "7777") {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const Login()),
                    );
                  }
                },
                child: const Text('Unlock'),
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
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await [Permission.camera, Permission.microphone].request();
            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Dashboard()),
              );
            }
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

  const LiveStreamRoom({
    super.key,
    required this.host,
    required this.gems,
    required this.onGems,
    required this.onCall,
  });

  @override
  State<LiveStreamRoom> createState() => _LiveStreamRoomState();
}

class _LiveStreamRoomState extends State<LiveStreamRoom> {
  late int _g;
  String _gift = "";
  int _likes = 120;
  final _chatCtrl = TextEditingController();
  final List<String> _roomChat = [
    'System: Welcome to Live Room! ❤️',
    'Pooja: Hello sweet friends!',
  ];
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
      if (mounted) {
        setState(() {
          if (_floatingHearts.isNotEmpty) _floatingHearts.removeAt(0);
        });
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _addHeart,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                widget.host['pic']!,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(color: Colors.grey[900]),
              ),
            ),
            Container(color: Colors.black38),
            ..._floatingHearts,
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(widget.host['pic']!),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.host['name']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '❤️ $_likes likes',
                              style: const TextStyle(
                                color: Colors.pinkAccent,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  if (_gift.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.pink,
                      child: Text(
                        _gift,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  const Spacer(),
                  Container(
                    height: 90,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ListView.builder(
                      itemCount: _roomChat.length,
                      itemBuilder: (ctx, i) => Text(
                        _roomChat[i],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _chatCtrl,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Tap screen to like ❤️',
                              filled: true,
                              fillColor: Colors.black54,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send, color: Colors.amber),
                          onPressed: () {
                            if (_chatCtrl.text.isNotEmpty) {
                              setState(() {
                                _roomChat.add('You: ${_chatCtrl.text}');
                              });
                              _chatCtrl.clear();
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.card_giftcard,
                            color: Colors.pink,
                          ),
                          onPressed: () => _sendGift('Car', 1000, '🏎️'),
                        ),
                        ElevatedButton(
                          onPressed: widget.onCall,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                          ),
                          child: const Text('Call'),
                        ),
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

  const CallScreen({
    super.key,
    required this.host,
    required this.pic,
    required this.gems,
    required this.onGems,
  });

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

  @override
  void initState() {
    super.initState();
    _g = widget.gems;
    _initZego();
  }

  Future<void> _initZego() async {
    await [Permission.camera, Permission.microphone].request();
    const appID = 710176630;
    const appSign =
        '0b8b0f4adab85c101698f21f4e7c7b1aa477c901ac58d80a75e54c17ed05ad8a';
    await ZegoExpressEngine.createEngineWithProfile(
      ZegoEngineProfile(
        appID,
        ZegoScenario.StandardVideoCall,
        appSign: appSign,
      ),
    );
    await ZegoExpressEngine.instance.enableCamera(true);
    await ZegoExpressEngine.instance.useFrontCamera(true);

    final v = await ZegoExpressEngine.instance.createCanvasView((id) {
      _viewID = id;
      ZegoExpressEngine.instance.startPreview(canvas: ZegoCanvas(id));
    });
    if (mounted) setState(() => _camView = v);
  }

  void _flipCam() async {
    _frontCam = !_frontCam;
    await ZegoExpressEngine.instance.useFrontCamera(_frontCam);
    setState(() {});
  }

  @override
  void dispose() {
    if (_viewID != null) {
      ZegoExpressEngine.instance.destroyCanvasView(_viewID!);
    }
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
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(_glow ? 0.3 : 0.5),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(widget.pic),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${widget.host} is live',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_glow)
                      const Text(
                        '✨ Glow Filter ON',
                        style: TextStyle(color: Colors.amber, fontSize: 11),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            width: 90,
            height: 125,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.pink, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _camView ??
                    const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.pink,
                      ),
                    ),
              ),
            ),
          ),
          if (_gift.isNotEmpty)
            Positioned(
              top: 100,
              left: 20,
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.pink,
                child: Text(
                  _gift,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(_mic ? Icons.mic : Icons.mic_off,
                      color: Colors.white),
                  onPressed: () {
                    setState(() => _mic = !_mic);
                    ZegoExpressEngine.instance.muteMicrophone(!_mic);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
                  onPressed: _flipCam,
                ),
                IconButton(
                  icon: Icon(
                    Icons.auto_awesome,
                    color: _glow ? Colors.amber : Colors.white,
                  ),
                  onPressed: () => setState(() => _glow = !_glow),
                ),
                IconButton(
                  icon: const Icon(Icons.call_end, color: Colors.red, size: 36),
                  onPressed: () => Navigator.pop(context),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.card_giftcard,
                    color: Colors.amber,
                    size: 34,
                  ),
                  onPressed: () {
                    if (_g >= 1000) {
                      setState(() {
                        _g -= 1000;
                        _gift = "Sent 🏎️ Car!";
                      });
                      widget.onGems(_g);
                    }
                  },
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

  final _cats = const ['Popular', 'Hot Live', 'Party Match', 'Nearby'];
  final _allHosts = const [
    {
      'name': 'Pooja',
      'city': 'Mumbai',
      'views': '3.2k',
      'cat': 'Popular',
      'pic':
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200'
    },
    {
      'name': 'Ananya',
      'city': 'Delhi',
      'views': '5.1k',
      'cat': 'Hot Live',
      'pic':
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200'
    },
    {
      'name': 'Sneha',
      'city': 'Chennai',
      'views': '2.4k',
      'cat': 'Party Match',
      'pic':
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200'
    },
    {
      'name': 'Kavya',
      'city': 'Bangalore',
      'views': '4.3k',
      'cat': 'Nearby',
      'pic':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200'
    },
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
          Text(
            'My Gems: $_gems',
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          for (var p in _packs)
            ListTile(
              leading: const Icon(Icons.diamond, color: Colors.amber),
              title: Text(
                '${p['gems']} Gems',
                style: const TextStyle(color: Colors.white),
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  setState(() => _gems += (p['gems'] as int));
                  Navigator.pop(ctx);
                },
                child: Text('₹${p['price']}'),
              ),
            ),
        ],
      ),
    );
  }

  void _dial(String name, String pic) {
    if (_gems >= 1800) {
      setState(() => _gems -= 1800);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CallScreen(
            host: name,
