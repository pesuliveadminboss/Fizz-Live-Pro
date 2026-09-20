import 'package:flutter/material.dart';
import '../1_core/core_data.dart';
import '../5_dashboard/post_login_popups.dart';

class StreamerItem {
  final String id8Digit;
  final String name;
  final String country;
  final String imageUrl;
  final String status;
  final String tag;

  const StreamerItem({
    required this.id8Digit,
    required this.name,
    required this.country,
    required this.imageUrl,
    required this.status,
    required this.tag,
  });
}

class DiscoveryFeedView extends StatefulWidget {
  const DiscoveryFeedView({super.key});

  @override
  State<DiscoveryFeedView> createState() => _DiscoveryFeedViewState();
}

class _DiscoveryFeedViewState extends State<DiscoveryFeedView> {
  int selectedTabIndex = 0; // 0: Hot, 1: Live, 2: Party, 3: Match
  final List<String> tabTitles = ['Hot', 'Live', 'Party', 'Match'];
  String selectedCountry = 'All';
  final List<String> countries = ['All', 'India', 'America', 'China', 'Bangladesh', 'Russia'];

  final List<StreamerItem> allStreamers = const [
    StreamerItem(id8Digit: '84920183', name: 'AvniHotnessDil', country: 'India', imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400', status: 'live', tag: 'Hot'),
    StreamerItem(id8Digit: '73920194', name: 'ShinySanya', country: 'India', imageUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400', status: 'online', tag: 'Party'),
    StreamerItem(id8Digit: '91827364', name: 'ExoticModel', country: 'America', imageUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400', status: 'live', tag: 'Exotic'),
    StreamerItem(id8Digit: '55443322', name: 'ChinaStar', country: 'China', imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400', status: 'offline', tag: 'Match'),
  ];

  void _openSearchByIdDialog() {
    final searchCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        title: const Text('Search 8-Digit ID', style: TextStyle(color: Colors.white, fontSize: 16)),
        content: TextField(
          controller: searchCtrl,
          keyboardType: TextInputType.number,
          maxLength: 8,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter 8-digit ID (e.g. 84920183)',
            hintStyle: TextStyle(color: Colors.white54),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryPink),
            onPressed: () {
              final query = searchCtrl.text.trim();
              Navigator.pop(ctx);
              final found = allStreamers.where((s) => s.id8Digit == query).toList();
              showModalBottomSheet(
                context: context,
                backgroundColor: AppTheme.cardDark,
                builder: (_) => Container(
                  padding: const EdgeInsets.all(20),
                  height: 250,
                  child: found.isNotEmpty
                      ? Column(
                          children: [
                            CircleAvatar(radius: 40, backgroundImage: NetworkImage(found.first.imageUrl)),
                            const SizedBox(height: 10),
                            Text(found.first.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('ID: ${found.first.id8Digit} | Country: ${found.first.country}', style: const TextStyle(color: Colors.amber)),
                            Text('Status: ${found.first.status.toUpperCase()}', style: TextStyle(color: found.first.status == 'live' ? Colors.green : Colors.white70)),
                            const Spacer(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Connect / View Profile'),
                            )
                          ],
                        )
                      : const Center(child: Text('User/Streamer not found for this 8-digit ID', style: TextStyle(color: Colors.white70))),
                ),
              );
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _openCountryFilterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardDark,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Country Streamers', style: TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...countries.map((c) => ListTile(
              title: Text(c, style: TextStyle(color: selectedCountry == c ? Colors.pinkAccent : Colors.white)),
              trailing: selectedCountry == c ? const Icon(Icons.check, color: Colors.pinkAccent) : null,
              onTap: () {
                setState(() => selectedCountry = c);
                Navigator.pop(ctx);
              },
            )),
          ],
        ),
      ),
    );
  }

  List<StreamerItem> _getCurrentFilteredList(List<StreamerItem> baseList) {
    var countryFiltered = baseList.where((s) {
      if (selectedCountry == 'All') return true;
      return s.country.toLowerCase() == selectedCountry.toLowerCase();
    }).toList();

    if (selectedTabIndex == 1) {
      return countryFiltered.where((s) => s.status == 'live').toList();
    } else if (selectedTabIndex == 2) {
      return countryFiltered.where((s) => s.tag == 'Party' || s.tag == 'Hot').toList();
    }
    return countryFiltered;
  }

  @override
  Widget build(context) {
    final currentList = _getCurrentFilteredList(allStreamers);

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Non-sliding static top row tabs + search + world icon
                Container(
                  color: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Row(
                        children: List.generate(tabTitles.length, (index) {
                          final isSelected = selectedTabIndex == index;
                          return GestureDetector(
                            onTap: () => setState(() => selectedTabIndex = index),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    tabTitles[index],
                                    style: TextStyle(
                                      color: isSelected ? Colors.amber : Colors.white.withOpacity(0.64),
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    height: 2,
                                    width: isSelected ? 24 : 0,
                                    color: Colors.amber,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.white70),
                        onPressed: _openSearchByIdDialog,
                      ),
                      IconButton(
                        icon: const Icon(Icons.public, color: Colors.white70),
                        onPressed: _openCountryFilterDialog,
                      ),
                    ],
                  ),
                ),
                if (selectedCountry != 'All')
                  Container(
                    color: Colors.black87,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      children: [
                        Text('Country Filter: $selectedCountry', style: const TextStyle(color: Colors.amber, fontSize: 12)),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => setState(() => selectedCountry = 'All'),
                          child: const Text('Reset', style: TextStyle(color: Colors.pinkAccent, fontSize: 12)),
                        )
                      ],
                    ),
                  ),
                Expanded(
                  child: _buildStreamerGrid(currentList),
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              left: 16,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => const DailyRewardsDialog(),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.purpleAccent]),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 8)],
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.card_giftcard, color: Colors.amber, size: 28),
                      Text('FREE', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreamerGrid(List<StreamerItem> list) {
    if (list.isEmpty) {
      return const Center(child: Text('No streamers found for this filter', style: TextStyle(color: Colors.white54)));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: list.length,
      itemBuilder: (_, index) {
        final item = list[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          color: AppTheme.cardDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(item.imageUrl, fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                  ),
                ),
              ),
              Positioned(
                top: 8, left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)),
                  child: Text('ID: ${item.id8Digit.substring(0, 4)}...', style: const TextStyle(color: Colors.white70, fontSize: 10)),
                ),
              ),
              Positioned(
                bottom: 8, left: 8, right: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    Text('${item.country} • ${item.status}', style: const TextStyle(color: Colors.amber, fontSize: 11)),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

