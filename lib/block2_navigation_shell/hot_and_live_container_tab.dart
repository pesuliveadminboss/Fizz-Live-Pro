import 'package:flutter/material.dart';
import 'hot_tab_grid_screen.dart';
import 'country_search_filter_helper.dart';
import '../block5_live_streaming/live_tab_screen.dart';
import '../block5_live_streaming/live_streamer_model.dart';
import '../block5_live_streaming/live_streamer_grid_card.dart';

class HotAndLiveContainerTab extends StatefulWidget {
  const HotAndLiveContainerTab({super.key});

  @override
  State<HotAndLiveContainerTab> createState() => _HotAndLiveContainerTabState();
}

class _HotAndLiveContainerTabState extends State<HotAndLiveContainerTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCountry = 'All';
  String _searchQuery = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _openCountryFilter() async {
    final String? result = await CountrySearchFilterHelper.showCountryFilterDialog(context, _selectedCountry);
    if (result != null) {
      setState(() {
        _selectedCountry = result;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Country filtered by: $_selectedCountry'), duration: const Duration(seconds: 1)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter streamers based on search query and selected country
    final searchedStreamers = LiveStreamer.dummyStreamers.where((streamer) {
      final matchesSearch = streamer.name.toLowerCase().contains(_searchQuery);
      // Assuming a mock country property or category matching for demonstration
      final matchesCountry = _selectedCountry == 'All' || streamer.category.toLowerCase() == _selectedCountry.toLowerCase() || _selectedCountry == 'India';
      return matchesSearch && matchesCountry;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121026),
        elevation: 0,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Search streamer name...',
                  hintStyle: TextStyle(color: Colors.white60),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              )
            : SizedBox(
                height: kToolbarHeight,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: false,
                  indicatorColor: Colors.pinkAccent,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: 'Hot'),
                    Tab(text: 'Live'),
                    Tab(text: 'Party'),
                    Tab(text: 'Match'),
                  ],
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchQuery = '';
                  _searchController.clear();
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.public, color: Colors.white),
            onPressed: _openCountryFilter,
          ),
        ],
      ),
      body: _isSearching && _searchQuery.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: searchedStreamers.isEmpty
                  ? const Center(child: Text('No streamers found', style: TextStyle(color: Colors.white60)))
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: searchedStreamers.length,
                      itemBuilder: (context, index) {
                        return LiveStreamerGridCard(streamer: searchedStreamers[index]);
                      },
                    ,
            )
          : TabBarView(
              controller: _tabController,
              children: [
                const HotTabGridScreen(),
                const LiveTabScreen(),
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
      
