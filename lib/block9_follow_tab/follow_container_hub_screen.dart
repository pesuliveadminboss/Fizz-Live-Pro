import 'package:flutter/material.dart';
import 'follow_sync_service.dart';
import 'smart_follow_grid_view.dart';

// 👉 Import respective screen files to navigate directly:
import '../block3_hot_tab/streamer_profile_screen.dart';
import '../block3_hot_tab/streamer_profile_model.dart';
import '../block5_live_streaming/live_room_screen.dart';
import '../block5_live_streaming/live_streamer_model.dart';
import '../block6_party_room/party_room_screen.dart';
import '../block6_party_room/party_room_model.dart';

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
      // 👉 Jump directly to Live Room Screen (Screenshot 2 view)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LiveRoomScreen(
            streamer: LiveStreamer(
              streamerId: user.id,
              streamerName: user.name,
              avatarUrl: user.avatarUrl,
              roomTitle: 'Live Room',
              viewersCount: 150,
              isLive: true,
            ),
          ),
        ),
      );
    } else if (user.status == 'Party') {
      // 👉 Jump directly to Party Room Screen with seats (Screenshot 3 view)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PartyRoomScreen(
            room: PartyRoomModel(
              roomId: user.id,
              roomTitle: '${user.name}\'s Party Ship',
              hostName: user.name,
              hostAvatarUrl: user.avatarUrl,
              activeMembersCount: 5,
            ),
          ),
        ),
      );
    } else {
      // 👉 Jump directly to Full Profile Screen for Active/Busy status (Screenshot 1 view)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StreamerProfileScreen(
            streamer: StreamerProfileModel(
              name: user.name,
              avatarUrl: user.avatarUrl,
              bio: 'Welcome to my profile!',
              followersCount: 450,
              followingCount: 180,
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
