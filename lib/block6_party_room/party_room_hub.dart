import 'package:flutter/material.dart';
import 'party_room_list_screen.dart';

class PartyRoomHub extends StatefulWidget {
  const PartyRoomHub({super.key});

  @override
  State<PartyRoomHub> createState() => _PartyRoomHubState();
}

class _PartyRoomHubState extends State<PartyRoomHub> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          backgroundColor: const Color(0xFF1D1B36),
          elevation: 0,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.pinkAccent,
            labelColor: Colors.pinkAccent,
            unselectedLabelColor: Colors.white60,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: const [
              Tab(text: "All Rooms"),
              Tab(text: "Trending 🚢"),
              Tab(text: "Favorites ❤️"),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 35,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1738),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.white10),
            ),
            child: const Center(
              child: Text(
                "AdMob Hub Banner Slot [Button Size]",
                style: TextStyle(color: Colors.white38, fontSize: 10),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                PartyRoomListScreen(),
                Center(child: Text("Trending Party Rooms", style: TextStyle(color: Colors.white60))),
                Center(child: Text("Favorite Rooms", style: TextStyle(color: Colors.white60))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
