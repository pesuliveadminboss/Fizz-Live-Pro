import 'package:flutter/material.dart';
import 'match_call_helper.dart';
import 'match_profile_widget.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> with TickerProviderStateMixin {
  bool _isSearching = false;
  bool _isMatched = false;
  bool _isVideoEnabled = true;
  bool _isFollowing = false;

  String _matchedName = 'Priya Ramesh';
  String _matchedAge = '22';
  String _matchedLocation = 'Coimbatore, India';

  late AnimationController _radarController;

  final List<Map<String, String>> _mockUsers = [
    {'name': 'Priya Ramesh', 'age': '22', 'location': 'Coimbatore, India'},
    {'name': 'Karthik Kumar', 'age': '24', 'location': 'Chennai, India'},
    {'name': 'Anitha Sri', 'age': '21', 'location': 'Madurai, India'},
    {'name': 'Raj Shukla', 'age': '25', 'location': 'Bangalore, India'},
  ];

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    MatchCallHelper.initMatchCallEngine();
  }

  @override
  void dispose() {
    _radarController.dispose();
    MatchCallHelper.disposeMatchCall();
    super.dispose();
  }

  void _startRandomMatch() {
    setState(() {
      _isSearching = true;
      _isMatched = false;
    });

    // Simulate finding a random user after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        final randomUser = (_mockUsers..shuffle()).first;
        setState(() {
          _isSearching = false;
          _isMatched = true;
          _matchedName = randomUser['name']!;
          _matchedAge = randomUser['age']!;
          _matchedLocation = randomUser['location']!;
          _isFollowing = false;
        });
      }
    });
  }

  void _nextMatch() {
    _startRandomMatch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F051D),
      body: Stack(
        children: [
          // Background Video/Audio Match View
          Positioned.fill(
            child: _isMatched
                ? MatchCallHelper.buildMatchCameraPreview(isVideoEnabled: _isVideoEnabled)
                : SafeArea(
                    child: Column(
                      children: [
                        // Top Bar
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Random Live Match 🎯',
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Icon(Icons.radar, color: Colors.cyanAccent),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // Radar Animation when searching
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RotationTransition(
                                turns: _radarController,
                                child: Container(
                                  height: 200,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.pinkAccent.withOpacity(0.6), width: 3),
                                    gradient: RadialGradient(
                                      colors: [Colors.pinkAccent.withOpacity(0.3), Colors.transparent],
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.wifi_tethering, size: 70, color: Colors.cyanAccent),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 35),
                              Text(
                                _isSearching ? 'Searching for live partner...' : 'Tap below to start random match',
                                style: const TextStyle(color: Colors.white70, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // Start Match Button
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pinkAccent,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              ),
                              onPressed: _isSearching ? null : _startRandomMatch,
                              child: Text(
                                _isSearching ? 'Finding Match...' : 'Start Random Match 🚀',
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),

          // If Matched, show Profile & Action Buttons on top
          if (_isMatched)
            MatchProfileWidget(
              userName: _matchedName,
              userAge: _matchedAge,
              userLocation: _matchedLocation,
              isFollowing: _isFollowing,
              onToggleFollow: () {
                setState(() {
                  _isFollowing = !_isFollowing;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(_isFollowing ? 'Followed $_matchedName!' : 'Unfollowed'), duration: const Duration(milliseconds: 800)),
                );
              },
              onNextMatch: _nextMatch,
              onOpenChat: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Opening chat with $_matchedName...'), duration: const Duration(seconds: 1)),
                );
              },
            ),
        ],
      ),
    );
  }
}
