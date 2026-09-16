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
            const SizedBox(height: 14),
            const Text('FIZZ LIVE PRO', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFFD700))),
            const SizedBox(height: 4),
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
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.admin_panel_settings, size: 55, color: Color(0xFFFFD700)),
              const SizedBox(height: 12),
              const Text('Admin PIN (7777)', style: TextStyle(fontSize: 18, color: Colors.white)),
              const SizedBox(height: 12),
              TextField(
                controller: _c,
                keyboardType: TextInputType.number,
                obscureText: true,
                textAlign: TextAlign.center,
                maxLength: 4,
                style: const TextStyle(color: Color(0xFFFFD700), fontSize: 22),
                decoration: const InputDecoration(counterText: "", filled: true, fillColor: Color(0xFF14141E), hintText: "••••"),
              ),
              if (_msg.isNotEmpty) Text(_msg, style: const TextStyle(color: Colors.redAccent)),
              const SizedBox(height: 14),
              ElevatedButton(onPressed: _check, child: const Text('Unlock')),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
            const SizedBox(height: 14),
            const Text('Meet Real Friends Nearby', style: TextStyle(color: Colors.white, fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await [Permission.camera, Permission.microphone].request();
                if (context.mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Dashboard()));
              },
              child: const Text('Fast Login & Allow Permissions'),
            ),
          ],
        ),
      ),
    );
  }
}

