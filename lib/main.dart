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
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.live_tv, size: 70, color: Colors.pinkAccent),
            SizedBox(height: 10),
            Text('FIZZ LIVE PRO', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
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
              onPressed: () { Navigator.pop(ctx); Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Dashboard())); },
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
      if (_sec > 0 && _sec % 60 == 0) { if (_g >= 1800) { setState(() => _g -= 1800); widget.onGems(_g); } else { Navigator.pop(context); } }
    });
  }

  Future<void> _initZego() async {
    await ZegoExpressEngine.createEngineWithProfile(ZegoEngineProfile(710176630, ZegoScenario.StandardVideoCall, appSign: '0b8b0f4adab85c101698f21f4e7c7b1aa477c901ac58d80a75e54c17ed05ad8a'));
    await ZegoExpressEngine.instance.enableCamera(true);
    await ZegoExpressEngine.instance.useFrontCamera(true);
    final w = await ZegoExpressEngine.instance.createCanvasView((id) { _vid = id; ZegoExpressEngine.instance.startPreview(canvas: ZegoCanvas(id)); });
    if (mounted) setState(() => _cam = w);
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
          Positioned.fill(child: Image.network(widget.pic, fit: BoxFit.cover)),
          Positioned(top: 40, right: 16, width: 85, height: 115, child: ClipRRect(borderRadius: BorderRadius.circular(8), child: _cam ?? const CircularProgressIndicator())),
          Positioned(bottom: 20, left: 0, right: 0, child: Center(child: IconButton(icon: const Icon(Icons.call_end, color: Colors.red, size: 36), onPressed: () => Navigator.pop(context)))),
        ],
      ),
    );
  }
}

class HostProfileSheet extends StatelessWidget {
  final Host host;
  final int gems;
  final Function(int) onGemsUpdate;
  const HostProfileSheet({super.key, required this.host, required this.gems, required this.onGemsUpdate});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      height: 480,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 30, backgroundImage: NetworkImage(host.pic)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [Text(host.name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(width: 6), const Text('🇮🇳', style: TextStyle(fontSize: 16))]),
                  Text('ID: ${host.id}  •  🟢 Active', style: const TextStyle(color: Colors.greenAccent, fontSize: 11)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.pink.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
            child: const Text('Delhi • 34 yrs old', style: TextStyle(color: Colors.pinkAccent, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          const Text('Introduction:', style: TextStyle(color: Colors.white54, fontSize: 11)),
          const Text('main tumhen chaahati hoon. aap kitane hot hain. mere hothon ko chhuo...', style: TextStyle(color: Colors.white, fontSize: 12)),
          const SizedBox(height: 12),
          const Text('Interest tag:', style: TextStyle(color: Colors.white54, fontSize: 11)),
          Wrap(spacing: 6, children: ['sexy body', 'fun show baby', 'dirtytalk'].map((t) => Chip(label: Text(t, style: const TextStyle(fontSize: 10)), backgroundColor: Colors.grey[800], labelStyle: const TextStyle(color: Colors.white))).toList()),
          const SizedBox(height: 12),
          const Text('Speaking language: English Hindi', style: TextStyle(color: Colors.white70, fontSize: 11)),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                  icon: const Icon(Icons.videocam, size: 18),
                  label: const Text('Video Call • 1800/min', style: TextStyle(fontSize: 12)),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen(host: host.name, pic: host.pic, gems: gems, onGems: onGemsUpdate, onEnd: (_, __, ___) {})));
                  },
                ),
              ),
              const SizedBox(width: 10),
              CircleAvatar(backgroundColor: Colors.grey[800], child: const Icon(Icons.message, color: Colors.white, size: 18)),
            ],
          ),
        ],
      ),
    );
  }
}

class LiveStreamPKRoom extends StatefulWidget {
  final Host host;
  final bool isPK;
  final int gems;
  final Function(int) onGemsUpdate;
  final Function(String) onCloseWithPiP;
  const LiveStreamPKRoom({super.key, required this.host, required this.isPK, required this.gems, required this.onGemsUpdate, required this.onCloseWithPiP});

