import 'package:flutter/material.dart';
import 'follow_manager_service.dart';
import 'follow_girls_grid_view.dart';
import 'follow_room_grid_view.dart';

class FollowTabContainerScreen extends StatefulWidget {
  const FollowTabContainerScreen({super.key});

  @override
  State<FollowTabContainerScreen> createState() => _FollowTabContainerScreenState();
}

class _FollowTabContainerScreenState extends State<FollowTabContainerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FollowManagerService _followManager = FollowManagerService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _followManager.addListener(_onFollowChanged);
  }

  void _onFollowChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _followManager.removeListener(_onFollowChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121026),
        elevation: 0,
        centerTitle: false,
        title: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.pinkAccent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
          tabs: const [
            Tab(text: 'Follow Girls'),
            Tab(text: 'Follow Room'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search followed users...'), duration: Duration(milliseconds: 800)),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FollowGirlsGridView(
            followedGirls: _followManager.followedGirls,
            onUnfollow: (item) {
              _followManager.toggleFollow(item);
            },
          ),
          FollowRoomGridView(
            followedRooms: _followManager.followedRooms,
            onUnfollow: (item) {
              _followManager.toggleFollow(item);
            },
          ),
        ],
      ),
    );
  }
}

