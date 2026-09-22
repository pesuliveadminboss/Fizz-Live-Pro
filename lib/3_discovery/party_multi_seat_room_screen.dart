import 'dart:async';
import 'package:flutter/material.dart';
import '../wallet/wallet_screen.dart';
import '../4_interactions/call_screen.dart';
import 'profile_detail_view_screen.dart';

class PartyMultiSeatRoomScreen extends StatefulWidget {
  final dynamic streamer;
  final VoidCallback? onMinimizePartyPiP;
  final VoidCallback? onRestoreFullParty;

  const PartyMultiSeatRoomScreen({
    super.key,
    required this.streamer,
    this.onMinimizePartyPiP,
    this.onRestoreFullParty,
  });

  @override
  State<PartyMultiSeatRoomScreen> createState() => _PartyMultiSeatRoomScreenState();
}

class _PartyMultiSeatRoomScreenState extends State<PartyMultiSeatRoomScreen> {
  int userWalletGems = 5000;
  bool isFollowed = false;
  int userCount = 12;
  int currentThemeIndex = 0;
  Timer? _themeTimer;
  final TextEditingController _msgController = TextEditingController();
  final List<String> chatMessages = ['Welcome to Party Room!', 'Audio vibe ON 🎵'];

  final List<Map<String, dynamic>> themes = [
    {'name': 'Nature Forest', 'colors': [const Color(0xFF1B4D3E), const Color(0xFF0F0B1E)], 'icon': Icons.eco},
    {'name': 'Deep Sea', 'colors': [const Color(0xFF0C2340), const Color(0xFF0F0B1E)], 'icon': Icons.waves},
    {'name': 'Mountain Mist', 'colors': [const Color(0xFF3B444B), const Color(0xFF130F25)], 'icon': Icons.landscape},
  ];

  final List<Map<String, dynamic>> seats = List.generate(12, (index) => {
    'name': index < 5 ? 'User_${101 + index}' : 'Empty Seat',
    'idDigit': '${90001001 + index}',
    'gems': '${(index + 1) * 150}',
    'isOccupied': index < 5,
    'status': index % 2 == 0 ? 'online' : 'party',
  });

