import 'package:flutter/material.dart';
import 'party_room_model.dart';
import 'party_room_list_screen.dart';
import 'party_room_creator_screen.dart';

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
        preferredSize: const Size.fromHeight(48.0),
        child: AppBar(
          backgroundColor: const Color(0xFF121026),
          elevation: 0,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.pinkAccent,
            labelColor: Colors.pinkAccent,
            unselectedLabelColor: Colors.white60,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [
              Tab(text: 'All Rooms'),
              Tab(text: 'Trending'),
              Tab(text: 'My Favorites'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          PartyRoomListScreen(),
          Center(child: Text('Trending Party Rooms Coming Soon', style: TextStyle(color: Colors.white60))),
          Center(child: Text('No Favorite Rooms Yet', style: TextStyle(color: Colors.white60))),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pinkAccent,
        icon: const Icon(Icons.mic, color: Colors.white),
        label: const Text('Start Room', style: TextStyle(color: Colors.white)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PartyRoomCreatorScreen()),
          );
        },
      ),
    );
  }
}
