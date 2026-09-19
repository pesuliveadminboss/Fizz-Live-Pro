import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Splash()));
}

class GiftItem {
  final String name, iconUrl, emoji;
  final int gems;
  const GiftItem(this.name, this.gems, {this.iconUrl = '', this.emoji = '🎁'});
}

final Map<String, List<GiftItem>> giftCategories = {
  'Hot': [
    const GiftItem('Champagne', 50, emoji: '🍾', iconUrl: 'https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=100'),
    const GiftItem('Loving Girl', 900, emoji: '💃', iconUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100'),
  ],
  'Lucky': [const GiftItem('Mystery Box', 360, emoji: '🎁')],
  'Svip': [],
  'Intimacy': [
    const GiftItem('In My Hand', 300, emoji: '🤝'),
    const GiftItem('Kiss', 180, emoji: '💋'),
  ],
  'Wealth': [const GiftItem('Cruise Eve', 3700, emoji: '🚢')],
  'Festival': [const GiftItem('Puppy', 180, emoji: '🐶')],
  'Bag': [const GiftItem('Rose', 20, emoji: '🌹')],
};

class Host {
  final String name, pic, cat, tag, flag, status;
  final int id;
  const Host({required this.name, required this.pic, required this.cat, required this.tag, required this.flag, required this.status, required this.id});
}

class PartyRoom {
  final String title, hostName, avatar, membersCount;
  final int onlineCount;
  const PartyRoom({required this.title, required this.hostName, required this.avatar, required this.membersCount, required this.onlineCount});
}

final List<PartyRoom> mockPartyRooms = [
  const PartyRoom(title: 'কেমন আছো সবাই 😍', hostName: 'Beauty', avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200', membersCount: '12', onlineCount: 9517),
  const PartyRoom(title: 'Mahfil a isha 💖', hostName: 'Mahfil', avatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200', membersCount: '10', onlineCount: 13589),
];

// 1. Splash Screen with Fizz Live Pro branding
class Splash extends StatefulWidget {
  const Splash({super.key});
  @override
  State<Splash> createState() => _SplashState();
}
class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CustomLoginScreen()));
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
            Icon(Icons.live_tv, size: 75, color: Colors.pinkAccent),
            SizedBox(height: 14),
            Text('FIZZ LIVE PRO', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.amber, letterSpacing: 1.5)),
            SizedBox(height: 6),
            Text('Private Live Video & Party Audio Chat', style: TextStyle(fontSize: 12, color: Colors.white54)),
          ],
        ),
      ),
    );
  }
}

// 2. Exact Screenshot-style Floating Profile Bubbles + Fast Login Screen (No Pin Gate)
class CustomLoginScreen extends StatelessWidget {
  const CustomLoginScreen({super.key});

