import 'package:flutter/material.dart';
import '../1_core/core_data.dart';
import '../2_auth/user_profile_model.dart';

class ZegoVideoCallScreen extends StatefulWidget {
  final String streamerName;
  final String streamerId;
  final int gemCostPerMin;

  const ZegoVideoCallScreen({
    super.key,
    required this.streamerName,
    required this.streamerId,
    this.gemCostPerMin = 40,
  });

  @override
  State<ZegoVideoCallScreen> createState() => _ZegoVideoCallScreenState();
}

class _ZegoVideoCallScreenState extends State<ZegoVideoCallScreen> {
  bool isMicMuted = false;
  bool isCameraOff = false;
  bool isFrontCamera = true;

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: const Color(0xFF1F1A24),
            child: const Center(
              child: Icon(Icons.person, size: 120, color: Colors.white24),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  const CircleAvatar(backgroundColor: Colors.black45, child: Icon(Icons.shield, color: Colors.amber, size: 18)),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.streamerName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('ID: ${widget.streamerId} • 💎 ${widget.gemCostPerMin}/min', style: const TextStyle(color: Colors.amber, fontSize: 11)),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(12)),
                    child: const Text('00:45', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 40, left: 24, right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: 'mic',
                  backgroundColor: isMicMuted ? Colors.red : Colors.white24,
                  onPressed: () => setState(() => isMicMuted = !isMicMuted),
                  child: Icon(isMicMuted ? Icons.mic_off : Icons.mic, color: Colors.white),
                ),
                FloatingActionButton(
                  heroTag: 'cam',
                  backgroundColor: isCameraOff ? Colors.red : Colors.white24,
                  onPressed: () => setState(() => isCameraOff = !isCameraOff),
                  child: Icon(isCameraOff ? Icons.videocam_off : Icons.videocam, color: Colors.white),
                ),
                FloatingActionButton(
                  heroTag: 'flip',
                  backgroundColor: Colors.white24,
                  onPressed: () => setState(() => isFrontCamera = !isFrontCamera),
                  child: const Icon(Icons.flip_camera_ios, color: Colors.white),
                ),
                FloatingActionButton(
                  heroTag: 'gift_call',
                  backgroundColor: Colors.purple,
                  onPressed: () => showGiftSendingSheet(context, 'VideoCallUser'),
                  child: const Icon(Icons.card_giftcard, color: Colors.amber),
                ),
                FloatingActionButton(
                  heroTag: 'end_call',
                  backgroundColor: Colors.red,
                  onPressed: () => Navigator.pop(context),
                  child: const Icon(Icons.call_end, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PartyRoomGridWidget extends StatefulWidget {
  const PartyRoomGridWidget({super.key});

  @override
  State<PartyRoomGridWidget> createState() => _PartyRoomGridWidgetState();
}

class _PartyRoomGridWidgetState extends State<PartyRoomGridWidget> {
  final List<String?> seats = List.filled(9, null);

  @override
  void initState() {
    super.initState();
    seats[0] = 'Host_Alpha';
    seats = userProfile.username.isNotEmpty ? userProfile.username : 'Guest_Vibe'; // Fixed index assignment
  }

  void _tapSeat(int index) {
    setState(() {
      if (seats[index] == null) {
        seats[index] = userProfile.username.isNotEmpty ? userProfile.username : 'Me (You)';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Joined seat #${index + 1}')));
      } else {
        seats[index] = null;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Left seat #${index + 1}')));
      }
    });
  }

  @override
  Widget build(context) {
    return Container(
      color: const Color(0xFF110B22),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.group, color: Colors.amber),
                const SizedBox(width: 8),
                const Text('Party Vibe Room #901', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                GestureDetector(
                  onTap: () => showGiftSendingSheet(context, 'PartyRoomHost'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.purpleAccent]), borderRadius: BorderRadius.circular(16)),
                    child: const Text('Send Gift 🎁', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.9,
              ),
              itemCount: 9,
              itemBuilder: (_, index) {
                final occupant = seats[index];
                return GestureDetector(
                  onTap: () => _tapSeat(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: occupant != null ? Colors.pinkAccent.withOpacity(0.15) : Colors.white.withOpacity(0.05),
                      border: Border.all(color: occupant != null ? Colors.pinkAccent : Colors.white24),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: occupant != null ? Colors.amber.withOpacity(0.2) : Colors.white12,
                          child: Icon(occupant != null ? Icons.mic : Icons.add, color: occupant != null ? Colors.amber : Colors.white54),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          occupant ?? 'Seat ${index + 1}\nTap to Sit',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: occupant != null ? Colors.white : Colors.white54, fontSize: 10, fontWeight: occupant != null ? FontWeight.bold : FontWeight.normal),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GiftItem {
  final String name;
  final int gemPrice;
  final String emoji;

  const GiftItem({required this.name, required this.gemPrice, required this.emoji});
}

final List<GiftItem> appGiftCatalog = [
  const GiftItem(name: 'Rose', gemPrice: 20, emoji: '🌹'),
  const GiftItem(name: 'Diamond Ring', gemPrice: 150, emoji: '💍'),
  const GiftItem(name: 'Love Heart', gemPrice: 80, emoji: '💖'),
  const GiftItem(name: 'Super Sports Car', gemPrice: 999, emoji: '🏎️'),
];

void showGiftSendingSheet(BuildContext context, String targetName) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF19112E),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (ctx) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Send Gift to $targetName', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ValueListenableBuilder<int>(
                valueListenable: globalWallet,
                builder: (_, val, __) => Text('💎 $val', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10),
            itemCount: appGiftCatalog.length,
            itemBuilder: (_, index) {
              final gift = appGiftCatalog[index];
              return GestureDetector(
                onTap: () {
                  if (globalWallet.value >= gift.gemPrice) {
                    globalWallet.value -= gift.gemPrice;
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sent ${gift.name} ${gift.emoji} (-${gift.gemPrice} gems)!')),
                    );
                  } else {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Insufficient gems! Please recharge.')),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(gift.emoji, style: const TextStyle(fontSize: 26)),
                      const SizedBox(height: 4),
                      Text(gift.name, style: const TextStyle(color: Colors.white70, fontSize: 9), overflow: TextOverflow.ellipsis),
                      Text('💎 ${gift.gemPrice}', style: const TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}