  @override
  void initState() {
    super.initState();
    _themeTimer = Timer.periodic(const Duration(seconds: 20), (timer) {
      if (mounted) {
        setState(() {
          currentThemeIndex = (currentThemeIndex + 1) % themes.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _themeTimer?.cancel();
    _msgController.dispose();
    super.dispose();
  }

  void _checkGemsAndAction(int requiredGems, VoidCallback onSuccess) {
    if (userWalletGems < requiredGems) {
      _showRechargeDialog(requiredGems);
    } else {
      setState(() {
        userWalletGems -= requiredGems;
      });
      onSuccess();
    }
  }

  void _showRechargeDialog(int needed) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1F1A24),
        title: const Text('Low Gems Alert 💎', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
        content: Text('Not enough gems! Required/Shortage detected. Recharge now to continue.', style: const TextStyle(color: Colors.white, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => WalletScreen(initialCoins: userWalletGems)));
            },
            child: const Text('Recharge Plan'),
          ),
        ],
      ),
    );
  }

  void _openUserProfileModalOrPage(Map<String, dynamic> seatData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileDetailViewScreen(streamer: seatData),
      ),
    );
  }

  void _joinPartyAction() {
    _checkGemsAndAction(500, () {
      setState(() {
        userCount++;
        chatMessages.add('You joined the party room (-500 gems entry)');
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Joined Party Room! 500 gems deducted.'), backgroundColor: Colors.green),
      );
    });
  }

  void _sendChatMessage() {
    if (_msgController.text.trim().isEmpty) return;
    setState(() {
      chatMessages.add('You: ${_msgController.text.trim()}');
      _msgController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeTheme = themes[currentThemeIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0F0B1E),
      body: Stack(
        children: [
          // Dynamic 20s changing theme background
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(seconds: 2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: activeTheme['colors'] as List<Color>,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Top Header (Streamer profile, theme indicator, follow heart, viewer count, × close/minimize)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProfileDetailViewScreen(streamer: widget.streamer),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            const CircleAvatar(radius: 16, backgroundColor: Colors.pinkAccent, child: Icon(Icons.person, size: 18, color: Colors.white)),
                            const SizedBox(width: 6),
                            const Text('Party Host', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () => setState(() => isFollowed = !isFollowed),
                              child: Icon(
                                isFollowed ? Icons.favorite : Icons.favorite_border,
                                color: isFollowed ? Colors.black : Colors.pinkAccent,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Icon(activeTheme['icon'] as IconData, size: 11, color: Colors.cyanAccent),
                            const SizedBox(width: 4),
                            Text(activeTheme['name'] as String, style: const TextStyle(color: Colors.white70, fontSize: 9)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // User count click to view list of party participants
                      GestureDetector(
                        onTap: _showParticipantsListModal,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(14)),
                          child: Row(
                            children: [
                              const Icon(Icons.people, color: Colors.white, size: 12),
                              const SizedBox(width: 4),
                              Text('$userCount', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Right side × close / minimize to mini floating party audio pill
                      GestureDetector(
                        onTap: () {
                          if (widget.onMinimizePartyPiP != null) {
                            widget.onMinimizePartyPiP!();
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: const CircleAvatar(radius: 14, backgroundColor: Colors.black54, child: Icon(Icons.close, size: 16, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                // 10-15 Audio seats grid (12 multi-audio seats)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    child: GridView.builder(
                      itemCount: seats.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (_, index) {
                        final seat = seats[index];
                        final occupied = seat['isOccupied'] as bool;
                        return GestureDetector(
                          onTap: () => _openUserProfileModalOrPage(seat),
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: occupied ? Colors.purple.withOpacity(0.5) : Colors.white12,
                                    child: Icon(occupied ? Icons.person : Icons.mic_off, size: 20, color: occupied ? Colors.white : Colors.white38),
                                  ),
                                  if (occupied)
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                                        child: const Icon(Icons.mic, size: 7, color: Colors.white),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(seat['name'] as String, style: const TextStyle(color: Colors.white, fontSize: 9), overflow: TextOverflow.ellipsis),
                              Text('💎 ${seat['gems']}', style: const TextStyle(color: Colors.amber, fontSize: 8)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Chat / Interaction preview feed area
                SizedBox(
                  height: 90,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    itemCount: chatMessages.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(chatMessages[i], style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    ),
                  ),
                ),
                // Center Join Party Button & Bottom Action Dock
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 4, 14, 16),
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        ),
                        onPressed: _joinPartyAction,
                        child: const Text('Join Party (-500 gems) 🎙️', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 36,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(18)),
                              child: TextField(
                                controller: _msgController,
                                style: const TextStyle(color: Colors.white, fontSize: 11),
                                decoration: const InputDecoration(
                                  hintText: 'Chat in party...',
                                  hintStyle: TextStyle(color: Colors.white54, fontSize: 10),
                                  border: InputBorder.none,
                                ),
                                onSubmitted: (_) => _sendChatMessage(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _sendChatMessage,
                            child: const CircleAvatar(radius: 16, backgroundColor: Colors.pinkAccent, child: Icon(Icons.send, size: 13, color: Colors.white)),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              _checkGemsAndAction(10, () {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gift sent in party room! 🎁')));
                              });
                            },
                            child: const CircleAvatar(radius: 16, backgroundColor: Colors.amber, child: Icon(Icons.card_giftcard, size: 14, color: Colors.black)),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              _checkGemsAndAction(1800, () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const CallScreen(callType: 'Video')));
                              });
                            },
                            child: const CircleAvatar(radius: 16, backgroundColor: Colors.redAccent, child: Icon(Icons.video_call, size: 16, color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showParticipantsListModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1A24),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        height: 320,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Party Participants (1 to 1 Profile Access)', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            const Divider(color: Colors.white24),
            Expanded(
              child: ListView.builder(
                itemCount: seats.length,
                itemBuilder: (_, i) {
                  final s = seats[i];
                  return ListTile(
                    leading: const CircleAvatar(backgroundColor: Colors.pinkAccent, child: Icon(Icons.person, color: Colors.white)),
                    title: Text(s['name'] as String, style: const TextStyle(color: Colors.white, fontSize: 13)),
                    subtitle: Text('Status: ${s['status']} | Gems: ${s['gems']}', style: const TextStyle(color: Colors.amber, fontSize: 10)),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
                      onPressed: () {
                        Navigator.pop(context);
                        _openUserProfileModalOrPage(s);
                      },
                      child: const Text('Profile', style: TextStyle(fontSize: 10)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