class IncomingCallScreen extends StatelessWidget {
  final String host;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  const IncomingCallScreen({super.key, required this.host, required this.onAccept, required this.onDecline});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D15),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 16),
            Text(host, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Incoming Video Call... (1800/min)', style: TextStyle(color: Colors.greenAccent, fontSize: 13)),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(icon: const Icon(Icons.call_end, color: Colors.red, size: 36), onPressed: onDecline),
                IconButton(icon: const Icon(Icons.videocam, color: Colors.green, size: 36), onPressed: onAccept),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChatDetailScreen extends StatefulWidget {
  final String host;
  final VoidCallback onCall;
  const ChatDetailScreen({super.key, required this.host, required this.onCall});
  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _msgCtrl = TextEditingController();
  final List<String> _chat = ['Host: Hi dear! Call me live ❤️'];
  void _send() {
    if (_msgCtrl.text.isEmpty) return;
    setState(() => _chat.add('You: ${_msgCtrl.text}'));
    _msgCtrl.clear();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _chat.add('Host: Waiting in video call, tap call above! 😘'));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07070A),
      appBar: AppBar(
        title: Text(widget.host),
        actions: [IconButton(icon: const Icon(Icons.videocam, color: Colors.pink), onPressed: widget.onCall)],
      ),
      body: Column(
        children: [
          Expanded(child: ListView(padding: const EdgeInsets.all(12), children: [for (var m in _chat) Text(m, style: const TextStyle(color: Colors.white, fontSize: 16))])),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _msgCtrl, style: const TextStyle(color: Colors.white))),
                IconButton(icon: const Icon(Icons.send, color: Colors.amber), onPressed: _send),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CallScreen extends StatefulWidget {
  final String host;
  final String room;
  final int userGems;
  final Function(int) onGems;
  const CallScreen({super.key, required this.host, required this.room, required this.userGems, required this.onGems});
  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  Widget? _myCam;
  int? _vid;
  late int _gems;
  String _gift = "";

  @override
  void initState() {
    super.initState();
    _gems = widget.userGems;
    _startPreview();
  }

  Future<void> _startPreview() async {
    const appID = 710176630;
    const appSign = '0b8b0f4adab85c101698f21f4e7c7b1aa477c901ac58d80a75e54c17ed05ad8a';
    await ZegoExpressEngine.createEngineWithProfile(ZegoEngineProfile(appID, ZegoScenario.StandardVideoCall, appSign: appSign));
    await ZegoExpressEngine.instance.createCanvasView((id) {
      _vid = id;
      ZegoExpressEngine.instance.startPreview(canvas: ZegoCanvas(id));
    }).then((w) => setState(() => _myCam = w));
  }

  void _sendGift(String name, int cost, String em) {
    if (_gems >= cost) {
      setState(() { _gems -= cost; _gift = "Sent $em $name!"; });
      widget.onGems(_gems);
      Future.delayed(const Duration(seconds: 2), () { if (mounted) setState(() => _gift = ""); });
    }
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
              color: const Color(0xFF101018),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 55)),
                  const SizedBox(height: 10),
                  Text('${widget.host} is speaking...', style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Live Stream • 1800/min', style: TextStyle(color: Colors.greenAccent, fontSize: 12)),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            width: 90,
            height: 125,
            child: ClipRRect(borderRadius: BorderRadius.circular(10), child: _myCam ?? const Center(child: CircularProgressIndicator())),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(widget.host, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                if (_gift.isNotEmpty) Container(margin: const EdgeInsets.only(left: 16), padding: const EdgeInsets.all(8), color: Colors.pink, child: Text(_gift, style: const TextStyle(color: Colors.white))),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(icon: const Icon(Icons.call_end, color: Colors.red, size: 36), onPressed: () => Navigator.pop(context)),
                    IconButton(icon: const Icon(Icons.card_giftcard, color: Colors.amber, size: 36), onPressed: () => _sendGift('Car', 1000, '🏎️')),
                  ],
                ),
                const SizedBox(height: 16),
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
  bool _incomingShown = false;

  final _cats = const ['Popular', 'Nearby', 'New', 'Follow'];
  final _hosts = const [
    {'name': 'Pooja', 'city': 'Mumbai', 'lvl': 'Lv.7', 'bio': 'Dancer & model ❤️', 'fans': '14.2k'},
    {'name': 'Ananya', 'city': 'Delhi', 'lvl': 'Lv.9', 'bio': 'Free now, call me 😘', 'fans': '28.9k'},
    {'name': 'Sneha', 'city': 'Chennai', 'lvl': 'Lv.6', 'bio': 'Tamil ponnu ✨', 'fans': '9.8k'},
    {'name': 'Kavya', 'city': 'Bangalore', 'lvl': 'Lv.8', 'bio': 'Party lover!', 'fans': '19.4k'},
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
    _scheduleFakeIncoming();
  }

  void _scheduleFakeIncoming() {
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted && !_incomingShown) {
        _incomingShown = true;
        final h = _hosts[Random().nextInt(_hosts.length)]['name']!;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => IncomingCallScreen(
              host: h,
              onAccept: () {
                Navigator.pop(context);
                _dial(h);
              },
              onDecline: () => Navigator.pop(context),
            ),
          ),
        );
      }
    });
  }

  void _recharge() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('My Gems: $_gems', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          for (var p in _packs)
            ListTile(
              title: Text('${p['gems']} Gems'),
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

  void _showWithdraw() {
    final upiCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF14141E),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Cashout / Withdraw', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Available Balance: $_gems Gems', style: const TextStyle(color: Color(0xFFFFD700))),
            const SizedBox(height: 12),
            TextField(
              controller: upiCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(hintText: 'Enter UPI ID (e.g. name@upi)', hintStyle: TextStyle(color: Colors.grey), filled: true, fillColor: Color(0xFF1E1E2C)),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Withdrawal request submitted!'), backgroundColor: Colors.green));
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _dial(String name) {
    if (_gems >= 1800) {
      setState(() => _gems -= 1800);
      Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen(host: name, room: 'room_${name.toLowerCase()}', userGems: _gems, onGems: (g) => setState(() => _gems = g))));
    } else {
      _recharge();
    }
  }

  void _openProfile(Map<String, String> h) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF101018),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(radius: 34, child: Icon(Icons.person, size: 36)),
            const SizedBox(height: 8),
            Text('${h['name']} • ${h['lvl']}', style: const TextStyle(color: Colors.white, fontSize: 18)),
            Text('${h['city']} • ${h['fans']} Fans', style: const TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 8),
            Text(h['bio']!, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Follow'))),
                const SizedBox(width: 10),
                Expanded(child: ElevatedButton(onPressed: () { Navigator.pop(ctx); _dial(h['name']!); }, child: const Text('Call (1800)'))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _body() {
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
                onPressed: () => _dial(_hosts[Random().nextInt(_hosts.length)]['name']!),
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
                          Text(h['name']!, style: const TextStyle(color: Colors.white)),
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
              trailing: ElevatedButton(onPressed: () => _dial(h['name']!), child: const Text('Call')),
            ),
        ],
      );
    } else if (_tab == 2) {
      return Center(
        child: ElevatedButton(onPressed: () => setState(() => _gems += 150), child: const Text('Play Spin & Win 150 Gems')),
      );
    } else if (_tab == 3) {
      return ListView(
        children: [
          for (var h in _hosts)
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(h['name']!, style: const TextStyle(color: Colors.white)),
              subtitle: const Text('Online • Tap to chat', style: TextStyle(color: Colors.greenAccent)),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatDetailScreen(host: h['name']!, onCall: () => _dial(h['name']!)))),
            ),
        ],
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 34, chil
