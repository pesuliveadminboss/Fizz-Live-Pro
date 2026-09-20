import 'package:flutter/material.dart';
import '../1_core/core_data.dart';
import '../5_dashboard/post_login_popups.dart';
import 'streamer_model.dart';
import 'streamer_profile_sheet.dart';
import 'live_stream_room_screen.dart';
import '../4_interactions/call_and_party_screens.dart';

class DiscoveryFeedView extends StatefulWidget {
  const DiscoveryFeedView({super.key});

  @override
  State<DiscoveryFeedView> createState() => _DiscoveryFeedViewState();
}

class _DiscoveryFeedViewState extends State<DiscoveryFeedView> {
  int selectedTabIndex = 0; // 0: Hot, 1: Live, 2: Party, 3: Match
  final List<String> tabTitles = ['Hot', 'Live', 'Party', 'Match'];
  String selectedCountry = 'All';
  final List<String> countries = ['All', 'India', 'Egypt', 'America', 'China', 'Bangladesh', 'Russia'];
  StreamerItemData? pipActiveStreamer;

  List<StreamerItemData> _getCurrentFilteredList() {
    var baseList = globalHotStreamers.where((s) => s.status != 'offline').toList();
    var countryFiltered = baseList.where((s) {
      if (selectedCountry == 'All') return true;
      return s.country.toLowerCase() == selectedCountry.toLowerCase();
    }).toList();

    if (selectedTabIndex == 1) {
      return countryFiltered.where((s) => s.status == 'live').toList();
    } else if (selectedTabIndex == 2) {
      return countryFiltered.where((s) => s.status == 'party').toList();
    }
    return countryFiltered;
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

  void _openSearchByIdDialog() {
    final searchCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        title: const Text('Search 8-Digit ID (90001001...)', style: TextStyle(color: Colors.white, fontSize: 15)),
        content: TextField(
          controller: searchCtrl,
          keyboardType: TextInputType.number,
          maxLength: 8,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(hintText: 'Enter 8-digit ID', hintStyle: TextStyle(color: Colors.white54)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryPink),
            onPressed: () {
              final query = searchCtrl.text.trim();
              Navigator.pop(ctx);
              final found = globalHotStreamers.where((s) => s.id8Digit == query).toList();
              if (found.isNotEmpty) {
                showStreamerProfileModal(context, found.first);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Streamer not found')));
              }
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(context) {
    final currentList = _getCurrentFilteredList();

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top static header row matching screenshot
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
                                  Container(height: 2, width: isSelected ? 24 : 0, color: Colors.amber),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                      const Spacer(),
                      IconButton(icon: const Icon(Icons.search, color: Colors.white70), onPressed: _openSearchByIdDialog),
                      IconButton(icon: const Icon(Icons.public, color: Colors.white70), onPressed: _openCountryFilterDialog),
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
                  child: currentList.isEmpty
                      ? const Center(child: Text('No streamers found', style: TextStyle(color: Colors.white54)))
                      : GridView.builder(
                          padding: const EdgeInsets.all(8),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: currentList.length,
                          itemBuilder: (_, index) {
                            final item = currentList[index];
                            return GestureDetector(
                              onTap: () {
                                if (item.status == 'live') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => LiveStreamRoomScreen(
                                        streamer: item,
                                        onDismissPIP: () {
                                          Navigator.pop(context);
                                          setState(() => pipActiveStreamer = null);
                                        },
                                      ),
                                    ),
                                  ).then((_) {
                                    // Option to convert to PIP if popped via system back
                                  });
                                } else if (item.status == 'party') {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: const Color(0xFF140D26),
                                    builder: (_) => const SizedBox(height: 500, child: PartyRoomGridWidget()),
                                  );
                                } else {
                                  showStreamerProfileModal(context, item);
                                }
                              },
                              child: Card(
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
                                          colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8, left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)),
                                        child: Row(
                                          children: [
                                            Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle)),
                                            const SizedBox(width: 4),
                                            Text(item.status.toUpperCase(), style: const TextStyle(color: Colors.greenAccent, fontSize: 9, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (item.isFollowed)
                                      Positioned(
                                        top: 8, right: 8,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(color: Colors.pinkAccent.withOpacity(0.8), borderRadius: BorderRadius.circular(8)),
                                          child: const Text('Your Follow', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    Positioned(
                                      bottom: 8, left: 8, right: 50,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                          Text('${item.country} • ${item.age}y', style: const TextStyle(color: Colors.amber, fontSize: 11)),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 8, right: 8,
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                item.isFollowed = !item.isFollowed;
                                              });
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(item.isFollowed ? 'Following' : 'Unfollowing'),
                                                  duration: const Duration(seconds: 2),
                                                ),
                                              );
                                            },
                                            child: Icon(
                                              item.isFollowed ? Icons.favorite : Icons.favorite_border,
                                              color: item.isFollowed ? Colors.white : Colors.pinkAccent,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => ZegoVideoCallScreen(streamerName: item.name, streamerId: item.id8Digit),
                                              ),
                                            ),
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.pinkAccent.withOpacity(0.8)),
                                              child: const Icon(Icons.video_call, color: Colors.white, size: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
            // Floating FREE Gift Box
            Positioned(
              bottom: 20, left: 16,
              child: GestureDetector(
                onTap: () => showDialog(context: context, builder: (ctx) => const DailyRewardsDialog()),
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
            // Active draggable PIP overlay if live mini window active
            if (pipActiveStreamer != null)
              DraggableLivePIPWrapper(
                streamer: pipActiveStreamer!,
                onDismissPIP: () => setState(() => pipActiveStreamer = null),
                onExpandFull: () {
                  final s = pipActiveStreamer!;
                  setState(() => pipActiveStreamer = null);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LiveStreamRoomScreen(streamer: s, onDismissPIP: () => Navigator.pop(context)),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

