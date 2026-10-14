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
    _seats = List.generate(8, (index) => {
          'seatIndex': index + 1,
          'userName': index == 0 ? widget.room.hostName : 'Empty Seat ${index + 1}',
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
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation & Capsule Header matching Live Streaming Style
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PartyRoomCapsuleHeader(
                    hostName: widget.room.hostName,
                    onlineCount: widget.room.onlineCount,
                    isFollowing: _isFollowing,
                    onProfileTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Viewing host profile: ${widget.room.hostName}')),
                      );
                    },
                    onFollowTap: () {
                      setState(() {
                        _isFollowing = !_isFollowing;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(_isFollowing ? 'Followed ${widget.room.hostName} ❤️' : 'Unfollowed')),
                      );
                    },
                  ),
                  IconButton(
                    icon: const CircleAvatar(
                      backgroundColor: Colors.black45,
                      radius: 16,
                      child: Icon(Icons.close, color: Colors.white, size: 18),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Container(
              height: 30,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white10),
              ),
              child: Center(
                child: Text(
                  _isJoined ? 'Connected to ${widget.room.roomName} 🚢' : 'Connecting to Voice Seats...',
                  style: const TextStyle(color: Colors.cyanAccent, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // 8 Voice Seats Grid (Interactive Party Room Layout)
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: _seats.length,
                itemBuilder: (context, index) {
                  final seat = _seats[index];
                  bool isOccupied = seat['isOccupied'];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (!isOccupied) {
                          seat['isOccupied'] = true;
                          seat['userName'] = 'You (Speaker)';
                        } else {
                          seat['isOccupied'] = false;
                          seat['userName'] = 'Empty Seat ${index + 1}';
                        }
                      });
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: CircleAvatar(
                            radius: 32,
                            backgroundColor: isOccupied ? Colors.pinkAccent.withOpacity(0.4) : Colors.white12,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  isOccupied ? Icons.mic : Icons.mic_none,
                                  color: isOccupied ? Colors.pinkAccent : Colors.white30,
                                  size: 30,
                                ),
                                Positioned(
                                  bottom: 2,
                                  right: 2,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '${seat['seatIndex']}',
                                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          seat['userName'],
                          style: const TextStyle(color: Colors.white70, fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Bottom Toolbar for Mic, Gifts & Theme Effects
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1D1B36).withOpacity(0.9),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: _isMuted ? Colors.redAccent : Colors.white24,
                    ),
                    onPressed: _toggleMute,
                    icon: Icon(_isMuted ? Icons.mic_off : Icons.mic, color: Colors.white),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      PartyGiftAnimationHelper.showPartyGiftAnimation(context, 'Luxury Cruise Ship', 'Chandran S');
                    },
                    icon: const Icon(Icons.card_giftcard, color: Colors.white, size: 18),
                    label: const Text('Send Gift 🎁', style: TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                  IconButton(
                    style: IconButton.styleFrom(backgroundColor: Colors.white24),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Raise Hand requested to Host 🙋‍♂️')),
                      );
                    },
                    icon: const Icon(Icons.back_hand, color: Colors.cyanAccent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
