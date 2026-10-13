import 'package:flutter/material.dart';
import 'party_room_model.dart';
import '../block7_zego_realtime/zego_realtime_service.dart';

class PartyRoomDetailScreen extends StatefulWidget {
  final PartyRoomModel room;

  const PartyRoomDetailScreen({super.key, required this.room});

  @override
  State<PartyRoomDetailScreen> createState() => _PartyRoomDetailScreenState();
}

class _PartyRoomDetailScreenState extends State<PartyRoomDetailScreen> {
  bool _isJoined = false;
  bool _isMuted = false;
  late final List<Map<String, dynamic>> _seats;

  @override
  void initState() {
    super.initState();
    _seats = List.generate(8, (index) => {
          'seatIndex': index + 1,
          'userName': index == 0 ? 'Host (${widget.room.hostName})' : 'Empty Seat',
          'isOccupied': index == 0,
          'isMuted': false,
        });
    _joinZegoRoom();
  }

  Future<void> _joinZegoRoom() async {
    await ZegoRealtimeService.initZegoEngine();
    bool success = await ZegoRealtimeService.loginRoom(
      widget.room.roomID,
      "user_${DateTime.now().millisecondsSinceEpoch}",
      "User_${widget.room.roomID}",
    );
    if (success) {
      setState(() {
        _isJoined = true;
      });
      await ZegoRealtimeService.startPublishing("stream_${widget.room.roomID}");
    }
  }

  @override
  void dispose() {
    ZegoRealtimeService.stopPublishing();
    ZegoRealtimeService.logoutRoom(widget.room.roomID);
    super.dispose();
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    ZegoRealtimeService.setMicrophoneMuted(_isMuted);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isMuted ? 'Microphone Muted' : 'Microphone Unmuted'),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1B36),
        title: Text(widget.room.roomName, style: const TextStyle(color: Colors.white, fontSize: 16)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  const Icon(Icons.person, color: Colors.cyanAccent, size: 16),
                  const SizedBox(width: 4),
                  Text('${widget.room.onlineCount}', style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF1A1738),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isJoined ? Icons.fiber_manual_record : Icons.hourglass_empty,
                  color: _isJoined ? Colors.greenAccent : Colors.orangeAccent,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  _isJoined ? 'Zego Audio Connected: Live' : 'Connecting to Party Room...',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: _seats.length,
              itemBuilder: (context, index) {
                final seat = _seats[index];
                bool isOccupied = seat['isOccupied'];

                return Column(
                  children: [
                    Expanded(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: isOccupied ? Colors.pinkAccent.withOpacity(0.3) : Colors.white12,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              isOccupied ? Icons.mic : Icons.mic_none,
                              color: isOccupied ? Colors.pinkAccent : Colors.white30,
                              size: 28,
                            ),
                            if (!isOccupied)
                              const Positioned(
                                bottom: 0,
                                right: 0,
                                child: Icon(Icons.add_circle, color: Colors.cyanAccent, size: 16),
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
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1D1B36),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isMuted ? Colors.redAccent : Colors.pinkAccent,
                  ),
                  onPressed: _toggleMute,
                  icon: Icon(_isMuted ? Icons.mic_off : Icons.mic, color: Colors.white),
                  label: Text(_isMuted ? 'Muted' : 'Mute', style: const TextStyle(color: Colors.white)),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gift feature coming up next!')),
                    );
                  },
                  icon: const Icon(Icons.card_giftcard, color: Colors.white),
                  label: const Text('Send Gift', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
