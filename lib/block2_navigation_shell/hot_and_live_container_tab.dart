import 'package:flutter/material.dart';
import 'hot_tab_grid_screen.dart';
import 'country_search_filter_helper.dart';
import '../block5_live_streaming/live_tab_screen.dart';

class HotAndLiveContainerTab extends StatefulWidget {
  const HotAndLiveContainerTab({super.key});

  @override
  State<HotAndLiveContainerTab> createState() => _HotAndLiveContainerTabState();
}

class _HotAndLiveContainerTabState extends State<HotAndLiveContainerTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCountry = 'All';

  @override
  void initState() {
    super.initState();
    // 4 Tabs: Hot, Live, Party, Match
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openCountryFilter() async {
    final String? result = await CountrySearchFilterHelper.showCountryFilterDialog(context, _selectedCountry);
    if (result != null) {
      setState(() {
        _selectedCountry = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121026),
        elevation: 0,
        title: Row(
          children: [
            // Tabs Bar (Hot, Live, Party, Match)
            Expanded(
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: Colors.pinkAccent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: 'Hot'),
                  Tab(text: 'Live'),
                  Tab(text: 'Party'),
                  Tab(text: 'Match'),
                ],
              ),
            ),
            // Country Filter Button
            IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.white),
              onPressed: _openCountryFilter,
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. Hot Tab Grid Screen with country filter parameter
          HotTabGridScreen(countryFilter: _selectedCountry),
          
          // 2. Live Tab (Block 5 Only Live Streamers Grid & Live Room)
          const LiveTabScreen(),
          
          // 3. Party Tab Placeholder
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.party_mode, size: 64, color: Colors.white24),
                SizedBox(height: 12),
                Text('Party Rooms Coming Soon 🎉', style: TextStyle(color: Colors.white60, fontSize: 14)),
              ],
            ),
          ),
          
          // 4. Match Tab Placeholder
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.people_alt, size: 64, color: Colors.white24),
                SizedBox(height: 12),
                Text('Matchmaking Coming Soon 💖', style: TextStyle(color: Colors.white60, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
