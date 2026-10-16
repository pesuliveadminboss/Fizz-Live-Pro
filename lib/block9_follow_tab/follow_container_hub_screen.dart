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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Jumping to ${user.name}\'s Live Room...'), duration: const Duration(seconds: 1)),
      );
      // TODO: Navigate to Live Room screen
    } else if (user.status == 'Party') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Jumping to ${user.name}\'s Party Room...'), duration: const Duration(seconds: 1)),
      );
      // TODO: Navigate to Party Room Hub / Detail screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Opening ${user.name}\'s Full Profile...'), duration: const Duration(seconds: 1)),
      );
      // TODO: Navigate to Streamer Full Profile Screen
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
