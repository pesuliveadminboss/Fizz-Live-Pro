import 'package:flutter/material.dart';
import 'dart:async';
import '../4_interactions/call_screen.dart';
import '../4_interactions/gift_sheet.dart';
import '../4_interactions/party_room_widget.dart';
import '../1_core/core_data.dart';
import '../2_auth/user_profile_model.dart';

class StreamerItemData {
  final String id;
  final String name;
  final String idDigit;
  final String type; // 'video' or 'party'
  StreamerItemData({required this.id, required this.name, required this.idDigit, required this.type});
}

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
  late List<String> chatMessages;
  final chatCtrl = TextEditingController();
  final List<String> miniAds = [
    'Ad #1: Play & Earn 💎',
    'Ad #2: VIP Dating Pass 🎟️',
    'Ad #3: Topup 50% Bonus 🔥',
    'Ad #4: Lucky Wheel Spin 🎡',
    'Ad #5: Secret Room Access 🔒',
  ];
  int adIndex = 0;
  Timer? adTimer;

  @override
  void initState() {
    super.initState();
    chatMessages = [
      "Welcome to ${widget.streamer.name}'s room!",
      'Say hi to the host 👋',
    ];
    adTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted) setState(() => adIndex = (adIndex + 1) % miniAds.length);
    });
  }

  @override
  void dispose() {
    adTimer?.cancel();
    chatCtrl.dispose();
    super.dispose();
  }

  void _sendChatMessage(String? customText) {
    final text = customText ?? chatCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      chatMessages.add('${userProfile.username.isNotEmpty ? userProfile.username : 'Guest'}: $text');
    });
    if (customText == null) chatCtrl.clear();
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          widget.streamer.type == 'party'
              ? const PartyRoomGridWidget()
              : ZegoVideoCallScreen(
                  streamerName: widget.streamer.name,
                  streamerId: widget.streamer.idDigit,
                ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.picture_in_picture_alt, color: Colors.white),
                    onPressed: () => widget.onMinimizePIP(widget.streamer),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: widget.onDismissTotal,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16, left: 16, right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    itemCount: chatMessages.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(10)),
                        child: Text(chatMessages[i], style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: chatCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Say something...',
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.black54,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        onSubmitted: (_) => _sendChatMessage(null),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.pinkAccent),
                      onPressed: () => _sendChatMessage(null),
                    ),
                    IconButton(
                      icon: const Icon(Icons.card_giftcard, color: Colors.amber),
                      onPressed: () => showGiftSendingSheet(context, widget.streamer.name),
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

class DraggableLivePIPWrapper extends StatefulWidget {
  final Widget child;
  const DraggableLivePIPWrapper({super.key, required this.child});

  @override
  State<DraggableLivePIPWrapper> createState() => _DraggableLivePIPWrapperState();
}

class _DraggableLivePIPWrapperState extends State<DraggableLivePIPWrapper> {
  double top = 100;
  double left = 20;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            top += details.delta.dy;
            left += details.delta.dx;
          });
        },
        child: widget.child,
      ),
    );
  }
}
