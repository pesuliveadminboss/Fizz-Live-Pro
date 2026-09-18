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
    const GiftItem('Champagne', 50, emoji: '🍾', iconUrl: 'https://cdn-icons-png.flaticon.com/512/869/869686.png'),
    const GiftItem('Loving Girl', 900, emoji: '💃', iconUrl: 'https://cdn-icons-png.flaticon.com/512/3048/3048122.png'),
  ],
  'Lucky': [const GiftItem('Mystery Box', 360, emoji: '🎁')],
  'Svip': [],
  'Intimacy': [
    const GiftItem('In My Hand', 300, emoji: '🤝'),
    const GiftItem('Kiss', 180, emoji: '💋'),
  ],
  'Wealth': [const GiftItem('Cruise Eve', 3700, emoji: '🚢')],
  'Festival': [const GiftItem('Puppy', 180, emoji: '🐶')],
  'Bag': [],
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
    return const Scaffold(backgroundColor: Colors.black, body: Center(child: Icon(Icons.live_tv, size: 70, color: Colors.pinkAccent)));
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
    return Scaffold(backgroundColor: Colors.black, body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Text('Admin PIN (7777)', style: TextStyle(color: Colors.white)), TextField(controller: _c, obscureText: true, textAlign: TextAlign.center, style: const TextStyle(color: Colors.amber)), ElevatedButton(onPressed: () { if (_c.text.trim() == "7777") Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Dashboard())); }, child: const Text('Unlock'))]))));
  }
}

class Login extends StatelessWidget {
  const Login({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, body: Center(child: ElevatedButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Dashboard())), child: const Text('Login'))));
  }
}
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
    return Container(color: Colors.grey[900], height: 380, padding: const EdgeInsets.all(12), child: Column(children: [TabBar(controller: _tabCtrl, isScrollable: true, labelColor: Colors.pinkAccent, tabs: categories.map((c) => Tab(text: c)).toList()), Expanded(child: TabBarView(controller: _tabCtrl, children: categories.map((cat) {
      final items = giftCategories[cat] ?? [];
      return GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4), itemCount: items.length, itemBuilder: (ctx, i) {
        final item = items[i];
        return GestureDetector(onTap: () {
          final totalCost = item.gems * _selectedQty;
          if (widget.currentGems >= totalCost) { widget.onSendGift(totalCost, '${item.name} x$_selectedQty'); Navigator.pop(context); }
        }, child: Container(margin: const EdgeInsets.all(4), color: Colors.grey[850], child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(item.emoji), Text(item.name, style: const TextStyle(color: Colors.white, fontSize: 9)), Text('${item.gems}💎', style: const TextStyle(color: Colors.amber, fontSize: 9))])));
      });
    }).toList())), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('💎 ${widget.currentGems}', style: const TextStyle(color: Colors.amber)), ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Send'))])]));
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
  bool _frontCam = true;
  @override
  void initState() { super.initState(); _g = widget.gems; _initZego(); }
  Future<void> _initZego() async {
    await ZegoExpressEngine.createEngineWithProfile(ZegoEngineProfile(710176630, ZegoScenario.StandardVideoCall, appSign: '0b8b0f4adab85c101698f21f4e7c7b1aa477c901ac58d80a75e54c17ed05ad8a'));
    final w = await ZegoExpressEngine.instance.createCanvasView((id) { _vid = id; ZegoExpressEngine.instance.startPreview(canvas: ZegoCanvas(id)); });
    if (mounted) setState(() => _cam = w);
  }
  @override
  void dispose() { if (_vid != null) ZegoExpressEngine.instance.destroyCanvasView(_vid!); ZegoExpressEngine.destroyEngine(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, body: Stack(children: [Positioned.fill(child: Image.network(widget.pic, fit: BoxFit.cover)), Positioned(top: 40, right: 16, width: 85, height: 115, child: ClipRRect(borderRadius: BorderRadius.circular(8), child: _cam ?? const CircularProgressIndicator())), Positioned(bottom: 20, left: 0, right: 0, child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [IconButton(icon: const Icon(Icons.flip_camera_ios, color: Colors.white), onPressed: () { _frontCam = !_frontCam; ZegoExpressEngine.instance.useFrontCamera(_frontCam); }), IconButton(icon: const Icon(Icons.call_end, color: Colors.red), onPressed: () => Navigator.pop(context))]))]));
  }
}

