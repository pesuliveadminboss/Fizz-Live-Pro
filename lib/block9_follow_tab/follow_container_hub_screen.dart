import 'package:flutter/material.dart';
import 'follow_sync_service.dart';
import 'smart_follow_grid_view.dart';

// Direct imports for exact target screens based on user status
import '../block3_hot_tab/streamer_profile_screen.dart';
import '../block3_hot_tab/streamer_profile_model.dart';
import '../block5_live_streaming/live_room_screen.dart';
import '../block6_party_room/party_room_screen.dart';

class FollowContainerHubScreen extends StatefulWidget {
  const FollowContainerHubScreen({super.key});

  @override
  State<FollowContainerHubScreen> createState() => _FollowContainerHubScreenState();
}

class _FollowContainerHubScreenState extends State<FollowContainerHubScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FollowSyncService _syncService = FollowSyncService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _syncService.addListener(_onSyncChanged);
  }

  void _onSyncChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _syncService.removeListener(_onSyncChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _handleUserTap(FollowUserModel user) {
    if (user.status == 'Live') {
      // Jump directly to the specific Live Room Screen (Screenshot 2 view)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LiveRoomScreen(),
        ),
      );
    } else if (user.status == 'Party') {
      // Jump directly to the specific Party Room Screen with 10 seats (Screenshot 3 view)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PartyRoomScreen(),
        ),
      );
    } else {
      // Jump directly to the Streamer's Full Profile Screen (Screenshot 1 view)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StreamerProfileScreen(
            streamer: StreamerProfileModel(
              name: user.name,
              avatarUrl: user.avatarUrl,
              bio: 'Welcome to my profile!',
              followersCount: 500,
              followingCount: 150,
              isFollowing: true,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121026),
        elevation: 0,
        title: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.pinkAccent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Follow Girls'),
            Tab(text: 'Follow Room'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SmartFollowGridView(
            userList: _syncService.getFollowedGirls(),
            onCardTap: _handleUserTap,
          ),
          SmartFollowGridView(
            userList: _syncService.getFollowedRooms(),
            onCardTap: _handleUserTap,
          ),
        ],
      ),
    );
  }
}