  final List<Map<String, dynamic>> _bubbles = const [
    {'img': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200', 'top': 40, 'left': 30, 'size': 68},
    {'img': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200', 'top': 30, 'right': 40, 'size': 62},
    {'img': 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200', 'top': 180, 'left': 50, 'size': 85},
    {'img': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200', 'top': 195, 'right': 35, 'size': 82},
    {'img': 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=200', 'top': 370, 'left': 45, 'size': 76},
    {'img': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200', 'top': 385, 'right': 65, 'size': 68},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0713),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _AmbientBubblePainter())),
          ..._bubbles.map((b) => Positioned(
            top: (b['top'] as num).toDouble(),
            left: b.containsKey('left') ? (b['left'] as num).toDouble() : null,
            right: b.containsKey('right') ? (b['right'] as num).toDouble() : null,
            child: Container(
              width: (b['size'] as num).toDouble(),
              height: (b['size'] as num).toDouble(),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                image: DecorationImage(image: NetworkImage(b['img'] as String), fit: BoxFit.cover),
                boxShadow: [BoxShadow(color: Colors.pink.withOpacity(0.3), blurRadius: 10, spreadRadius: 2)],
              ),
            ),
          )),
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Dashboard()));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.purpleAccent]),
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [BoxShadow(color: Colors.pinkAccent.withOpacity(0.5), blurRadius: 15, offset: const Offset(0, 5))],
                    ),
                    alignment: Alignment.center,
                    child: const Text('Fast Login', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already a member? ', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Dashboard())),
                      child: const Text('Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white70, width: 2)),
                      alignment: Alignment.center,
                      child: Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.pink)),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text('Agree to User Agreement and Privacy Policy', style: TextStyle(color: Colors.white60, fontSize: 11), overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.headphones, color: Colors.white54, size: 14),
                    const SizedBox(width: 6),
                    const Text('Having login issues? ', style: TextStyle(color: Colors.white54, fontSize: 11)),
                    GestureDetector(
                      onTap: () async {
                        await [Permission.camera, Permission.microphone].request();
                      },
                      child: const Text('Find help', style: TextStyle(color: Colors.pinkAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
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

class _AmbientBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintRed = Paint()..color = Colors.red.withOpacity(0.12)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 35);
    final paintBlue = Paint()..color = Colors.blue.withOpacity(0.10)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.15), 45, paintRed);
    canvas.drawCircle(Offset(size.width * 0.65, size.height * 0.45), 35, paintBlue);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 3. Gift Sheet, Call Screen, Host Profile, Party Room, Live Room & Dashboard
class GiftBottomSheet extends StatefulWidget {
  final int currentGems;
  final Function(int, String) onSendGift;
  const GiftBottomSheet({super.key, required this.currentGems, required this.onSendGift});
  @override
  State<GiftBottomSheet> createState() => _GiftBottomSheetState();
}
class _GiftBottomSheetState extends State<GiftBottomSheet> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  int _selectedQty = 1;
  @override
  void initState() { super.initState(); _tabCtrl = TabController(length: giftCategories.keys.length, vsync: this); }
  @override
  void dispose() { _tabCtrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final categories = giftCategories.keys.toList();
    return Container(
      color: Colors.grey[900],
      height: 380,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TabBar(controller: _tabCtrl, isScrollable: true, labelColor: Colors.pinkAccent, unselectedLabelColor: Colors.white54, tabs: categories.map((c) => Tab(text: c)).toList()),
          Expanded(child: TabBarView(controller: _tabCtrl, children: categories.map((cat) {
            final items = giftCategories[cat] ?? [];
            return GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4), itemCount: items.length, itemBuilder: (ctx, i) {
              final item = items[i];
              return GestureDetector(onTap: () {
                final totalCost = item.gems * _selectedQty;
                if (widget.currentGems >= totalCost) { widget.onSendGift(totalCost, '${item.name} x$_selectedQty'); Navigator.pop(context); }
              }, child: Container(margin: const EdgeInsets.all(4), color: Colors.grey[850], child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(item.emoji), Text(item.name, style: const TextStyle(color: Colors.white, fontSize: 9)), Text('${item.gems}💎', style: const TextStyle(color: Colors.amber, fontSize: 9))])));
            });
          }).toList())),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('💎 ${widget.currentGems}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.pink), onPressed: () => Navigator.pop(context), child: const Text('Send'))]),
        ],
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
  bool _frontCam = true;
  @override
  void initState() {
    super.initState();
    _g = widget.gems;
    _initZego();
    _t = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _sec++);
      if (_sec > 0 && _sec % 60 == 0) { if (_g >= 1800) { setState(() => _g -= 1800); widget.onGems(_g); } else { _exitCall(); } }
    });
  }
  void _exitCall() { _t?.cancel(); final dur = '${_sec ~/ 60}:${(_sec % 60).toString().padLeft(2, '0')}'; Navigator.pop(context); widget.onEnd(dur, _sec); }
  Future<void> _initZego() async {
    await ZegoExpressEngine.createEngineWithProfile(ZegoEngineProfile(710176630, ZegoScenario.StandardVideoCall, appSign: '0b8b0f4adab85c101698f21f4e7c7b1aa477c901ac58d80a75e54c17ed05ad8a'));
    await ZegoExpressEngine.instance.enableCamera(true);
    await ZegoExpressEngine.instance.useFrontCamera(true);
    final w = await ZegoExpressEngine.instance.createCanvasView((id) { _vid = id; ZegoExpressEngine.instance.startPreview(canvas: ZegoCanvas(id)); });
    if (mounted) setState(() => _cam = w);
  }
  @override
  void dispose() { _t?.cancel(); if (_vid != null) ZegoExpressEngine.instance.destroyCanvasView(_vid!); ZegoExpressEngine.instance.stopPreview(); ZegoExpressEngine.destroyEngine(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, body: Stack(children: [Positioned.fill(child: Image.network(widget.pic, fit: BoxFit.cover)), Positioned(top: 40, right: 16, width: 85, height: 115, child: ClipRRect(borderRadius: BorderRadius.circular(8), child: _cam ?? const CircularProgressIndicator())), Positioned(bottom: 20, left: 0, right: 0, child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [IconButton(icon: const Icon(Icons.flip_camera_ios, color: Colors.white), onPressed: () { _frontCam = !_frontCam; ZegoExpressEngine.instance.useFrontCamera(_frontCam); }), IconButton(icon: const Icon(Icons.call_end, color: Colors.red, size: 36), onPressed: _exitCall)]))]));
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
      height: 400,
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [CircleAvatar(radius: 28, backgroundImage: NetworkImage(host.pic)), const SizedBox(width: 12), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(host.name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), Text('ID: ${host.id} • 🟢 ${host.status}', style: const TextStyle(color: Colors.greenAccent, fontSize: 11))])]),
        const SizedBox(height: 12),
        const Text('Delhi • 34 yrs old', style: TextStyle(color: Colors.pinkAccent, fontSize: 11, fontWeight: FontWeight.bold)),
        const Spacer(),
        ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, minimumSize: const Size(double.infinity, 40)), icon: const Icon(Icons.videocam), label: const Text('Video Call • 1800/min'), onPressed: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen(host: host.name, pic: host.pic, gems: gems, onGems: onGemsUpdate, onEnd: (_, __) {}))); }),
      ]),
    );
  }
}