class HostProfileSheet extends StatelessWidget {
  final Host host;
  final int gems;
  final Function(int) onGemsUpdate;
  const HostProfileSheet({super.key, required this.host, required this.gems, required this.onGemsUpdate});
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.grey[900], height: 300, padding: const EdgeInsets.all(16), child: Column(children: [Row(children: [CircleAvatar(backgroundImage: NetworkImage(host.pic)), const SizedBox(width: 10), Text(host.name, style: const TextStyle(color: Colors.white, fontSize: 18))]), const Spacer(), ElevatedButton(onPressed: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen(host: host.name, pic: host.pic, gems: gems, onGems: onGemsUpdate, onEnd: (_, __) {}))); }, child: const Text('Video Call • 1800/min'))]));
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
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: messages.map((m) => Container(margin: const EdgeInsets.symmetric(vertical: 2), padding: const EdgeInsets.all(6), color: Colors.black54, child: Text('${m.user}: ${m.text}', style: const TextStyle(color: Colors.white, fontSize: 12)))).toList());
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xFF181028), appBar: AppBar(backgroundColor: Colors.transparent, title: Text(widget.room.title, style: const TextStyle(fontSize: 13)), actions: [IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context))]), body: Stack(children: [Column(children: [Padding(padding: const EdgeInsets.all(8), child: GridView.builder(shrinkWrap: true, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5), itemCount: 10, itemBuilder: (ctx, i) => Column(children: [CircleAvatar(radius: 18, backgroundImage: NetworkImage(i < _members.length ? _members[i]['avatar']! : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100')), Text('Seat ${i+1}', style: const TextStyle(color: Colors.white54, fontSize: 8))]))), Expanded(child: Container(color: Colors.black26, child: const Center(child: Text('SLOTS 🎰', style: TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold))))), Row(children: [Expanded(child: TextField(controller: _msgCtrl, style: const TextStyle(color: Colors.white))), IconButton(icon: const Icon(Icons.send, color: Colors.pink), onPressed: () { if (_msgCtrl.text.isNotEmpty) { setState(() => _partyMsgs.add(FloatingChatMsg('You', _msgCtrl.text))); _msgCtrl.clear(); } }), IconButton(icon: const Icon(Icons.card_giftcard, color: Colors.amber), onPressed: () => showModalBottomSheet(context: context, builder: (_) => GiftBottomSheet(currentGems: widget.gems, onSendGift: (c, d) { widget.onGemsUpdate(widget.gems - c); _triggerDiwali(d); }))), IconButton(icon: const Icon(Icons.group_add, color: Colors.green), onPressed: () => setState(() => _members.add({'name': 'User', 'avatar': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100'})))])]), if (_diwaliEffect) Positioned.fill(child: Container(color: Colors.orange.withOpacity(0.4), child: Center(child: Text(_banner, style: const TextStyle(color: Colors.amberAccent, fontSize: 18, fontWeight: FontWeight.bold)))))]));
  }
}
class LiveStreamSwipeableRoom extends StatelessWidget {
  final List<Host> liveHosts;
  final int initialIndex;
  final int gems;
  final Function(int) onGemsUpdate;
  final Function(String, String) onCloseWithPiP;
  final Function(Host) onFollowHost;
  final Function(Host) onOpenProfile;
  const LiveStreamSwipeableRoom({super.key, required this.liveHosts, required this.initialIndex, required this.gems, required this.onGemsUpdate, required this.onCloseWithPiP, required this.onFollowHost, required this.onOpenProfile});
  @override
  Widget build(BuildContext context) {
    return PageView.builder(scrollDirection: Axis.vertical, itemCount: liveHosts.length, itemBuilder: (ctx, i) {
      final h = liveHosts[i];
      return Scaffold(backgroundColor: Colors.black, body: Stack(children: [Positioned.fill(child: Image.network(h.pic, fit: BoxFit.cover)), Positioned(top: 40, left: 16, child: Row(children: [GestureDetector(onTap: () => onOpenProfile(h), child: CircleAvatar(backgroundImage: NetworkImage(h.pic), radius: 18)), const SizedBox(width: 8), Text(h.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))])), Positioned(top: 40, right: 16, child: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () { onCloseWithPiP(h.name, h.pic); Navigator.pop(context); }))]));
    });
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}
class _DashboardState extends State<Dashboard> {
  int _navIndex = 0;
  int _cat = 0;
  String _liveSubFilter = 'Pretty';
  int _gems = 1670;
  final List<String> _cats = const ['Hot', 'Live', 'Party', 'Match'];
  final List<String> _liveSubFilters = const ['Pretty', 'New', 'Sexy'];
  final List<Host> _allHosts = const [
    Host(name: 'PrettyNiki', pic: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300', cat: 'Hot', tag: 'Pretty', flag: '🇮🇳', status: 'Online', id: 8002023),
    Host(name: 'SexyRitaj', pic: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=300', cat: 'Live', tag: 'Sexy', flag: '🇦🇪', status: 'Live', id: 8002025),
  ];
  bool _hasMiniPlayer = false;
  String _miniName = '';

  void _showRechargeModal() {
    showModalBottomSheet(context: context, builder: (_) => Container(height: 200, padding: const EdgeInsets.all(16), child: Column(children: [const Text('Recharge Gems', style: TextStyle(color: Colors.white)), ElevatedButton(onPressed: () { setState(() => _gems += 4050); Navigator.pop(context); }, child: const Text('Add 4050 Gems'))])));
  }

  Widget _buildContent() {
    if (_navIndex == 2) return const Center(child: Text('🎮 Game Center', style: TextStyle(color: Colors.amber)));
    final catName = _cats[_cat];
    if (catName == 'Party') {
      return ListView.builder(itemCount: mockPartyRooms.length, itemBuilder: (ctx, i) {
        final r = mockPartyRooms[i];
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PartyAudioRoomScreen(room: r, gems: _gems, onGemsUpdate: (g) => setState(() => _gems = g)))),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF1E1428), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white12)),
            child: Row(children: [
              CircleAvatar(radius: 26, backgroundImage: NetworkImage(r.avatar)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 6),
                Row(children: [
                  ...List.generate(3, (index) => Padding(padding: const EdgeInsets.only(right: 4), child: CircleAvatar(radius: 9, backgroundImage: NetworkImage(r.avatar)))),
                  Text(' 🔊 ${r.onlineCount}', style: const TextStyle(color: Colors.amberAccent, fontSize: 11)),
                ]),
              ])),
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.pink.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: const Text('Party', style: TextStyle(color: Colors.pinkAccent, fontSize: 11))),
            ]),
          ),
        );
      });
    }
    final list = _allHosts.where((h) => catName == 'Hot' ? h.status == 'Online' : h.status == 'Live').toList();
    return Column(children: [
      if (_cat == 1) Container(color: Colors.grey[850], height: 50, child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: _liveSubFilters.map((sf) => TextButton(onPressed: () => setState(() => _liveSubFilter = sf), child: Text(sf, style: TextStyle(color: _liveSubFilter == sf ? Colors.pink : Colors.white)))).toList())),
      Expanded(child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemCount: list.length, itemBuilder: (ctx, i) {
        final h = list[i];
        return GestureDetector(onTap: () {
          if (h.status == 'Live') {
            Navigator.push(context, MaterialPageRoute(builder: (_) => LiveStreamSwipeableRoom(liveHosts: list.where((x) => x.status == 'Live').toList(), initialIndex: 0, gems: _gems, onGemsUpdate: (g) => setState(() => _gems = g), onCloseWithPiP: (n, p) => setState(() { _hasMiniPlayer = true; _miniName = n; }), onFollowHost: (_) {}, onOpenProfile: (host) => showModalBottomSheet(context: context, builder: (_) => HostProfileSheet(host: host, gems: _gems, onGemsUpdate: (g) => setState(() => _gems = g))))));
          } else {
            showModalBottomSheet(context: context, builder: (_) => HostProfileSheet(host: h, gems: _gems, onGemsUpdate: (g) => setState(() => _gems = g)));
          }
        }, child: Card(color: Colors.grey[900], child: Column(children: [Expanded(child: Image.network(h.pic, fit: BoxFit.cover)), Text(h.name, style: const TextStyle(color: Colors.white))])));
      }))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, appBar: AppBar(backgroundColor: Colors.black, title: _navIndex == 0 ? Row(mainAxisSize: MainAxisSize.min, children: _cats.asMap().entries.map((e) => GestureDetector(onTap: () => setState(() => _cat = e.key), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: Text(e.value, style: TextStyle(color: _cat == e.key ? Colors.pink : Colors.white70))))).toList()) : const Text('Dashboard', style: TextStyle(color: Colors.white)), actions: [IconButton(icon: const Icon(Icons.diamond, color: Colors.amber), onPressed: _showRechargeModal)]), body: Stack(children: [_buildContent(), if (_hasMiniPlayer) Positioned(bottom: 20, right: 20, child: GestureDetector(onTap: () => setState(() => _hasMiniPlayer = false), child: Container(width: 90, height: 120, color: Colors.pink, child: Center(child: Text('Mini 🎙️\n$_miniName', style: const TextStyle(color: Colors.white, fontSize: 8))))))]), bottomNavigationBar: BottomNavigationBar(backgroundColor: Colors.black, selectedItemColor: Colors.pink, unselectedItemColor: Colors.white54, currentIndex: _navIndex, type: BottomNavigationBarType.fixed, onTap: (idx) => setState(() => _navIndex = idx), items: const [BottomNavigationBarItem(icon: Icon(Icons.home), label: 'For You'), BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Follow'), BottomNavigationBarItem(icon: Icon(Icons.sports_esports), label: 'Game'), BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'), BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me')]));
  }
}
