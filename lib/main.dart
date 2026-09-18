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
  'Lucky': [
    const GiftItem('Mystery Box', 360, emoji: '🎁'),
  ],
  'Svip':,
  'Intimacy': [
    const GiftItem('In My Hand', 300, emoji: '🤝'),
    const GiftItem('Kiss', 180, emoji: '💋'),
  ],
  'Wealth': [
    const GiftItem('Cruise Eve', 3700, emoji: '🚢'),
  ],
  'Festival': [
    const GiftItem('Puppy', 180, emoji: '🐶'),
  ],
  'Bag':,
};

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
            decoration: BoxDecoration(color: Colors.pink.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
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
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => Positioned(
        bottom: 80,
        left: MediaQuery.of(ctx).size.width / 2 - 50,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(16)),
            child: const Text('Following', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 1), () => entry.remove());
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
                      Text('${widget.host.name} 🇮🇳', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(onTap: _triggerFollow, child: Icon(Icons.favorite, color: _followed ? Colors.pink : Colors.white70, size: 18)),
              ],
            ),
          ),
          Positioned(
            top: 40, right: 16,
            child: Row(
              children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)), child: const Text('👁️ 5', style: TextStyle(color: Colors.white, fontSize: 11))),
                const SizedBox(width: 8),
                IconButton(icon: const CircleAvatar(radius: 12, backgroundColor: Colors.black54, child: Icon(Icons.close, color: Colors.white, size: 14)), onPressed: () { widget.onCloseWithPiP(widget.host.name, widget.host.pic); Navigator.pop(context); }),
              ],
            ),
          ),
          Positioned(top: 80, right: 16, child: Container(width: 80, height: 35, color: Colors.black45, alignment: Alignment.center, child: const Text('AD SLOT', style: TextStyle(color: Colors.white54, fontSize: 9)))),
          Positioned(
            bottom: 70, left: 16, right: 120,
            child: FloatingChatOverlay(messages: _floatingMsgs),
          ),
          Positioned(
            bottom: 20, left: 16, width: MediaQuery.of(context).size.width * 0.52,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    decoration: InputDecoration(filled: true, fillColor: Colors.black54, hintText: 'Free message...', hintStyle: const TextStyle(color: Colors.white54, fontSize: 11), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                    onSubmitted: (_) => _sendChatMessage(),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send, color: Colors.pinkAccent, size: 18), onPressed: _sendChatMessage),
              ],
            ),
          ),
          Positioned(
            bottom: 20, right: 16,
            child: Row(
              children: [
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
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gift sent: $desc (-$cost Gems)')));
                        },
                      ));
                    },
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CallScreen(
                          host: widget.host.name,
                          pic: widget.host.pic,
                          gems: widget.gems,
                          onGems: widget.onGemsUpdate,
                          onEnd: (dur, secs) {},
                        ),
                      ),
                    );
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
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _navIndex = 0;
  int _cat = 0;
  int _subCat = 0;
  int _gems = 1670;
  final String _selectedCountry = '🇮🇳 India';
  final List<String> _history = ['Recharge: +4050 Gems', 'Video Call: -1800 Gems'];

  bool _hasMiniPlayer = false;
  String _miniStreamerName = '';
  String _miniStreamerPic = '';

  final List<Host> _followedHosts = [];
  final List<String> _cats = const ['Hot', 'Live', 'Party', 'Match'];
  final List<String> _subCats = const ['All', 'Pretty', 'New', 'Sexy'];

  final List<Host> _allHosts = const [
    Host(name: 'AvniHotnessDil', pic: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300', cat: 'Hot', tag: 'Pretty', flag: '🇮🇳', status: 'Online', id: 8002023),
    Host(name: 'Shiny Sanya', pic: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=300', cat: 'Hot', tag: 'New', flag: '🇮🇳', status: 'Online', id: 8002024),
    Host(name: 'Ritaj', pic: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=300', cat: 'Live', tag: 'Sexy', flag: '🇦🇪', status: 'Live', id: 8002025),
    Host(name: 'Moka', pic: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=300', cat: 'Live', tag: 'Pretty', flag: '🇪🇬', status: 'Live', id: 8002026),
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

  Widget _buildCurrentTabContent() {
    switch (_navIndex) {
      case 0:
      case 2:
        final catName = _cats[_cat];
        final list = _allHosts.where((h) {
          if (_cat == 1 && h.status != 'Live') return false;
          if (_cat == 0 && h.status != 'Online') return false;
          if (_subCat > 0 && h.tag.toLowerCase() != _subCats[_subCat].toLowerCase()) return false;
          return true;
        }).toList();

        return Column(
          children: [
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
      case 1:
        return _followedHosts.isEmpty
            ? const Center(child: Text('No Followed hosts yet!', style: TextStyle(color: Colors.grey)))
            : ListView.builder(
                itemCount: _followedHosts.length,
                itemBuilder: (ctx, i) => ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(_followedHosts[i].pic)),
                  title: Text(_followedHosts[i].name, style: const TextStyle(color: Colors.white)),
                  trailing: ElevatedButton(onPressed: () => _handleHostTap(_followedHosts[i], _followedHosts), child: const Text('View')),
                ),
              );
      case 3:
        return ListView(
          padding: const EdgeInsets.all(12),
          children: const [
            ListTile(leading: CircleAvatar(backgroundColor: Colors.pink, child: Icon(Icons.favorite)), title: Text('Like Me / Date', style: TextStyle(color: Colors.white)), subtitle: Text('Find your match 💖')),
          ],
        );
      case 4:
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
          BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'Live'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}
