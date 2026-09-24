// Replace the IntegratedForYouScreen class inside main.dart with this code:

class IntegratedForYouScreen extends StatefulWidget {
  const IntegratedForYouScreen({super.key});

  @override
  State<IntegratedForYouScreen> createState() => _IntegratedForYouScreenState();
}

class _IntegratedForYouScreenState extends State<IntegratedForYouScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  StreamerCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openLiveRoom(CategoryStreamerItem streamer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveRoomMainScreen(
          streamerName: streamer.name,
          streamerId: streamer.id,
          streamerCountry: streamer.country,
          onClosePressed: () => Navigator.pop(context),
          onProfilePressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Opening Profile for ${streamer.name}')),
            );
          },
          childContent: Stack(
            fit: StackFit.expand,
            children: [
              // Top Synced Heart / Follow Controller
              Positioned(
                top: 90,
                left: 16,
                child: SyncedHeartsAndFollowController(
                  onFollowStateChanged: () {},
                ),
              ),

              // Viewer count & Video call actions
              Positioned(
                top: 90,
                right: 16,
                child: ViewerListAndVideoCallActions(
                  viewersCount: streamer.viewersCount,
                  onViewersListTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.grey[900],
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (ctx) => Container(
                        padding: const EdgeInsets.all(16),
                        height: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Active Viewers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const Divider(color: Colors.white24),
                            Expanded(
                              child: ListView(
                                children: [
                                  ListTile(
                                    leading: const CircleAvatar(backgroundColor: Colors.pinkAccent, child: Text('U1')),
                                    title: const Text('Viewer_Alex'),
                                    subtitle: const Text('@alex_99'),
                                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                                    onTap: () => Navigator.pop(ctx),
                                  ),
                                  ListTile(
                                    leading: const CircleAvatar(backgroundColor: Colors.purpleAccent, child: Text('U2')),
                                    title: const Text('Viewer_Priya'),
                                    subtitle: const Text('@priya_live'),
                                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                                    onTap: () => Navigator.pop(ctx),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  onGiftTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gift sent successfully! 🎁')),
                    );
                  },
                  onVideoCallTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Connecting 1-to-1 Video Call... 📞')),
                    );
                  },
                ),
              ),

              // Live Chat & Warning Banner at bottom left
              const Positioned(
                bottom: 20,
                left: 16,
                right: 16,
                child: LiveChatAndWarningBanner(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allStreamers = LiveStreamFilterManager.getMockCategoryStreamers();
    final displayedStreamers = _selectedCategory == null
        ? allStreamers
        : LiveStreamFilterManager.filterByCategory(allStreamers, _selectedCategory!);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.pinkAccent,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.pinkAccent,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: 'Hot'),
            Tab(text: 'Live'),
            Tab(text: 'Party'),
            Tab(text: 'Match'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. Hot Tab (Contains Pretty, New, Sexy cards & Live Row Grid)
          SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CategoryFilterCardsWidget(
                  selectedCategory: _selectedCategory,
                  onCategorySelected: (category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Live Streamers',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 10),
                LiveRowGridWidget(
                  streamers: displayedStreamers,
                  onStreamerTap: (streamer) {
                    _openLiveRoom(streamer);
                  },
                ),
              ],
            ),
          ),
          // 2. Live Tab
          const Center(child: Text('Live Streamers Feed', style: TextStyle(color: Colors.white70))),
          // 3. Party Tab
          const Center(child: Text('Party Rooms Feed', style: TextStyle(color: Colors.white70))),
          // 4. Match Tab
          const Center(child: Text('Match & Connect Feed', style: TextStyle(color: Colors.white70))),
        ],
      ),
    );
  }
}