  @override
  State<LiveStreamPKRoom> createState() => _LiveStreamPKRoomState();
}

class _LiveStreamPKRoomState extends State<LiveStreamPKRoom> {
  final List<Map<String, String>> _messages = [
    {'user': 'bosi', 'msg': 'mystery too.... Hi!'},
    {'user': 'system', 'msg': 'Rules apply!'},
  ];
  final _msgCtrl = TextEditingController();
  bool _followed = false;

  void _sendMessage() {
    if (_msgCtrl.text.trim().isNotEmpty) {
      setState(() { _messages.add({'user': 'You', 'msg': _msgCtrl.text.trim()}); _msgCtrl.clear(); });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(child: Image.network(widget.host.pic, fit: BoxFit.cover)),
          // Top Left Profile & Heart follow icon
          Positioned(
            top: 40, left: 16,
            child: Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(widget.host.pic), radius: 18),
                const SizedBox(width: 6),
                Text('${widget.host.name} 🇮🇳', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(width: 6),
                InkWell(onTap: () => setState(() => _followed = !_followed), child: Icon(Icons.favorite, color: _followed ? Colors.pink : Colors.white70, size: 18)),
              ],
            ),
          ),
          // Top Right Viewer count '5' & Close X
          Positioned(
            top: 40, right: 16,
            child: Row(
              children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)), child: const Text('👁️ 5', style: TextStyle(color: Colors.white, fontSize: 11))),
                const SizedBox(width: 8),
                IconButton(icon: const CircleAvatar(radius: 12, backgroundColor: Colors.black54, child: Icon(Icons.close, color: Colors.white, size: 14)), onPressed: () { widget.onCloseWithPiP(widget.host.name); Navigator.pop(context); }),
              ],
            ),
          ),
          // Ad placeholder place slot (tiny banner slot top right/mid)
          Positioned(top: 80, right: 16, child: Container(width: 80, height: 35, color: Colors.black45, alignment: Alignment.center, child: const Text('AD SLOT', style: TextStyle(color: Colors.white54, fontSize: 9)))),
          // Bottom Left Message Input
          Positioned(
            bottom: 20, left: 16, width: MediaQuery.of(context).size.width * 0.52,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    decoration: InputDecoration(filled: true, fillColor: Colors.black54, hintText: 'Say something...', hintStyle: const TextStyle(color: Colors.white54, fontSize: 11), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                  ),
                ),
              ],
            ),
          ),
          // Bottom Right Gift Send + Video Call icon
          Positioned(
            bottom: 20, right: 16,
            child: Row(
              children: [
                CircleAvatar(backgroundColor: Colors.pink, radius: 18, child: const Icon(Icons.card_giftcard, size: 18, color: Colors.white)),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CallScreen(host: widget.host.name, pic: widget.host.pic, gems: widget.gems, onGems: widget.onGemsUpdate, onEnd: (_, __, ___) {})));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.pink, Colors.amber]), borderRadius: BorderRadius.circular(20)),
                    child: const Row(children: [Icon(Icons.videocam, color: Colors.white, size: 14), SizedBox(width: 4), Text('1800/min', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))]),
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

class Host {
  final String name, pic, cat, tag, flag, status;
  final int id;
  const Host({required this.name, required this.pic, required this.cat, required this.tag, required this.flag, required this.status, required this.id});
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
  int _navIndex = 0;
  int _cat = 0;
  int _subCat = 0; // 0=All, 1=Pretty, 2=New, 3=Sexy
  int _gems = 1670;
  String _selectedCountry = '🇮🇳 India';

  bool _hasMiniPlayer = false;
  String _miniStreamerName = '';
  String _miniStreamerPic = '';

  final List<String> _cats = const ['Hot', 'Live', 'Party', 'Match'];
  final List<String> _subCats = const ['All', 'Pretty', 'New', 'Sexy'];

