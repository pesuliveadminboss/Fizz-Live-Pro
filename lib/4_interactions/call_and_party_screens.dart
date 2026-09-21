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
  }

  void _tapSeat(int index) {
    setState(() {
      final myName = userProfile.username.isNotEmpty ? userProfile.username : 'Guest_Vibe';
      if (seats[index] == null) {
        seats[index] = myName;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Joined seat #${index + 1} ($myName)')));
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
                          final List<int> quantOptions =;
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
  final bool isBackpackFree;

  const GiftItem({
    required this.name,
    required this.gemPrice,
    required this.emoji,
    this.isBackpackFree = false,
  });
}

final Map<String, int> userBackpackInventory = {
  'Linked Ring': 2,
  'RosePerfume': 144,
  'LoveCrown': 144,
  'Fluttering...': 28,
  'Voting': 3,
};

final List<GiftItem> appGiftCatalog = [
  const GiftItem(name: 'Linked Ring', gemPrice: 2, emoji: '💍', isBackpackFree: true),
  const GiftItem(name: 'RosePerfume', gemPrice: 2, emoji: '🌹', isBackpackFree: true),
  const GiftItem(name: 'LoveCrown', gemPrice: 2, emoji: '👑', isBackpackFree: true),
  const GiftItem(name: 'Fluttering...', gemPrice: 2, emoji: '🦋', isBackpackFree: true),
  const GiftItem(name: 'Voting', gemPrice: 10, emoji: '📜', isBackpackFree: true),
  const GiftItem(name: 'Cute Love', gemPrice: 890, emoji: '💌'),
  const GiftItem(name: 'Flower Heart', gemPrice: 3990, emoji: '💐'),
  const GiftItem(name: 'Love Gala...', gemPrice: 17000, emoji: '💖'),
  const GiftItem(name: 'Valentine...', gemPrice: 57000, emoji: '🌹'),
  const GiftItem(name: 'Eid Blessing', gemPrice: 770, emoji: '🌙'),
  const GiftItem(name: 'Eid Night', gemPrice: 27770, emoji: '🕌'),
  const GiftItem(name: 'Eid Feast', gemPrice: 50770, emoji: '✨'),
  const GiftItem(name: 'Wealth Ca...', gemPrice: 995800, emoji: '🏆'),
];

void showRechargeModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF1F1A24),
      title: const Row(
        children: [
          Icon(Icons.diamond, color: Colors.amber),
          SizedBox(width: 8),
          Text('Insufficient Gems', style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
      content: const Text(
        'Your gem balance is empty or insufficient for this gift/action!',
        style: TextStyle(color: Colors.white70, fontSize: 13),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
          onPressed: () {
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Recharge Now opened! 💎 Bonus 50% active.'), duration: Duration(seconds: 3)),
            );
          },
          child: const Text('Recharge Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}

void showGiftSendingSheet(BuildContext context, String targetName) {
  String selectedCategory = 'Bag';
  int selectedQuantity = 1;
  final List<int> quantOptions =;
  
  

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF19112E),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    
      return StatefulBuilder(
        builder: (BuildContext modalCtx, StateSetter setStateModal) {
          final categories = ['Hot', 'Lucky', 'Svip', 'Intimacy', 'Wealth', 'Festival', 'Bag'];
          final displayedGifts = selectedCategory == 'Bag'
              ? appGiftCatalog.where((g) => g.isBackpackFree).toList()
              : appGiftCatalog.where((g) => !g.isBackpackFree).toList();

          GiftItem? selectedGift = displayedGifts.isNotEmpty ? displayedGifts.first : null;

          return Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Send to $targetName', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    ValueListenableBuilder<int>(
                      valueListenable: globalWallet,
                      builder: (_, val, __) => Row(
                        children: [
                          const Icon(Icons.diamond, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text('$val', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                if (selectedCategory == 'Bag')
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text('The gifts in the backpack are free', style: TextStyle(color: Colors.white60, fontSize: 11)),
                  ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 32,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: categories.map((cat) {
                      final isSelected = selectedCategory == cat;
                      return GestureDetector(
                        onTap: () => setStateModal(() => selectedCategory = cat),
                        child: Container(
                          margin: const EdgeInsets.only(right: 14),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            border: isSelected ? const Border(bottom: BorderSide(color: Colors.white, width: 2)) : null,
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white.withOpacity(0.65),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 210,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: displayedGifts.length,
                    itemBuilder: (_, index) {
                      final gift = displayedGifts[index];
                      final isSelected = selectedGift?.name == gift.name;
                      final backpackCount = userBackpackInventory[gift.name] ?? 0;

                      return GestureDetector(
                        onTap: () => setStateModal(() => selectedGift = gift),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.pinkAccent.withOpacity(0.25) : Colors.white.withOpacity(0.06),
                            border: Border.all(color: isSelected ? Colors.pinkAccent : Colors.white12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: Stack(
                            children: [
                              if (gift.isBackpackFree && backpackCount > 0)
                                Positioned(
                                  top: 0, right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                    decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(8)),
                                    child: Text('$backpackCount', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(gift.emoji, style: const TextStyle(fontSize: 24)),
                                    const SizedBox(height: 4),
                                    Text(gift.name, style: const TextStyle(color: Colors.white, fontSize: 9), overflow: TextOverflow.ellipsis),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.diamond, color: Colors.amber, size: 9),
                                        const SizedBox(width: 2),
                                        Text('${gift.gemPrice}', style: const TextStyle(color: Colors.amber, fontSize: 9, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (dotIdx) => Container(
                    width: dotIdx == 0 ? 12 : 5,
                    height: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: dotIdx == 0 ? Colors.white : Colors.white24,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  )),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: quantOptions.map((qty) {
                        final isSelected = selectedQuantity == qty;
                        return GestureDetector(
                          onTap: () => setStateModal(() => selectedQuantity = qty),
                          child: Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white.withOpacity(0.2) : Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text('$qty', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                          ),
                        );
                      }).toList(),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        shape: RoundedRectangleBorder(borderRad
