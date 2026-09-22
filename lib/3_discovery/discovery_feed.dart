import 'package:flutter/material.dart';
import 'streamer_model.dart' as model;
import 'live_stream_room_screen.dart' as room;
import '../4_interactions/call_screen.dart';
import '../4_interactions/gift_sheet.dart';
import '../4_interactions/party_room_widget.dart';

typedef DiscoveryFeedView = DiscoveryFeedScreen;

class DiscoveryFeedScreen extends StatefulWidget {
  const DiscoveryFeedScreen({super.key});

  @override
  State<DiscoveryFeedScreen> createState() => _DiscoveryFeedScreenState();
}

class _DiscoveryFeedScreenState extends State<DiscoveryFeedScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  dynamic activePiPStreamer;

  final List<Map<String, dynamic>> streamers = [
    {'name': 'Ayesha_Live', 'type': 'video'},
    {'name': 'Party_King_99', 'type': 'party'},
    {'name': 'Nisha_Vibe', 'type': 'video'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0B1E),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(42),
        child: AppBar(
          backgroundColor: const Color(0xFF0F0B1E),
          elevation: 0,
          titleSpacing: 0,
          title: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: Colors.pinkAccent,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: const [
              Tab(text: 'Hot'),
              Tab(text: 'Live'),
              Tab(text: 'Party'),
              Tab(text: 'Match'),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: List.generate(4, (_) => _buildStreamerGrid()),
          ),
          if (activePiPStreamer != null)
            Positioned(
              bottom: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  final roomStreamer = activePiPStreamer is room.StreamerItemData
                      ? activePiPStreamer
                      : room.StreamerItemData(
                          id: 'live_pip',
                          name: activePiPStreamer?.name?.toString() ?? 'Live',
                          idDigit: '101',
                          type: 'video',
                        );
                  setState(() => activePiPStreamer = null);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => room.LiveStreamRoomScreen(
                        streamer: roomStreamer,
                        onDismissTotal: () => Navigator.pop(context),
                        onMinimizePIP: (dynamic streamerData) {
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
                          activePiPStreamer?.name?.toString().toLowerCase().contains('party') == true
                              ? Icons.group
                              : Icons.person,
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

  Widget _buildStreamerGrid() {
    return GridView.builder(
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
        final nameVal = item['name'] as String;
        final isParty = nameVal.toLowerCase().contains('party') || item['type'] == 'party';
        return GestureDetector(
          onTap: () {
            final roomStreamer = room.StreamerItemData(
              id: nameVal,
              name: nameVal,
              idDigit: '101',
              type: isParty ? 'party' : 'video',
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => room.LiveStreamRoomScreen(
                  streamer: roomStreamer,
                  onDismissTotal: () => Navigator.pop(context),
                  onMinimizePIP: (dynamic streamerData) {
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
                    isParty ? Icons.group : Icons.person,
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
                        nameVal,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        isParty ? 'Party Room' : 'Video Call • 💎 40/min',
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
    );
  }
}
