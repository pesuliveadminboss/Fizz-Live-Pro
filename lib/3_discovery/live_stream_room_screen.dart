import 'package:flutter/material.dart';
import 'streamer_model.dart' as model;
import '../4_interactions/call_screen.dart';

class LiveStreamRoomScreen extends StatefulWidget {
  final dynamic streamer;
  final VoidCallback onDismissTotal;
  final ValueChanged<dynamic> onMinimizePIP;

  const LiveStreamRoomScreen({
    super.key,
    required this.streamer,
    required this.onDismissTotal,
    required this.onMinimizePIP,
  });

  @override
  State<LiveStreamRoomScreen> createState() => _LiveStreamRoomScreenState();
}

class _LiveStreamRoomScreenState extends State<LiveStreamRoomScreen> {
  int userCount = 3;
  final TextEditingController _msgController = TextEditingController();
  final List<Map<String, dynamic>> messages = [];
  bool isFollowed = false;

  final List<Map<String, String>> viewersList = [
    {'name': 'user-0001', 'id': '90001001', 'age': '24', 'country': 'IN 🇮🇳'},
    {'name': 'user-0002', 'id': '90001002', 'age': '22', 'country': 'US 🇺🇸'},
    {'name': 'user-0003', 'id': '90001003', 'age': '26', 'country': 'AE 🇦🇪'},
  ];

  @override
  void initState() {
    super.initState();
    messages.add({'type': 'join', 'text': 'user-0001 : join the stream'});
    messages.add({'type': 'chat', 'user': 'user-0002', 'msg': 'hii good morning'});
    isFollowed = widget.streamer is model.StreamerItemData ? widget.streamer.isFollowed : false;

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          userCount++;
          messages.add({'type': 'join', 'text': 'user-0004 : join the stream'});
        });
      }
    });
  }

  void _sendMessage() {
    if (_msgController.text.trim().isEmpty) return;
    setState(() {
      messages.add({
        'type': 'chat',
        'user': 'user-0001',
        'msg': _msgController.text.trim(),
      });
      _msgController.clear();
    });
  }

  void _showGiftComboSheet() {
    final combos =;
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1A24),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        height: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Send Combo Gift 🎁', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: combos.map((cnt) => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    messages.add({'type': 'chat', 'user': 'streamer', 'msg': 'Received x$cnt special gift! Thank you!'});
                  });
                },
                child: Text('x$cnt Combo'),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showViewersModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1A24),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Live Viewers', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(color: Colors.white24),
            Expanded(
              child: ListView.builder(
                itemCount: viewersList.length,
                itemBuilder: (_, i) {
                  final v = viewersList[i];
                  return ListTile(
                    leading: const CircleAvatar(backgroundColor: Colors.pinkAccent, child: Icon(Icons.person, color: Colors.white)),
                    title: Text(v['name']!, style: const TextStyle(color: Colors.yellow, fontSize: 13)),
                    subtitle: Text('ID: ${v['id']} | Age: ${v['age']} | ${v['country']}', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStreamerProfile() {
    final sName = widget.streamer is model.StreamerItemData ? widget.streamer.name : 'Streamer';
    final sIdDigit = widget.streamer is model.StreamerItemData ? widget.streamer.idDigit : '101';
    final sCountry = widget.streamer is model.StreamerItemData ? widget.streamer.country : 'IN 🇮🇳';
    final sInduction = widget.streamer is model.StreamerItemData ? widget.streamer.induction : 'Welcome!';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1F1A24),
        title: Text(sName, style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: $sIdDigit', style: const TextStyle(color: Colors.yellow)),
            Text('Country: $sCountry', style: TextStyle(color: Colors.white.withOpacity(0.7))),
            Text('Induction: $sInduction', style: TextStyle(color: Colors.white.withOpacity(0.7))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close', style: TextStyle(color: Colors.pinkAccent))),
        ],
      ),
    );
  }

  @override
  Widget build(context) {
    final sName = widget.streamer is model.StreamerItemData ? widget.streamer.name : 'Live Stream';
    final sIdDigit = widget.streamer is model.StreamerItemData ? widget.streamer.idDigit : '101';

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const Center(child: Icon(Icons.live_tv, size: 80, color: Colors.white12)),
          Positioned(
            top: 40,
            left: 12,
            right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _showStreamerProfile,
                  child: Row(
                    children: [
                      const CircleAvatar(radius: 18, backgroundColor: Colors.pinkAccent, child: Icon(Icons.person, size: 20)),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(sName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () => setState(() => isFollowed = !isFollowed),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: isFollowed ? Colors.black54 : Colors.pinkAccent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(isFollowed ? Icons.favorite : Icons.favorite_border, size: 10, color: Colors.white),
                                      const SizedBox(width: 2),
                                      Text(isFollowed ? 'black' : 'follow', style: const TextStyle(color: Colors.white, fontSize: 8)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text('ID: $sIdDigit • 💎 40/min', style: const TextStyle(color: Colors.yellow, fontSize: 9)),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _showViewersModal,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)),
                        child: Text('$userCount', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => widget.onMinimizePIP(widget.streamer),
                      child: const CircleAvatar(radius: 14, backgroundColor: Colors.black54, child: Icon(Icons.close, size: 16, color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 95,
            right: 12,
            child: Column(
              children: List.generate(3, (i) => Container(
                margin: const EdgeInsets.only(bottom: 4),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(child: Text('AD${i + 1}', style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold))),
              )),
            ),
          ),
          Positioned(
            bottom: 75,
            left: 12,
            right: 120,
            child: SizedBox(
              height: 140,
              child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (_, index) {
                  final msgItem = messages[messages.length - 1 - index];
                  final isJoin = msgItem['type'] == 'join';
                  return Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: EdgeInsets.symmetric(horizontal: isJoin ? 10 : 0, vertical: isJoin ? 3 : 1),
                    decoration: isJoin
                        ? BoxDecoration(color: Colors.blue.withOpacity(0.4), borderRadius: BorderRadius.circular(12))
                        : null,
                    child: RichText(
                      text: TextSpan(
                        children: isJoin
                            ? [
                                TextSpan(
                                  text: msgItem['text'],
                                  style: const TextStyle(color: Colors.white, fontSize: 11),
                                ),
                              ]
                            : [
                                TextSpan(
                                  text: '${msgItem['user']} : ',
                                  style: TextStyle(
                                    color: msgItem['user'] == 'streamer' ? Colors.redAccent : Colors.yellow,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: msgItem['msg'],
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 12,
            right: 12,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 38,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                    child: TextField(
                      controller: _msgController,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      decoration: const InputDecoration(
                        hintText: 'Say something...',
                        hintStyle: TextStyle(color: Colors.white60, fontSize: 11),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: const CircleAvatar(radius: 18, backgroundColor: Colors.pinkAccent, child: Icon(Icons.send, size: 14, color: Colors.white)),
                ),
                const SizedBox(width: 6),
                const Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.favorite, color: Colors.pinkAccent, size: 32),
                    Text('follow', style: TextStyle(color: Colors.white, fontSize: 6, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: _showGiftComboSheet,
                  child: const CircleAvatar(radius: 18, backgroundColor: Colors.amber, child: Icon(Icons.card_giftcard, size: 16, color: Colors.black)),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CallScreen()));
                  },
                  child: const CircleAvatar(radius: 18, backgroundColor: Colors.redAccent, child: Icon(Icons.video_call, size: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
