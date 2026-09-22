import 'package:flutter/material.dart';
import 'streamer_model.dart';
import 'live_stream_room_screen.dart' hide StreamerItemData;
import '../4_interactions/call_screen.dart';
import '../4_interactions/gift_sheet.dart';
import '../4_interactions/party_room_widget.dart';

class DiscoveryFeedScreen extends StatefulWidget {
  const DiscoveryFeedScreen({super.key});

  @override
  State<DiscoveryFeedScreen> createState() => _DiscoveryFeedScreenState();
}

class _DiscoveryFeedScreenState extends State<DiscoveryFeedScreen> {
  StreamerItemData? activePiPStreamer;
  List<StreamerItemData> streamers = [
    StreamerItemData(id: 's1', name: 'Ayesha_Live', idDigit: '99011', type: 'video'),
    StreamerItemData(id: 's2', name: 'Party_King_99', idDigit: '901', type: 'party'),
    StreamerItemData(id: 's3', name: 'Nisha_Vibe', idDigit: '88421', type: 'video'),
  ];

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0B1E),
      body: Stack(
        children: [
          GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: streamers.length,
            itemBuilder: (_, index) {
              final item = streamers[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LiveStreamRoomScreen(
                        streamer: item,
                        onDismissTotal: () => Navigator.pop(context),
                        onMinimizePIP: (streamerData) {
                          Navigator.pop(context);
                          setState(() {
                            activePiPStreamer = streamerData;
                          });
                        },
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F1A24),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          item.type == 'party' ? Icons.group : Icons.person,
                          size: 50,
                          color: Colors.white24,
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        right: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              item.type == 'party' ? 'Party Room' : 'Video Call • 💎 40/min',
                              style: const TextStyle(color: Colors.amber, fontSize: 10),
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
          if (activePiPStreamer != null)
            Positioned(
              bottom: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  final currentPiP = activePiPStreamer!;
                  setState(() => activePiPStreamer = null);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LiveStreamRoomScreen(
                        streamer: currentPiP,
                        onDismissTotal: () => Navigator.pop(context),
                        onMinimizePIP: (streamerData) {
                          Navigator.pop(context);
                          setState(() {
                            activePiPStreamer = streamerData;
                          });
                        },
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 120,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.pinkAccent, width: 2),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          activePiPStreamer!.type == 'party' ? Icons.group : Icons.person,
                          color: Colors.white54,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => setState(() => activePiPStreamer = null),
                          child: const CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.black54,
                            child: Icon(Icons.close, size: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
