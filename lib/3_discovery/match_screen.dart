import 'package:flutter/material.dart';
import '../4_interactions/call_screen.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> with SingleTickerProviderStateMixin {
  bool isSearching = false;
  String selectedGender = 'Any';
  String selectedMatchMode = 'Video';
  late AnimationController _radarController;

  Map<String, dynamic>? matchedUser;

  final List<Map<String, dynamic>> mockMatches = [
    {'name': 'Pooja', 'age': '23', 'country': 'IN 🇮🇳', 'diamonds': '1.2k', 'tags': ['Friendly', 'Tamil']},
    {'name': 'Ayesha', 'age': '25', 'country': 'AE 🇦🇪', 'diamonds': '3.4k', 'tags': ['Vibe', 'English']},
    {'name': 'Kavya', 'age': '21', 'country': 'IN 🇮🇳', 'diamonds': '890', 'tags': ['Talkative', 'Tamil, Hindi']},
  ];

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _radarController.dispose();
    super.dispose();
  }

  void _startSearching() {
    setState(() {
      isSearching = true;
      matchedUser = null;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          isSearching = false;
          matchedUser = mockMatches[DateTime.now().second % mockMatches.length];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0B1E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Random Match ⚡', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ToggleButtons(
                    isSelected: [selectedMatchMode == 'Video', selectedMatchMode == 'Voice'],
                    onPressed: (idx) {
                      setState(() {
                        selectedMatchMode = idx == 0 ? 'Video' : 'Voice';
                      });
                    },
                    color: const Color(0x99FFFFFF),
                    selectedColor: Colors.white,
                    fillColor: Colors.pinkAccent,
                    borderColor: Colors.white24,
                    selectedBorderColor: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(12),
                    constraints: const BoxConstraints(minHeight: 32, minWidth: 60),
                    children: const [
                      Text('Video', style: TextStyle(fontSize: 12)),
                      Text('Voice', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: ['Any', 'Female', 'Male'].map((g) {
                  final isSelected = selectedGender == g;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(g, style: const TextStyle(fontSize: 11)),
                      selected: isSelected,
                      selectedColor: Colors.pinkAccent,
                      backgroundColor: Colors.white.withOpacity(0.08),
                      labelStyle: TextStyle(color: isSelected ? Colors.white : const Color(0xBFFFFFFF)),
                      onSelected: (_) => setState(() => selectedGender = g),
                    ),
                  );
                }).toList(),
              ),
              const Expanded(
                child: SizedBox.shrink(),
              ),
              Center(
                child: isSearching
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RotationTransition(
                            turns: _radarController,
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.pinkAccent.withOpacity(0.5), width: 2),
                                gradient: RadialGradient(
                                  colors: [Colors.pinkAccent.withOpacity(0.3), Colors.transparent],
                                ),
                              ),
                              child: const Center(
                                child: Icon(Icons.radar, size: 50, color: Colors.pinkAccent),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text('Searching for best match...', style: TextStyle(color: Color(0xBFFFFFFF), fontSize: 13)),
                        ],
                      )
                    : matchedUser != null
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1F1A24),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.pinkAccent, width: 1.5),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CircleAvatar(radius: 40, backgroundColor: Colors.pinkAccent, child: Icon(Icons.person, size: 40, color: Colors.white)),
                                const SizedBox(height: 12),
                                Text(
                                  '${matchedUser!['name']} | ${matchedUser!['age']}y | ${matchedUser!['country']}',
                                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Text('Charm: 💎 ${matchedUser!['diamonds']}', style: const TextStyle(color: Colors.amber, fontSize: 12)),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 6,
                                  alignment: WrapAlignment.center,
                                  children: (matchedUser!['tags'] as List<String>).map((t) => Chip(
                                    label: Text(t, style: const TextStyle(fontSize: 10)),
                                    backgroundColor: Colors.white12,
                                    labelStyle: const TextStyle(color: Colors.white),
                                    visualDensity: VisualDensity.compact,
                                  )).toList(),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                                      icon: const Icon(Icons.videocam, size: 16),
                                      label: Text('Start $selectedMatchMode Call'),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => const CallScreen()));
                                      },
                                    ),
                                    TextButton(
                                      onPressed: _startSearching,
                                      child: const Text('Next', style: TextStyle(color: Color(0x89FFFFFF))),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircleAvatar(
                                radius: 45,
                                backgroundColor: Colors.white12,
                                child: Icon(Icons.shuffle, size: 40, color: Colors.pinkAccent),
                              ),
                              const SizedBox(height: 16),
                              const Text('Ready to match global vibes?', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              const Text('Tap start to find instant partner', style: TextStyle(color: Color(0x89FFFFFF), fontSize: 12)),
                            ],
                          ),
              ),
              const Expanded(
                child: SizedBox.shrink(),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSearching ? Colors.redAccent : Colors.pinkAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: isSearching ? () => setState(() => isSearching = false) : _startSearching,
                  child: Text(
                    isSearching ? 'Cancel Search' : 'Start Matching 🚀',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
