import 'package:flutter/material.dart';
import 'streamer_model.dart' as model;
import 'live_stream_room_screen.dart' as room;
import '../4_interactions/call_screen.dart';

typedef DiscoveryFeedView = DiscoveryFeedScreen;

class DiscoveryFeedScreen extends StatefulWidget {
  const DiscoveryFeedScreen({super.key});

  @override
  State<DiscoveryFeedScreen> createState() => _DiscoveryFeedScreenState();
}

class _DiscoveryFeedScreenState extends State<DiscoveryFeedScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  dynamic activePiPStreamer;
  Offset pipPosition = const Offset(20, 400);

  List<model.StreamerItemData> streamers = [
    model.StreamerItemData(name: 'Ayesha_Live', type: 'live', isFollowed: true),
    model.StreamerItemData(name: 'Party_King_99', type: 'party'),
    model.StreamerItemData(name: 'Nisha_Vibe', type: 'online'),
    model.StreamerItemData(name: 'Offline_Guy', type: 'offline'), // Hot-la vara koodadhu
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

  void _showBottomToast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.white, fontSize: 12)),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black87,
      ),
    );
  }

  void _toggleFollow(int index, String filter) {
    setState(() {
      final list = filter == 'hot'
          ? streamers.where((s) => s.type != 'offline').toList()
          : streamers.where((s) => s.type == filter).toList();
      final item = list[index];
      item.isFollowed = !item.isFollowed;
      _showBottomToast(item.isFollowed ? 'following' : 'unfollowing');
    });
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
            children: [
              _buildGrid(filter: 'hot'),
              _buildGrid(filter: 'live'),
              _buildGrid(filter: 'party'),
              _buildGrid(filter: 'online'),
            ],
          ),
          if (activePiPStreamer != null)
            Positioned(
              left: pipPosition.dx,
              top: pipPosition.dy,
              child: Draggable(
                feedback: _buildPiPBox(),
                onDragEnd: (details) {
                  setState(() {
                    pipPosition = Offset(
                      details.offset.dx.clamp(0.0, MediaQuery.of(context).size.width - 120),
                      details.offset.dy.clamp(0.0, MediaQuery.of(context).size.height - 200),
                    );
                  });
                },
                child: GestureDetector(
                  onTap: () {
                    final currentPiP = activePiPStreamer;
                    setState(() => activePiPStreamer = null);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => room.LiveStreamRoomScreen(
                          streamer: currentPiP,
                          onDismissTotal: () => Navigator.pop(context),
                          onMinimizePIP: (dynamic sd) {
                            Navigator.pop(context);
                            setState(() => activePiPStreamer = sd);
                          },
                        ),
                      ),
                    );
                  },
                  child: _buildPiPBox(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPiPBox() {
    return Container(
      width: 120,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.pinkAccent, width: 2),
      ),
      child: Stack(
        children: [
          const Center(child: Icon(Icons.videocam, color: Colors.white54, size: 40)),
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
    );
  }

  Widget _buildGrid({required String filter}) {
    List<model.StreamerItemData> list = filter == 'hot'
        ? streamers.where((s) => s.type != 'offline').toList()
        : streamers.where((s) => s.type == filter).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemCount: list.length,
      itemBuilder: (_, index) {
        final item = list[index];
        Color statusColor = item.type == 'online'
            ? Colors.green
            : item.type == 'live'
                ? Colors.redAccent
                : Colors.purpleAccent;

        return GestureDetector(
          onTap: () {
            if (item.type == 'party') {
              _showBottomToast('Opening Party Room: ${item.name}');
            } else if (item.type == 'live') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => room.LiveStreamRoomScreen(
                    streamer: item,
                    onDismissTotal: () => Navigator.pop(context),
                    onMinimizePIP: (dynamic sd) {
                      Navigator.pop(context);
                      setState(() => activePiPStreamer = sd);
                    },
                  ),
                ),
              );
            } else {
              _showBottomToast('Opening Profile: ${item.name} (${item.idDigit})');
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1F1A24),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(item.type == 'party' ? Icons.group : Icons.person, size: 50, color: Colors.white24),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(8)),
                    child: Text(item.type.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                  ),
                ),
                if (item.isFollowed)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(color: Colors.pinkAccent.withOpacity(0.8), borderRadius: BorderRadius.circular(6)),
                      child: const Text('your follow', style: TextStyle(color: Colors.white, fontSize: 7)),
                    ),
                  ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${item.name} | ${item.country} | ${item.age}y',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _toggleFollow(index, filter),
                            child: Icon(
                              item.isFollowed ? Icons.favorite : Icons.favorite_border,
                              color: item.isFollowed ? Colors.black : Colors.pinkAccent,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.type == 'party' ? 'Party Room' : 'Video Call • 💎 40/min', style: const TextStyle(color: Colors.amber, fontSize: 9)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const CallScreen()));
                            },
                            child: const Icon(Icons.video_call, color: Colors.pinkAccent, size: 20),
                          ),
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
    );
  }
}