  final List<Host> _allHosts = const [
    Host(name: 'AvniHotnessDil', pic: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300', cat: 'Hot', tag: 'Exotic', flag: '🇮🇳', status: 'Online', id: 8002023),
    Host(name: 'Shiny Sanya', pic: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=300', cat: 'Hot', tag: 'Party', flag: '🇮🇳', status: 'Online', id: 8002024),
    Host(name: 'Ritaj', pic: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=300', cat: 'Live', tag: 'Exotic', flag: '🇦🇪', status: 'Live', id: 8002025),
    Host(name: 'Moka', pic: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=300', cat: 'Live', tag: 'Pretty', flag: '🇪🇬', status: 'Live', id: 8002026),
  ];

  final _exactPacks = const [
    {'gems': 4050, 'price': 100.0, 'tag': '17% of'},
    {'gems': 8100, 'price': 200.0, 'tag': '17% of'},
    {'gems': 16380, 'price': 400.0, 'tag': '17% of'},
    {'gems': 32940, 'price': 800.0, 'tag': '17% of'},
  ];

  void _showRechargeModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        height: 380,
        child: Column(
          children: [
            const Text('Recharge and continue💋', style: TextStyle(color: Colors.white70, fontSize: 11)),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2.0, crossAxisSpacing: 10, mainAxisSpacing: 10),
                itemCount: _exactPacks.length,
                itemBuilder: (ctx, i) {
                  final p = _exactPacks[i];
                  return Container(
                    decoration: BoxDecoration(color: Colors.grey[850], borderRadius: BorderRadius.circular(12)),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('${p['gems']} 💎', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text('₹${p['price']}', style: const TextStyle(color: Colors.greenAccent))]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openRoom(Host h) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => LiveStreamPKRoom(host: h, isPK: false, gems: _gems, onGemsUpdate: (g) => setState(() => _gems = g), onCloseWithPiP: (closed) { setState(() => _hasMiniPlayer = true); _miniStreamerName = closed; _miniStreamerPic = h.pic; })));
  }

  @override
  Widget build(BuildContext context) {
    // Filter hosts by selected category tab & subfolder (Pretty, New, Sexy)
    final catName = _cats[_cat];
    final list = _allHosts.where((h) {
      if (h.cat != catName && catName != 'Live') return true;
      if (_subCat > 0 && h.tag.toLowerCase() != _subCats[_subCat].toLowerCase()) return false;
      return true;
    }).toList();

    Widget bodyContent = Column(
      children: [
        // Sub-categories row (Pretty, New, Sexy) for Hot/Live folders
        if (_cat == 0 || _cat == 1)
          Container(
            color: Colors.black87,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: Row(
              children: _subCats.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ChoiceChip(
                  label: Text(e.value, style: const TextStyle(fontSize: 11)),
                  selected: _subCat == e.key,
                  selectedColor: Colors.pink,
                  backgroundColor: Colors.grey[900],
                  labelStyle: TextStyle(color: _subCat == e.key ? Colors.white : Colors.white70),
                  onSelected: (_) => setState(() => _subCat = e.key),
                ),
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
                onTap: () => showModalBottomSheet(context: context, builder: (_) => HostProfileSheet(host: h, gems: _gems, onGemsUpdate: (g) => setState(() => _gems = g))),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(h.pic, fit: BoxFit.cover),
                      Positioned(top: 6, left: 6, child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)), child: Text('${h.flag} ${h.status}', style: const TextStyle(color: Colors.white, fontSize: 9)))),
                      Positioned(top: 6, right: 6, child: InkWell(onTap: () => _openRoom(h), child: const CircleAvatar(radius: 12, backgroundColor: Colors.pink, child: Icon(Icons.videocam, size: 12, color: Colors.white)))),
                      Positioned(bottom: 6, left: 6, child: Text(h.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: _cats.asMap().entries.map((e) => GestureDetector(
            onTap: () => setState(() { _cat = e.key; _subCat = 0; }),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(e.value, style: TextStyle(color: _cat == e.key ? Colors.pink : Colors.white70, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          )).toList(),
        ),
        actions: [
          Center(child: Text(_selectedCountry, style: const TextStyle(fontSize: 11, color: Colors.amber))),
          IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
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
                onTap: () { setState(() => _hasMiniPlayer = false); },
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'For You'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Follow'),
          BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'Live'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}
