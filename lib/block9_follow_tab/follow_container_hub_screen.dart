import 'package:flutter/material.dart';
import 'follow_sync_service.dart';
import 'smart_follow_grid_view.dart';

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
      // 👉 Jump directly to the individual Live Room screen (Screenshot 2 view)
      Navigator.pushNamed(
        context,
        '/live_room_screen',
        arguments: {
          'streamerId': user.id,
          'streamerName': user.name,
          'avatarUrl': user.avatarUrl,
        },
      );
    } else if (user.status == 'Party') {
      // 👉 Jump directly to the specific Party Room screen with 10 seats (Screenshot 3 view)
      Navigator.pushNamed(
        context,
        '/party_room_screen',
        arguments: {
          'roomId': user.id,
          'roomTitle': '${user.name}\'s Party Room',
        },
      );
    } else {
      // 👉 Jump directly to the Full Profile screen for Active/Busy status (Screenshot 1 view)
      Navigator.pushNamed(
        context,
        '/streamer_profile_screen',
        arguments: {
          'streamerId': user.id,
          'streamerName': user.name,
        },
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
