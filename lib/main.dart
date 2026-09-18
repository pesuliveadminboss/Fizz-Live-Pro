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
  'Lucky': [
    const GiftItem('Mystery Box', 360, emoji: '🎁', iconUrl: 'https://cdn-icons-png.flaticon.com/512/4213/4213958.png'),
  ],
  'Svip': [],
  'Intimacy': [
    const GiftItem('In My Hand', 300, emoji: '🤝', iconUrl: 'https://cdn-icons-png.flaticon.com/512/2910/2910791.png'),
    const GiftItem('Kiss', 180, emoji: '💋', iconUrl: 'https://cdn-icons-png.flaticon.com/512/3233/3233485.png'),
  ],
  'Wealth': [
    const GiftItem('Cruise Eve', 3700, emoji: '🚢', iconUrl: 'https://cdn-icons-png.flaticon.com/512/2885/2885441.png'),
  ],
  'Festival': [
    const GiftItem('Puppy', 180, emoji: '🐶', iconUrl: 'https://cdn-icons-png.flaticon.com/512/616/616408.png'),
  ],
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
  const PartyRoom(title: 'super party 💋', hostName: 'Sweet', avatar: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200', membersCount: '9', onlineCount: 9517),
  const PartyRoom(title: 'হাসির রানী 💕', hostName: 'Rani', avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200', membersCount: '6', onlineCount: 4210),
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
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.live_tv, size: 70, color: Colors.pinkAccent),
            SizedBox(height: 10),
            Text('FIZZ LIVE PRO', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
            Text('18+ Private Live Video & PK Chat', style: TextStyle(fontSize: 11, color: Colors.white54)),
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
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: giftCategories.keys.length, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = giftCategories.keys.toList();
    return Container(
      color: Colors.grey[900],
      height: 380,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TabBar(
            controller: _tabCtrl,
            isScrollable: true,
            labelColor: Colors.pinkAccent,
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.pinkAccent,
            tabs: categories.map((c) => Tab(text: c)).toList(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: categories.map((cat) {
                final items = giftCategories[cat] ?? [];
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 1.0),
                  itemCount: items.length,
                  itemBuilder: (ctx, i) {
                    final item = items[i];
                    return GestureDetector(
                      onTap: () {
                        final totalCost = item.gems * _selectedQty;
                        if (widget.currentGems >= totalCost) {
                          widget.onSendGift(totalCost, '${item.name} x$_selectedQty');
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Insufficient Gems! Recharge first.')));
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.grey[850], borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white24)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            item.iconUrl.isNotEmpty
                                ? Image.network(item.iconUrl, width: 26, height: 26, errorBuilder: (c, e, s) => Text(item.emoji, style: const TextStyle(fontSize: 24)))
                                : Text(item.emoji, style: const TextStyle(fontSize: 24)),
                            Text(item.name, style: const TextStyle(color: Colors.white, fontSize: 9), overflow: TextOverflow.ellipsis),
                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Text('💎', style: TextStyle(fontSize: 9)), Text('${item.gems}', style: const TextStyle(color: Colors.amber, fontSize: 9))]),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('💎 ', style: TextStyle(fontSize: 12)),
                  Text('${widget.currentGems} >', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
              Row(
                children: [
                  ...[1, 77, 177].map((q) => GestureDetector(
                    onTap: () => setState(() => _selectedQty = q),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(color: _selectedQty == q ? Colors.pink : Colors.grey[800], borderRadius: BorderRadius.circular(4)),
                      child: Text('$q', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  )),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, minimumSize: const Size(60, 30)),
                    onPressed: () { Navigator.pop(context); },
                    child: const Text('Send', style: TextStyle(fontSize: 11)),
                  ),
                ],
              ),
            ],
          ),
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

  void _exitCall() {
    _t?.cancel();
    final dur = '${_sec ~/ 60}:${(_sec % 60).toString().padLeft(2, '0')}';
    Navigator.pop(context);
    widget.onEnd(dur, _sec);
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
          Positioned(
            bottom: 20, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.flip_camera_ios, color: Colors.white, size: 28),
                  onPressed: () {
                    _frontCam = !_frontCam;
                    ZegoExpressEngine.instance.useFrontCamera(_frontCam);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_frontCam ? 'Switched to Front Camera' : 'Switched to Rear Camera'), duration: const Duration(milliseconds: 500)));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.card_giftcard, color: Colors.amber, size: 32),
                  onPressed: () {
                    showModalBottomSheet(context: context, builder: (_) => GiftBottomSheet(
                      currentGems: _g,
                      onSendGift: (cost, desc) {
                        setState(() => _g -= cost);
                        widget.onGems(_g);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gift sent: $desc (-$cost Gems)')));
                      },
                    ));
                  },
                ),
                IconButton(icon: const Icon(Icons.call_end, color: Colors.red, size: 36), onPressed: _exitCall),
              ],
            ),
          ),
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
                  Text('ID: ${host.id}  •  🟢 ${host.status}', style: const TextStyle(color: Colors.greenAccent, fontSize: 11)),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CallScreen(
                          host: host.name,
                          pic: host.pic,
                          gems: gems,
                          onGems: onGemsUpdate,
                          onEnd: (dur, secs) {},
                        ),
                      ),
                    );
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
class FloatingChatMsg {
  final String id, user, text;
  FloatingChatMsg(this.user, this.text) : id = UniqueKey().toString();
}