class FloatingChatMsg {
  final String id, user, text;
  FloatingChatMsg(this.user, this.text) : id = UniqueKey().toString();
}

class FloatingChatOverlay extends StatelessWidget {
  final List<FloatingChatMsg> messages;
  const FloatingChatOverlay({super.key, required this.messages});
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: messages.map((m) => Container(margin: const EdgeInsets.symmetric(vertical: 2), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(12)), child: Text('${m.user}: ${m.text}', style: const TextStyle(color: Colors.white, fontSize: 12)))).toList());
  }
}

class PartyAudioRoomScreen extends StatefulWidget {
  final PartyRoom room;
  final int gems;
  final Function(int) onGemsUpdate;
  const PartyAudioRoomScreen({super.key, required this.room, required this.gems, required this.onGemsUpdate});
  @override
  State<PartyAudioRoomScreen> createState() => _PartyAudioRoomScreenState();
}
class _PartyAudioRoomScreenState extends State<PartyAudioRoomScreen> {
  final List<FloatingChatMsg> _partyMsgs = [];
  final _msgCtrl = TextEditingController();
  bool _diwaliEffect = false;
  String _banner = '';
  final List<Map<String, String>> _members = [{'name': 'Beauty', 'avatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100'}];
  
  void _triggerDiwali(String desc) {
    setState(() { _diwaliEffect = true; _banner = '🎆 DEWALI CELEBRATION! Gift Sent: $desc 🎇'; });
    Timer(const Duration(seconds: 3), () => setState(() => _diwaliEffect = false));
  }
  
  void _openProfileDialog(Map<String, String> member) {
    showModalBottomSheet(context: context, backgroundColor: Colors.grey[900], builder: (ctx) => Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children: [CircleAvatar(radius: 35, backgroundImage: NetworkImage(member['avatar']!)), const SizedBox(height: 10), Text(member['name']!, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 15), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.pink), onPressed: () { Navigator.pop(ctx); showModalBottomSheet(context: context, builder: (_) => GiftBottomSheet(currentGems: widget.gems, onSendGift: (c, d) { widget.onGemsUpdate(widget.gems - c); _triggerDiwali(d); })); }, child: const Text('Send Gift'))])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181028),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(icon: CircleAvatar(backgroundImage: NetworkImage(widget.room.avatar)), onPressed: () => _openProfileDialog({'name': widget.room.hostName, 'avatar': widget.room.avatar})),
        title: GestureDetector(onTap: () => _openProfileDialog({'name': widget.room.hostName, 'avatar': widget.room.avatar}), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(widget.room.title, style: const TextStyle(fontSize: 13)), Text('Host: ${widget.room.hostName}', style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.65)))] ) ),
        actions: [IconButton(icon: const Icon(Icons.favorite, color: Colors.pinkAccent), onPressed: () {}), IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context))],
      ),
      body: Stack(children: [
        Column(children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), child: GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, childAspectRatio: 0.8), itemCount: 10, itemBuilder: (ctx, i) {
            final memberData = i < _members.length ? _members[i] : null;
            return GestureDetector(onTap: () { if (memberData != null) _openProfileDialog(memberData); else setState(() => _members.add({'name': 'Use
