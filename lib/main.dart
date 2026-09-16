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
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PinGate()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF07070A),
      body: Center(child: Icon(Icons.videocam, size: 70, color: Color(0xFFFF2E93))),
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
      if (mounted) setState(() => _chat.add('Host: I am waiting in video call, tap call above! 😘'));
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
  Widget? _v;
  int? _vid;
  late int _gems;
  String _gift = "";
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
                  child: Text('${widget.host} (1800/min)', style: const TextStyle(color: Colors.white, fontSize: 18)),
                ),
                if (_gift.isNotEmpty) Container(padding: const EdgeInsets.all(8), color: Colors.pink, child: Text(_gift, style: const TextStyle(color: Colors.white))),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(icon: const Icon(Icons.call_end, color: Colors.red, size: 36), onPressed: () => Navigator.pop(context)),
                    IconButton(icon: const Icon(Icons.card_giftcard, color: Colors.amber, size: 36), onPressed: () => _sendGift('Car', 1000, '🏎️')),
                  ],
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
  int _gems = 1670;
  final _hosts = const [
    {'name': 'Pooja', 'city': 'Mumbai', 'lvl': 'Lv.7'},
    {'name': 'Ananya', 'city': 'Delhi', 'lvl': 'Lv.9'},
    {'name': 'Sneha', 'city': 'Chennai', 'lvl': 'Lv.6'},
    {'name': 'Kavya', 'city': 'Bangalore', 'lvl': 'Lv.8'},
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

  void _dial(String name) {
    if (_gems >= 1800) {
      setState(() => _gems -= 1800);
      Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen(host: name, room: 'room_${name.toLowerCase()}', userGems: _gems, onGems: (g) => setState(() => _gems = g))));
    } else {
      _recharge();
    }
  }

  Widget _body() {
    if (_tab == 0) {
      return Column(
        children: [
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
                  Card(
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
            const CircleAvatar(radius: 34, child: Icon(Icons.person, size: 34)),
            const SizedBox(height: 8),
            Text('Gems: $_gems', style: const TextStyle(color: Colors.amber, fontSize: 20)),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _recharge, child: const Text('Buy Gems')),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07070A),
      appBar: AppBar(
        title: const Text('Fizz Live Pro'),
        actions: [TextButton(onPressed: _recharge, child: Text('💎 $_gems', style: const TextStyle(color: Colors.amber)))],
      ),
      body: _body(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'For You'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Follow'),
          NavigationDestination(icon: Icon(Icons.casino), label: 'Game'),
          NavigationDestination(icon: Icon(Icons.chat), label: 'Messages'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}