class FloatingChatOverlay extends StatefulWidget {
  final List<FloatingChatMsg> messages;
  const FloatingChatOverlay({super.key, required this.messages});
  @override
  State<FloatingChatOverlay> createState() => _FloatingChatOverlayState();
}

class _FloatingChatOverlayState extends State<FloatingChatOverlay> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.messages.map((m) {
        return TweenAnimationBuilder<double>(
          key: ValueKey(m.id),
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(seconds: 4),
          curve: Curves.easeOut,
          builder: (ctx, val, child) {
            return Transform.translate(
              offset: Offset(0, -60 * val),
              child: Opacity(
                opacity: (1.0 - val).clamp(0.0, 1.0),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(12)),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: '${m.user}: ', style: const TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                        TextSpan(text: m.text, style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
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
  String _activeGiftBanner = '';
  final List<Map<String, String>> _joinedMembers = [
    {'name': 'Beauty', 'avatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100'},
    {'name': 'Isha', 'avatar': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100'},
    {'name': 'Sweet', 'avatar': 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=100'},
    {'name': 'Rani', 'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100'},
  ];

  void _triggerDiwaliEffect(String giftText) {
    setState(() {
      _diwaliEffect = true;
      _activeGiftBanner = '🎆 DEWALI CELEBRATION! Gift Sent: $giftText 🎇';
    });
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _diwaliEffect = false;
          _activeGiftBanner = '';
        });
      }
    });
  }

  void _sendPartyMessage() {
    if (_msgCtrl.text.trim().isNotEmpty) {
      final text = _msgCtrl.text.trim();
      final msg = FloatingChatMsg('You', text);
      setState(() => _partyMsgs.add(msg));
      _msgCtrl.clear();
      Timer(const Duration(seconds: 4), () {
        if (mounted) setState(() => _partyMsgs.removeWhere((item) => item.id == msg.id));
      });
    }
  }

  void _openProfileDialog(Map<String, String> member) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 40, backgroundImage: NetworkImage(member['avatar']!)),
            const SizedBox(height: 10),
            Text(member['name']!, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('Party Active Voice Member 🎙️', style: TextStyle(color: Colors.pinkAccent, fontSize: 12)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                  icon: const Icon(Icons.card_giftcard),
                  label: const Text('Send Gift'),
                  onPressed: () {
                    Navigator.pop(ctx);
                    showModalBottomSheet(context: context, builder: (_) => GiftBottomSheet(
                      currentGems: widget.gems,
                      onSendGift: (cost, desc) {
                        widget.onGemsUpdate(widget.gems - cost);
                        _triggerDiwaliEffect(desc);
                      },
                    ));
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800]),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Close'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final seats = List.generate(10, (index) => index < _joinedMembers.length ? _joinedMembers[index]['avatar']! : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100');
    final seatNames = List.generate(10, (index) => index < _joinedMembers.length ? _joinedMembers[index]['name']! : 'Seat ${index + 1}');

    return Scaffold(
      backgroundColor: const Color(0xFF181028),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: CircleAvatar(radius: 16, backgroundImage: NetworkImage(widget.room.avatar)),
          onPressed: () => _openProfileDialog({'name': widget.room.hostName, 'avatar': widget.room.avatar}),
        ),
        title: GestureDetector(
          onTap: () => _openProfileDialog({'name': widget.room.hostName, 'avatar': widget.room.avatar}),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.room.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              Text('Host: ${widget.room.hostName}', style: const TextStyle(fontSize: 10, color: Colors.white60)),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.pinkAccent, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Liked Party Room ❤️'), duration: Duration(milliseconds: 600)));
            },
          ),
          IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, childAspectRatio: 0.8, crossAxisSpacing: 10, mainAxisSpacing: 10),
                  itemCount: 10,
                  itemBuilder: (ctx, i) {
                    final memberData = i < _joinedMembers.length ? _joinedMembers[i] : null;
                    return GestureDetector(
                      onTap: () {
                        if (memberData != null) {
                          _openProfileDialog(memberData);
                        } else {
                          setState(() {
                            if (_joinedMembers.length < 10) {
                              _joinedMembers.add({'name': 'User${_joinedMembers.length + 1}', 'avatar': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100'});
                            }
                          });
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Joined Party Voice Seat 🎙️')));
                        }
                      },
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(radius: 20, backgroundImage: NetworkImage(seats[i])),
                              Positioned(bottom: 0, right: 0, child: const CircleAvatar(radius: 6, backgroundColor: Colors.green, child: Icon(Icons.mic, size: 8, color: Colors.white))),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(seatNames[i], style: const TextStyle(color: Colors.white70, fontSize: 8), overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const Divider(color: Colors.white24),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [Color(0xFF2E123B), Color(0xFF1B082B)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.amberAccent.withOpacity(0.3))),
                            child: Column(
                              children: [
                                const Text('18+', style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                                const Text('ONLY', style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 10)),
                                const SizedBox(height: 10),
                                const Text('SLOTS 🎰', style: TextStyle(color: Colors.amber, fontSize: 22, fontWeight: FontWeight.w900)),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: ['💎', '💎', '💎'].map((e) => Container(margin: const EdgeInsets.symmetric(horizontal: 4), padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)), child: Text(e, style: const TextStyle(fontSize: 16)))).toList(),
                                ),
                                const SizedBox(height: 10),
                                const Text('Loading...', style: TextStyle(color: Colors.white54, fontSize: 11)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(bottom: 50, left: 16, right: 16, child: FloatingChatOverlay(messages: _partyMsgs)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _msgCtrl,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                        decoration: InputDecoration(filled: true, fillColor: Colors.black54, hintText: 'Party message...', hintStyle: const TextStyle(color: Colors.white54, fontSize: 11), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                        onSubmitted: (_) => _sendPartyMessage(),
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.send, color: Colors.pinkAccent), onPressed: _sendPartyMessage),
                    CircleAvatar(
                      backgroundColor: Colors.pink,
                      radius: 18,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.card_giftcard, size: 18, color: Colors.white),
                        onPressed: () {
                          showModalBottomSheet(context: context, builder: (_) => GiftBottomSheet(
                            currentGems: widget.gems,
                            onSendGift: (cost, desc) {
                              widget.onGemsUpdate(widget.gems - cost);
                              _triggerDiwaliEffect(desc);
                            },
                          ));
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    CircleAvatar(
                      backgroundColor: Colors.amber,
                      radius: 18,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.group_add, size: 18, color: Colors.black),
                        onPressed: () {
                          setState(() {
                            if (_joinedMembers.length < 10) {
                              _joinedMembers.add({'name': 'JoinedUser', 'avatar': 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=100'});
                            }
                          });
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Joined Party Mode 🎙️')));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_diwaliEffect)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: Colors.orange.withOpacity(0.35),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🎆 🪔 DEWALI CELEBRATION 🪔 🎆', style: TextStyle(color: Colors.amberAccent, fontSize: 26, fontWeight: FontWeight.w900, shadows: [Shadow(color: Colors.red, blurRadius: 20)])),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.amber)),
                          child: Text(_activeGiftBanner, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class LiveStreamSwipeableRoom extends StatefulWidget {
  final List<Host> liveHosts;
  final int initialIndex;
  final int gems;
  final Function(int) onGemsUpdate;
  final Function(String, String) onCloseWithPiP;
  final Function(Host) onFollowHost;
  final Function(Host) onOpenProfile;

  const LiveStreamSwipeableRoom({
    super.key,
    required this.liveHosts,
    required this.initialIndex,
    required this.gems,
    required this.onGemsUpdate,
    required this.onCloseWithPiP,
    required this.onFollowHost,
    required this.onOpenProfile,
  });

  @override
  State<LiveStreamSwipeableRoom> createState() => _LiveStreamSwipeableRoomState();
}

class _LiveStreamSwipeableRoomState extends State<LiveStreamSwipeableRoom> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: widget.liveHosts.length,
      itemBuilder: (ctx, index) {
        final host = widget.liveHosts[index];
        return SingleLiveRoomView(
          host: host,
          gems: widget.gems,
          onGemsUpdate: widget.onGemsUpdate,
          onCloseWithPiP: widget.onCloseWithPiP,
          onFollowHost: widget.onFollowHost,
          onOpenProfile: widget.onOpenProfile,
        );
      },
    );
  }
}

class SingleLiveRoomView extends StatefulWidget {
  final Host host;
  final int gems;
  final Function(int) onGemsUpdate;
  final Function(String, String) onCloseWithPiP;
  final Function(Host) onFollowHost;
  final Function(Host) onOpenProfile;

  const SingleLiveRoomView({
    super.key,
    required this.host,
    required this.gems,
    required this.onGemsUpdate,
    required this.onCloseWithPiP,
    required this.onFollowHost,
    required this.onOpenProfile,
  });

  @override
  State<SingleLiveRoomView> createState() => _SingleLiveRoomViewState();
}

class _SingleLiveRoomViewState extends State<SingleLiveRoomView> {
  final List<FloatingChatMsg> _floatingMsgs = [];
  final _msgCtrl = TextEditingController();
  bool _followed = false;
  bool _diwaliEffect = false;
  String _activeGiftBanner = '';

  void _triggerDiwaliEffect(String giftText) {
    setState(() {
      _diwaliEffect = true;
      _activeGiftBanner = '🎆 DEWALI CELEBRATION! Gift Sent: $giftText 🎇';
    });
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _diwaliEffect = false;
          _activeGiftBanner = '';
        });
      }
    });
  }

  void _sendChatMessage() {
    if (_msgCtrl.text.trim().isNotEmpty) {
      final text = _msgCtrl.text.trim();
      final msg = FloatingChatMsg('You', text);
      setState(() => _floatingMsgs.add(msg));
      _msgCtrl.clear();
      Timer(const Duration(seconds: 4), () {
        if (mounted) setState(() => _floatingMsgs.removeWhere((item) => item.id == msg.id));
      });
    }
  }

  void _triggerFollow() {
    setState(() => _followed = true);
    widget.onFollowHost(widget.host);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(child: Image.network(widget.host.pic, fit: BoxFit.cover)),
          Positioned(
            top: 40, left: 16,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => widget.onOpenProfile(widget.host),
                  child: Row(
                    children: [
                      CircleAvatar(backgroundImage: NetworkImage(widget.host.pic), radius: 18),
                      const SizedBox(width: 6),
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
  final String _selectedCountry = '🇮🇳 India';
  final List<String> _history = ['Recharge: +4050 Gems', 'Video Call: -1800 Gems'];

  bool _hasMiniPlayer = false;
  String _miniStreamerName = '';
  String _miniStreamerPic = '';

  final List<Host> _followedHosts = [];
  final List<String> _cats = const ['Hot', 'Live', 'Party', 'Match'];
  final List<String> _liveSubFilters = const ['Pretty', 'New', 'Sexy'];

  final List<Host> _allHosts = const [
    Host(name: 'PrettyNiki', pic: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300', cat: 'Hot', tag: 'Pretty', flag: '🇮🇳', status: 'Online', id: 8002023),
    Host(name: 'NewSara', pic: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=300', cat: 'Hot', tag: 'New', flag: '🇮🇳', status: 'Online', id: 8002024),
    Host(name: 'SexyRitaj', pic: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=300', cat: 'Live', tag: 'Sexy', flag: '🇦🇪', status: 'Live', id: 8002025),
    Host(name: 'PrettyMoka', pic: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=300', cat: 'Live', tag: 'Pretty', flag: '🇪🇬', status: 'Live', id: 8002026),
  ];

  final _exactPacks = const [
    {'gems': 4050, 'price': 100.0, 'tag': '17% of'},
    {'gems': 8100, 'price': 200.0, 'tag': '17% of'},
    {'gems': 16380, 'price': 400.0, 'tag': '17% of'},
    {'gems': 32940, 'price': 800.0, 'tag': '17% of'},
    {'gems': 66600, 'price': 1600.0, 'tag': '30% of'},
    {'gems': 167400, 'price': 4000.0, 'tag': '60% of'},
  ];

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
                const Text('You want to see me? Recharge and we can continue💋', style: TextStyle(color: Colors.white70, fontSize: 11)),
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

  void _openLiveSwipeable(List<Host> liveHosts, int tappedIndex) {
    if (liveHosts.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LiveStreamSwipeableRoom(
          liveHosts: liveHosts,
          initialIndex: tappedIndex,
          gems: _gems,
          onGemsUpdate: (g) => setState(() => _gems = g),
          onCloseWithPiP: (name, pic) {
            setState(() { _hasMiniPlayer = true; _miniStreamerName = name; _miniStreamerPic = pic; });
          },
          onFollowHost: (h) {
            if (!_followedHosts.any((item) => item.id == h.id)) {
              setState(() => _followedHosts.add(h));
            }
          },
          onOpenProfile: (h) {
            showModalBottomSheet(
              context: context,
              builder: (_) => HostProfileSheet(host: h, gems: _gems, onGemsUpdate: (g) => setState(() => _gems = g)),
            );
          },
        ),
      ),
    );
  }

  void _handleHostTap(Host h, List<Host> currentList) {
    if (h.status == 'Live') {
      final liveOnlyList = currentList.where((item) => item.status == 'Live').toList();
      final tapIdx = liveOnlyList.indexWhere((item) => item.name == h.name);
      _openLiveSwipeable(liveOnlyList.isNotEmpty ? liveOnlyList : currentList, tapIdx >= 0 ? tapIdx : 0);
    } else {
      showModalBottomSheet(
        context: context,
        builder: (_) => HostProfileSheet(host: h, gems: _gems, onGemsUpdate: (g) => setState(() => _gems = g)),
      );
    }
  }

  Widget _buildScreenshotStyleSubFilterPanel() {
    final filtered = _allHosts.where((h) => h.tag.toLowerCase() == _liveSubFilter.toLowerCase() && h.status == 'Live').toList();
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.grey[900]?.withOpacity(0.9), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _liveSubFilters.map((sf) => GestureDetector(
              onTap: () => setState(() => _liveSubFilter = sf),
              child: Text(
                sf,
                style: TextStyle(color: _liveSubFilter == sf ? Colors.pinkAccent : Colors.white70, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            )).toList(),
          ),
          const SizedBox(height: 10),
          filtered.isEmpty
              ? const Padding(padding: EdgeInsets.all(12), child: Text('No streamers in this subfolder', style: TextStyle(color: Colors.white54, fontSize: 11)))
              : SizedBox(
                  height: 90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) {
                      final item = filtered[i];
                      return GestureDetector(
                        onTap: () => _handleHostTap(item, filtered),
                        child: Container(
                          width: 75,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: NetworkImage(item.pic), fit: BoxFit.cover)),
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(4),
                          child: Text(item.name, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildPartyRoomsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: mockPartyRooms.length,
      itemBuilder: (ctx, i) {
        final r = mockPartyRooms[i];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PartyAudioRoomScreen(
                  room: r,
                  gems: _gems,
                  onGemsUpdate: (g) => setState(() => _gems = g),
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFF1E1428), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white12)),
            child: Row(
              children: [
                CircleAvatar(radius: 26, backgroundImage: NetworkImage(r.avatar)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          ...List.generate(3, (index) => Padding(
                            padding: const EdgeInsets.only(right: 3),
                            child: CircleAvatar(radius: 8, backgroundImage: NetworkImage(r.avatar)),
                          )),
                          Text(' 🔊 ${r.onlineCount}', style: const TextStyle(color: Colors.white70, fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.pink.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                  child: const Text('Party', style: TextStyle(color: Colors.pinkAccent, fontSize: 11)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentTabContent() {
    switch (_navIndex) {
      case 0: // For You
      case 1: // Follow
      case 2: // Game tab
        if (_navIndex == 2) {
          return const Center(child: Text('🎮 Games Center (Coming Soon)', style: TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold)));
        }
        final catName = _cats[_cat];
        if (catName == 'Party') {
          return _buildPartyRoomsList();
        }
        final list = _allHosts.where((h) {
          if (_navIndex == 1) return _followedHosts.any((f) => f.id == h.id);
          if (catName == 'Hot') return h.status == 'Online';
          if (catName == 'Live') return h.status == 'Live';
          return true;
        }).toList();

        return Column(
          children: [
            if (_cat == 1 && catName == 'Live') _buildScreenshotStyleSubFilterPanel(),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.82, crossAxisSpacing: 6, mainAxisSpacing: 6),
                padding: const EdgeInsets.all(6),
                itemCount: list.length,
                itemBuilder: (ctx, i) {
                  final h = list[i];
                  return GestureDetector(
                    onTap: () => _handleHostTap(h, list),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(h.pic, fit: BoxFit.cover),
                          Positioned(top: 6, left: 6, child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)), child: Text('${h.flag} ${h.status}', style: const TextStyle(color: Colors.white, fontSize: 9)))),
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
      case 3: // Messages
        return ListView(
          padding: const EdgeInsets.all(12),
          children: const [
            ListTile(leading: CircleAvatar(backgroundColor: Colors.pink, child: Icon(Icons.favorite)), title: Text('Like Me / Date', style: TextStyle(color: Colors.white)), subtitle: Text('Find your match 💖')),
          ],
        );
      case 4: // Me
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(child: Column(children: [const CircleAvatar(radius: 30, child: Icon(Icons.person)), const SizedBox(height: 6), const Text('User7789', style: TextStyle(color: Colors.white, fontSize: 16)), const Text('VIP Member', style: TextStyle(color: Colors.white54, fontSize: 12))])),
            const SizedBox(height: 10),
            Card(color: Colors.grey[850], child: ListTile(leading: const Icon(Icons.account_balance_wallet, color: Colors.greenAccent), title: const Text('Host Earnings: ₹12500', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), trailing: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green), onPressed: () {}, child: const Text('Payout')))),
            const SizedBox(height: 20),
            const Text('Wallet History:', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16)),
            ..._history.map((item) => Card(color: Colors.grey, child: ListTile(title: Text(item, style: const TextStyle(color: Colors.white))))),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: _navIndex == 0
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: _cats.asMap().entries.map((e) => GestureDetector(
                  onTap: () => setState(() => _cat = e.key),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(e.value, style: TextStyle(color: _cat == e.key ? Colors.pink : Colors.white70, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                )).toList(),
              )
            : Text(_navIndex == 1 ? 'Following' : _navIndex == 2 ? 'Games' : _navIndex == 3 ? 'Messages' : 'Profile', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [
          Center(child: Text(_selectedCountry, style: const TextStyle(fontSize: 11, color: Colors.amber))),
          IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.diamond, color: Colors.amber), onPressed: _showRechargeModal),
        ],
      ),
      body: Stack(
        children: [
          _buildCurrentTabContent(),
          if (_hasMiniPlayer)
            Positioned(
              bottom: 20, right: 20,
              child: GestureDetector(
                onTap: () {
                  setState(() => _hasMiniPlayer = false);
                  final matchedHost = _allHosts.firstWhere((h) => h.name == _miniStreamerName, orElse: () => _allHosts.first);
                  _handleHostTap(matchedHost, _allHosts);
                },
                child: Container(
                  width: 110, height: 150,
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.pink, width: 2)),
                  child: Stack(
                    children: [
                      ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(_miniStreamerPic, fit: BoxFit.cover, width: 110, height: 150)),
                      Positioned(
                        top: 2, right: 2,
                        child: InkWell(
                          onTap: () => setState(() => _hasMiniPlayer = false),
                          child: const CircleAvatar(radius: 9, backgroundColor: Colors.black54, child: Icon(Icons.close, size: 10, color: Colors.white)),
                        ),
                      ),
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
          BottomNavigationBarItem(icon: Icon(Icons.sports_esports), label: 'Game'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}
                      
