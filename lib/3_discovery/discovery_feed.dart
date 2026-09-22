import 'package:flutter/material.dart';
import 'streamer_model.dart' as model;
import 'live_stream_room_screen.dart' as room;
import '../4_interactions/call_screen.dart';
import 'profile_detail_view_screen.dart';
import 'party_multi_seat_room_screen.dart';
import 'match_screen.dart';

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

  dynamic activePartyPiPStreamer;
  Offset partyPiPPosition = const Offset(20, 520);

  String selectedLanguageFilter = 'All';

  List<model.StreamerItemData> streamers = [
    model.StreamerItemData(name: 'Ayesha_Live', type: 'live', isFollowed: true, language: 'Tamil, English'),
    model.StreamerItemData(name: 'Party_King_99', type: 'party', language: 'Hindi, English'),
    model.StreamerItemData(name: 'Nisha_Vibe', type: 'online', language: 'Tamil'),
    model.StreamerItemData(name: 'Offline_Guy', type: 'offline', language: 'English'),
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

  void _showSearchDialog() {
    final TextEditingController searchCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1F1A24),
        title: const Text('Search by 8-Digit ID', style: TextStyle(color: Colors.white, fontSize: 14)),
        content: TextField(
          controller: searchCtrl,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'e.g. 90001001',
            hintStyle: TextStyle(color: Colors.white54),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
            onPressed: () {
              Navigator.pop(context);
              _showBottomToast('Searching ID: ${searchCtrl.text}');
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showLanguageFilterSheet() {
    final langs = ['All', 'Tamil', 'English', 'Hindi'];
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1A24),
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filter by Language 🌐', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ...langs.map((l) => ListTile(
              title: Text(l, style: const TextStyle(color: Colors.white)),
              trailing: selectedLanguageFilter == l ? const Icon(Icons.check, color: Colors.pinkAccent) : null,
              onTap: () {
                setState(() => selectedLanguageFilter = l);
                Navigator.pop(context);
                _showBottomToast('Language filter: $l');
              },
            )),
          ],
        ),
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
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white, size: 20),
              onPressed: _showSearchDialog,
            ),
            IconButton(
              icon: const Icon(Icons.language, color: Colors.white, size: 20),
              onPressed: _showLanguageFilterSheet,
            ),
          ],
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
              const MatchScreen(),
            ],
          ),
          // Live Video PiP
          if (activePiPStreamer != null)
            Positioned(
              left: pipPosition.dx,
              top: pipPosition.dy,
              child: Draggable(
                feedback: _buildPiPBox(),
                childWhenDragging: const SizedBox.shrink(),
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
          // Party Audio Mini PiP
          if (activePartyPiPStreamer != null)
            Positioned(
              left: partyPiPPosition.dx,
              top: partyPiPPosition.dy,
              child: Draggable(
                feedback: _buildMiniPartyPiPBox(),
                childWhenDragging: const SizedBox.shrink(),
                onDragEnd: (details) {
                  setState(() {
                    partyPiPPosition = Offset(
                      details.offset.dx.clamp(0.0, MediaQuery.of(context).size.width - 100),
                      details.offset.dy.clamp(0.0, MediaQuery.of(context).size.height - 200),
                    );
                  });
                },
                child: GestureDetector(
                  onTap: () {
                    final item = activePartyPiPStreamer;
                    setState(() => activePartyPiPStreamer = null);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PartyMultiSeatRoomScreen(
                          streamer: item,
                          onMinimizePartyPiP: () {
                            Navigator.pop(context);
                            setState(() => activePartyPiPStreamer = item);
                          },
                        ),
                      ),
                    );
                  },
                  child: _buildMiniPartyPiPBox(),
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

  Widget _buildMiniPartyPiPBox() {
    return Container(
      width: 100,
      height: 140,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.purpleAccent, Colors.pinkAccent]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 8)],
      ),
      child: Stack(
        children: [
          const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.graphic_eq, color: Colors.white, size: 28),
                SizedBox(height: 4),
                Text('Party Audio', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => setState(() => activePartyPiPStreamer = null),
              child: const CircleAvatar(radius: 9, backgroundColor: Colors.black54, child: Icon(Icons.close, size: 10, color: Colors.white)),
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

    if (selectedLanguageFilter != 'All') {
      list = list.where((s) => s.language.toLowerCase().contains(selectedLanguageFilter.toLowerCase())).toList();
    }

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PartyMultiSeatRoomScreen(
                    streamer: item,
                    onMinimizePartyPiP: () {
                      Navigator.pop(context);
                      setState(() => activePartyPiPStreamer = item);
                    },
                  ),
                ),
              );
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfileDetailViewScreen(streamer: item)),
              );
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
