import 'dart:async';
import 'package:flutter/material.dart';
import '../1_core/core_data.dart';
import '../2_auth/user_profile_model.dart';
import 'streamer_model.dart';
import 'streamer_profile_sheet.dart';
import 'live_stream_model.dart';
import '../4_interactions/call_and_party_screens.dart';

class LiveStreamRoomScreen extends StatefulWidget {
  final StreamerItemData streamer;
  final VoidCallback onDismissTotal;
  final Function(StreamerItemData) onMinimizePIP;

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
  late List<LiveChatMessage> chatMessages;
  final chatCtrl = TextEditingController();
  final List<String> miniAds = [
    'AdMob #1: Play & Earn 💎',
    'AdMob #2: VIP Dating Pass 🚀',
    'AdMob #3: Topup 50% Bonus 🔥',
    'AdMob #4: Lucky Wheel Spin 🎡',
    'AdMob #5: Secret Room Access 🔒',
  ];
  int adIndex = 0;
  Timer? adTimer;

  @override
  void initState() {
    super.initState();
    chatMessages = getInitialLiveChat();
    adTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => adIndex = (adIndex + 1) % miniAds.length);
    });
  }

  @override
  void dispose() {
    adTimer?.cancel();
    chatCtrl.dispose();
    super.dispose();
  }

  void _sendChatMessage([String? customText]) {
    final text = customText ?? chatCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      chatMessages.add(LiveChatMessage(senderName: userProfile.username.isNotEmpty ? userProfile.username : 'You', text: text));
    });
    if (customText == null) chatCtrl.clear();
  }

  void _showViewersModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF140D26),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Live Viewers (${mockLiveViewers.length})', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: ListView.builder(
                itemCount: mockLiveViewers.length,
                itemBuilder: (_, i) {
                  final v = mockLiveViewers[i];
                  return ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(v.avatarUrl)),
                    title: Text(v.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text('ID: ${v.id} • ${v.country} • ${v.age}y', style: const TextStyle(color: Colors.amber, fontSize: 11)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full screen feed video/image with safe fallback
          Image.network(
            widget.streamer.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: const Color(0xFF1F1A24), child: const Center(child: Icon(Icons.person, size: 100, color: Colors.white24))),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black54, Colors.transparent, Colors.black87],
              ),
            ),
          ),
          // Top Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => showStreamerProfileModal(context, widget.streamer),
                    child: Row(
                      children: [
                        CircleAvatar(radius: 18, backgroundImage: NetworkImage(widget.streamer.imageUrl)),
                        const SizedBox(width: 8),
                        Text(widget.streamer.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() => widget.streamer.isFollowed = !widget.streamer.isFollowed);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(widget.streamer.isFollowed ? 'Following' : 'Unfollowing'), duration: const Duration(seconds: 2)),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                      child: Icon(
                        widget.streamer.isFollowed ? Icons.favorite : Icons.favorite_border,
                        color: widget.streamer.isFollowed ? Colors.white : Colors.pinkAccent,
                        size: 16,
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _showViewersModal,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(12)),
                      child: Text('${mockLiveViewers.length}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onMinimizePIP(widget.streamer);
                    },
                  ),
                ],
              ),
            ),
          ),
          // AdMob Monetized Ticker
          Positioned(
            bottom: 120, right: 16,
            child: Container(
              width: 130, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('AdMob Monetized', style: TextStyle(color: Colors.amber, fontSize: 8, fontWeight: FontWeight.bold)),
                  Text(miniAds[adIndex], style: const TextStyle(color: Colors.white, fontSize: 10), maxLines: 1),
                ],
              ),
            ),
          ),
          // Live Chat Ticker
          Positioned(
            bottom: 70, left: 16, right: 100, height: 160,
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.white],
                stops: [0.0, 0.3],
              ).createShader(bounds),
              blendMode: BlendMode.dstIn,
              child: ListView.builder(
                reverse: true,
                itemCount: chatMessages.length,
                itemBuilder: (_, index) {
                  final msg = chatMessages[chatMessages.length - 1 - index];
                  if (msg.isJoinEvent) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.3), borderRadius: BorderRadius.circular(14)),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: '${msg.senderName} : ', style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 11)),
                            TextSpan(text: msg.text, style: const TextStyle(color: Colors.white, fontSize: 11)),
                          ],
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${msg.senderName} : ',
                            style: TextStyle(
                              color: msg.isStreamer ? Colors.redAccent : Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          TextSpan(text: msg.text, style: const TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Bottom Chat Input + Send Icon + Gifts/Call
          Positioned(
            bottom: 12, left: 12, right: 12,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.only(left: 14, right: 4),
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(22), border: Border.all(color: Colors.white24)),
                    child: TextField(
                      controller: chatCtrl,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Say something...',
                        hintStyle: const TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send_rounded, color: Colors.pinkAccent, size: 20),
                          onPressed: () => _sendChatMessage(),
                        ),
                      ),
                      onSubmitted: (_) => _sendChatMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => showGiftSendingSheet(context, widget.streamer.name),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.pinkAccent.withOpacity(0.8), shape: BoxShape.circle),
                    child: const Icon(Icons.card_giftcard, color: Colors.white, size: 18),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ZegoVideoCallScreen(streamerName: widget.streamer.name, streamerId: widget.streamer.id8Digit),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.purpleAccent]), shape: BoxShape.circle),
                    child: const Icon(Icons.video_call, color: Colors.white, size: 18),
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

// Draggable Floating PIP Wrapper
class DraggableLivePIPWrapper extends StatefulWidget {
  final StreamerItemData streamer;
  final VoidCallback onDismissTotal;
  final VoidCallback onExpandFull;

  const DraggableLivePIPWrapper({super.key, required this.streamer, required this.onDismissTotal, required this.onExpandFull});

  @override
  State<DraggableLivePIPWrapper> createState() => _DraggableLivePIPWrapperState();
}

class _DraggableLivePIPWrapperState extends State<DraggableLivePIPWrapper> {
  Offset position = const Offset(20, 100);

  @override
  Widget build(context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        feedback: Material(
          color: Colors.transparent,
          child: _pipBox(),
        ),
        childWhenDragging: const SizedBox.shrink(),
        onDragEnd: (details) {
          setState(() {
            position = Offset(details.offset.dx.clamp(0.0, 240.0), details.offset.dy.clamp(40.0, 500.0));
          });
        },
        child: GestureDetector(
          onTap: widget.onExpandFull,
          child: _pipBox(),
        ),
      ),
    );
  }

  Widget _pipBox() {
    return Container(
      width: 140, height: 210,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.pinkAccent, width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 10)],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            widget.streamer.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: Colors.black87),
          ),
          Positioned(
            top: 4, right: 4,
            child: GestureDetector(
              onTap: widget.onDismissTotal,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                child: const Icon(Icons.close, color: Colors.white, size: 14),
              ),
            ),
          ),
          Positioned(
            bottom: 6, left: 6, right: 6,
            child: Text(widget.streamer.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10), maxLines: 1),
          ),
        ],
      ),
    );
  }
}
