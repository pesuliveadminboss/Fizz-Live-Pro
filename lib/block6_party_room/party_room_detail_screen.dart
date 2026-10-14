import 'package:flutter/material.dart';
import 'party_room_model.dart';
import 'party_room_capsule_header.dart';
import 'party_room_audio_manager.dart';
import 'party_gift_animation_helper.dart';

class PartyRoomDetailScreen extends StatefulWidget {
  final PartyRoomModel room;

  const PartyRoomDetailScreen({super.key, required this.room});

  @override
  State<PartyRoomDetailScreen> createState() => _PartyRoomDetailScreenState();
}

class _PartyRoomDetailScreenState extends State<PartyRoomDetailScreen> {
  bool _isJoined = false;
  bool _isMuted = false;
  bool _isFollowing = false;
  late final List<Map<String, dynamic>> _seats;

  @override
  void initState() {
    super.initState();
    // 10 Voice Seats (5 Top, 5 Bottom) matching second screenshot[span_3](start_span)[span_3](end_span)
    _seats = List.generate(10, (index) => {
          'seatIndex': index + 1,
          'userName': index == 0 ? widget.room.hostName : 'Seat ${index + 1}',
          'isOccupied': index == 0,
          'isMuted': false,
        });
    _connectRoom();
  }

  Future<void> _connectRoom() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _isJoined = true;
      });
    }
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    PartyRoomAudioManager.showAudioStatus(context, _isMuted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Cinematic Background Effect matching second screenshot[span_4](start_span)[span_4](end_span)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E1B4B), Color(0xFF3B0764), Color(0xFF0F172A)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Opacity(
                  opacity: 0.25,
                  child: Icon(Icons.directions_boat, size: 280, color: Colors.pinkAccent),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Top Header & Minimize (X) Button matching second screenshot[span_5](start_span)[span_5](end_span)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PartyRoomCapsuleHeader(
                        hostName: widget.room.hostName,
                        onlineCount: widget.room.onlineCount,
                        isFollowing: _isFollowing,
                        onProfileTap: () {},
                        onFollowTap: () {
                          setState(() {
                            _isFollowing = !_isFollowing;
                          });
                        },
                      ),
                      IconButton(
                        icon: const CircleAvatar(
                          backgroundColor: Colors.black54,
                          radius: 16,
                          child: Icon(Icons.close, color: Colors.white, size: 18),
                        ),
                        onPressed: () {
                          // Minimizes / Pops back to Hub smoothly
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                // 10 Voice Seats Grid (5 Top, 5 Bottom)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: _seats.length,
                      itemBuilder: (context, index) {
                        final seat = _seats[index];
                        bool isOccupied = seat['isOccupied'];

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              seat['isOccupied'] = !isOccupied;
                              seat['userName'] = seat['isOccupied'] ? 'You' : 'Seat ${index + 1}';
                            });
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundColor: isOccupied ? Colors.pinkAccent.withOpacity(0.5) : Colors.white12,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      isOccupied ? Icons.mic : Icons.mic_none,
                                      color: isOccupied ? Colors.white : Colors.white30,
                                      size: 22,
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: Colors.black87,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          '${seat['seatIndex']}',
                                          style: const TextStyle(color: Colors.cyanAccent, fontSize: 8, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                seat['userName'],
                                style: const TextStyle(color: Colors.white70, fontSize: 10),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Live Chat & Welcome Box matching second screenshot[span_6](start_span)[span_6](end_span)
                Container(
                  height: 130,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: ListView(
                    children: const [
                      Text(
                        "Welcome to Party Room! Something pornographic, vulgar, violent and under age is forbidden to appear in the live...",
                        style: TextStyle(color: Colors.amberAccent, fontSize: 11),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "👑 Raj Shukla : Nice to meet you! Come on, grab the mic and follow us!",
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "🎁 Chandran S sent a Luxury Cruise Ship!",
                        style: TextStyle(color: Colors.pinkAccent, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Safe Ad Banner Slot (Non-intrusive)
                Container(
                  height: 35,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D1B36),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: const Center(
                    child: Text(
                      "AdMob Party Room Safe Banner Slot [Button Size]",
                      style: TextStyle(color: Colors.white54, fontSize: 10),
                    ),
                  ),
                ),
                // Bottom Toolbar for Mute, Gifts & Tools matching second screenshot[span_7](start_span)[span_7](end_span)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D1B36).withOpacity(0.95),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        style: IconButton.styleFrom(backgroundColor: _isMuted ? Colors.redAccent : Colors.white24),
                        onPressed: _toggleMute,
                        icon: Icon(_isMuted ? Icons.mic_off : Icons.mic, color: Colors.white, size: 20),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          PartyGiftAnimationHelper.showPartyGiftAnimation(context, 'Luxury Cruise Ship', 'Chandran S');
                        },
                        icon: const Icon(Icons.card_giftcard, color: Colors.white, size: 16),
                        label: const Text('Send Gift 🎁', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                      IconButton(
                        style: IconButton.styleFrom(backgroundColor: Colors.white24),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Raise Hand requested 🙋‍♂️')),
                          );
                        },
                        icon: const Icon(Icons.back_hand, color: Colors.cyanAccent, size: 20),
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
}
