import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core_data.dart';
import 'auth_and_popups.dart';
import 'streamer_profile_screen.dart';

class ForYouScreen extends StatefulWidget {
  const ForYouScreen({super.key});

  @override
  State<ForYouScreen> createState() => _ForYouScreenState();
}

class _ForYouScreenState extends State<ForYouScreen> {
  int _selectedTopIndex = 0;
  final List<String> _topTabs = ['Hot', 'Live', 'Party', 'Match'];
  String _selectedCountry = 'All';
  final List<String> _countries = ['All', 'India', 'America', 'Bangladesh', 'Pakistan', 'Russia', 'Africa', 'Madagascar'];

  void _openCountryFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Country 🌎', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _countries.map((c) => ChoiceChip(
                label: Text(c),
                selected: _selectedCountry == c,
                selectedColor: const Color(0xFFE94057),
                onSelected: (val) {
                  setState(() => _selectedCountry = c);
                  Navigator.pop(ctx);
                },
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _openSearchDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        String query = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            final results = kMockStreamers.where((s) => !s.isOffline && s.name.toLowerCase().contains(query.toLowerCase())).toList();
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E2C),
              title: const Text('Search Streamers 🔍'),
              content: SizedBox(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(hintText: 'Type favorite streamer name...'),
                      onChanged: (val) => setModalState(() => query = val),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final item = results[index];
                          return ListTile(
                            leading: CircleAvatar(backgroundColor: item.color, child: Text(item.name[0])),
                            title: Text(item.name),
                            subtitle: Text('${item.flag} ${item.country}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.video_call, color: Color(0xFFE94057)),
                              onPressed: () {
                                Navigator.pop(ctx);
                                showVideoCall1to1Dialog(context, item);
                              },
                            ),
                            onTap: () {
                              Navigator.pop(ctx);
                              Navigator.push(context, MaterialPageRoute(builder: (_) => StreamerProfileScreen(streamer: item)));
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String tabName = ['hot', 'live', 'party', 'match'][_selectedTopIndex];
    final list = kMockStreamers.where((s) {
      if (s.isOffline) return false;
      if (_selectedCountry != 'All' && s.country != _selectedCountry) return false;
      if (tabName == 'live') return s.status == 'live';
      if (tabName == 'party') return s.status == 'party';
      return true;
    }).toList();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: const Color(0xFF0F0F1A),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: List.generate(_topTabs.length, (index) {
                  final isSelected = _selectedTopIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTopIndex = index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _topTabs[index],
                            style: TextStyle(
                              color: isSelected ? const Color(0xFFE94057) : Colors.white70,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 2,
                            width: isSelected ? 24 : 0,
                            color: const Color(0xFFE94057),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              Row(
                children: [
                  IconButton(icon: const Icon(Icons.search, color: Colors.white, size: 20), onPressed: _openSearchDialog),
                  IconButton(icon: const Icon(Icons.public, color: Colors.cyanAccent, size: 20), onPressed: _openCountryFilter),
                ],
              ),
            ],
          ),
        ),
        if (_selectedCountry != 'All')
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            color: const Color(0xFF1E1E2C),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filtered by: 🌎 $_selectedCountry', style: const TextStyle(fontSize: 12, color: Colors.cyanAccent)),
                TextButton(
                  onPressed: () => setState(() => _selectedCountry = 'All'),
                  child: const Text('Reset', style: TextStyle(fontSize: 12, color: Colors.white70)),
                ),
              ],
            ),
          ),
        Expanded(child: _buildStreamerGrid(list)),
      ],
    );
  }

  Widget _buildStreamerGrid(List<StreamerItem> list) {
    if (list.isEmpty) {
      return const Center(child: Text('No active streamers found in this selection'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.78,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final streamer = list[index];
        Color statusBg = Colors.green;
        String statusText = 'Online';
        if (streamer.status == 'live') {
          statusBg = const Color(0xFFE94057);
          statusText = 'Live';
        } else if (streamer.status == 'party') {
          statusBg = Colors.blueAccent;
          statusText = 'Party';
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => StreamerProfileScreen(streamer: streamer)),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFF1E1E2C),
              border: Border.all(color: Colors.white12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: streamer.color.withOpacity(0.4),
                    child: Center(
                      child: Text(streamer.name[0], style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white24)),
                    ),
                  ),
                  Positioned(
                    top: 8, left: 8,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(10)),
                          child: Text(statusText, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                        const SizedBox(width: 4),
                        Text(streamer.flag, style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
                          begin: Alignment.topCenter, end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(streamer.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
                                Text('${streamer.country} • ${streamer.age}', style: const TextStyle(color: Colors.white70, fontSize: 10)),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => showVideoCall1to1Dialog(context, streamer),
                            child: Container(
                              width: 34, height: 34,
                              decoration: const BoxDecoration(color: Color(0xFFE94057), shape: BoxShape.circle),
                              child: const Icon(Icons.videocam, color: Colors.white, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class FollowScreen extends StatelessWidget {
  const FollowScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Followed Creators')));
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Interactive Live Games 🎮')));
}

class HomeScreenContainer extends StatefulWidget {
  const HomeScreenContainer({super.key});
  @override
  State<HomeScreenContainer> createState() => _HomeScreenContainerState();
}

class _HomeScreenContainerState extends State<HomeScreenContainer> {
  bool _popupsTriggered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_popupsTriggered) {
      _popupsTriggered = true;
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) EntryPopupsHelper.showDailyRewardsDialog(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) => const ForYouScreen();
}

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Messages')), body: const Center(child: Text('Chat List')));
}

class LiveStreamScreen extends StatelessWidget {
  const LiveStreamScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Go Live (Streamer) • 💎 ${appState.gems}'), actions: [IconButton(icon: const Icon(Icons.card_giftcard), onPressed: () => appState.sendGift('Anitha_Live', 'Rose', 50))]),
      body: const Center(child: Text('Live Stream Broadcaster View', style: TextStyle(color: Colors.white))),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Center(child: Text('${appState.userName}\n${appState.userHandle}\nGems: ${appState.gems}')),
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => AuthController()),
      ],
      child: const FizzLiveProApp(),
    ),
  );
}

class FizzLiveProApp extends StatelessWidget {
  const FizzLiveProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fizz Live Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFE94057),
        scaffoldBackgroundColor: const Color(0xFF0F0F1A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE94057),
          secondary: Color(0xFF8A2387),
          surface: Color(0xFF1E1E2C),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/main': (_) => const MainShell(),
      },
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authCtrl = context.watch<AuthController>();
    final isStreamer = authCtrl.isStreamer;

    final List<Widget> maleScreens = [
      const HomeScreenContainer(),
      const FollowScreen(),
      const GameScreen(),
      const ChatListScreen(),
      const ProfileScreen(),
    ];

    final List<Widget> femaleScreens = [
      const HomeScreenContainer(),
      const FollowScreen(),
      const LiveStreamScreen(),
      const GameScreen(),
      const ChatListScreen(),
      const ProfileScreen(),
    ];

    final currentScreen = isStreamer
        ? femaleScreens[_currentIndex < femaleScreens.length ? _currentIndex : 0]
        : maleScreens[_currentIndex < maleScreens.length ? _currentIndex : 0];

    final items = isStreamer
        ? const [
            BottomNavigationBarItem(icon: Icon(Icons.thumb_up_alt_outlined), label: 'For You'),
            BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Follow'),
            BottomNavigationBarItem(icon: Icon(Icons.videocam_rounded), label: 'Go live'),
            BottomNavigationBarItem(icon: Icon(Icons.games_outlined), label: 'Game'),
            BottomNavigationBarItem(icon: Icon(Icons.message_outlined), label: 'Messages'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Me'),
          ]
        : const [
            BottomNavigationBarItem(icon: Icon(Icons.thumb_up_alt_outlined), label: 'For You'),
            BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Follow'),
            BottomNavigationBarItem(icon: Icon(Icons.games_outlined), label: 'Game'),
            BottomNavigationBarItem(icon: Icon(Icons.message_outlined), label: 'Messages'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Me'),
          ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fizz Live Pro', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.security, color: Colors.cyanAccent),
            tooltip: 'Auth Settings',
            onPressed: () => EntryPopupsHelper.showAuthorizationSettingsDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_active, color: Colors.amberAccent),
            tooltip: 'Call Reminder',
            onPressed: () => EntryPopupsHelper.showCallReminderDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.card_giftcard, color: Colors.pinkAccent),
            tooltip: 'Daily Rewards',
            onPressed: () => EntryPopupsHelper.showDailyRewardsDialog(context),
          ),
        ],
      ),
      body: currentScreen,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E1E2C),
        selectedItemColor: const Color(0xFFE94057),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex >= items.length ? 0 : _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: items,
      ),
    );
  }
}
