import 'package:flutter/material.dart';
import '../block3_hot_tab/hot_tab_grid_screen.dart';
import '../block4_live_tab_filters/live_tab_screen.dart';
import 'country_search_filter_helper.dart';

class HotAndLiveContainerTab extends StatefulWidget {
  const HotAndLiveContainerTab({super.key});

  @override
  State<HotAndLiveContainerTab> createState() => _HotAndLiveContainerTabState();
}

class _HotAndLiveContainerTabState extends State<HotAndLiveContainerTab> {
  String selectedCountryFilter = 'All';

  void _openSearchDialog() {
    showDialog(
      context: context,
      builder: (_) => const SearchStreamerDialog(),
    );
  }

  void _openCountryFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1D1B36),
      builder: (ctx) => CountryFilterListModal(
        selectedCountry: selectedCountryFilter,
        onSelected: (country) {
          setState(() => selectedCountryFilter = country);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          AppBar(
            backgroundColor: const Color(0xFF121026),
            title: const Text('Fizz Live Pro', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            actions: [
              IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: _openSearchDialog),
              IconButton(icon: const Icon(Icons.public, color: Colors.white), onPressed: _openCountryFilterModal),
            ],
            bottom: const TabBar(
              indicatorColor: Color(0xFFF97316),
              labelColor: Color(0xFFF97316),
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(text: 'Hot'),
                Tab(text: 'Live'),
                Tab(text: 'Party'),
                Tab(text: 'Match'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                HotTabGridScreen(countryFilter: selectedCountryFilter),
                const LiveTabScreen(),
                const Center(child: Text('Party Screen', style: TextStyle(color: Colors.white))),
                const Center(child: Text('Match Screen', style: TextStyle(color: Colors.white))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
