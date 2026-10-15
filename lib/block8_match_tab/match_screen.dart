import 'package:flutter/material.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> with TickerProviderStateMixin {
  bool _isSearching = false;
  bool _isMatched = false;
  String _matchedUserName = '';

  late AnimationController _radarController;

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _radarController.dispose();
    super.dispose();
  }

  void _startRandomMatch() {
    setState(() {
      _isSearching = true;
      _isMatched = false;
    });

    // Simulate finding a match after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _isMatched = true;
          _matchedUserName = 'Priya Ramesh (Live Match)';
        });
      }
    });
  }

  void _resetMatch() {
    setState(() {
      _isMatched = false;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F051D),
      body: SafeArea(
        child: Column(
          children: [
            // Top Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Random Match 🎯',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.radar, color: Colors.cyanAccent),
                ],
              ),
            ),
            const Expanded(child: SizedBox()),

            // Center Radar / Match Area
            Center(
              child: _isMatched
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.pinkAccent,
                          child: Icon(Icons.person, size: 70, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _matchedUserName,
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Connected Successfully! 🎉',
                          style: TextStyle(color: Colors.cyanAccent, fontSize: 13),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                              onPressed: _resetMatch,
                              icon: const Icon(Icons.close, color: Colors.white),
                              label: const Text('Next Match', style: TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Starting chat with matched user...')),
                                );
                              },
                              icon: const Icon(Icons.chat, color: Colors.white),
                              label: const Text('Chat', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RotationTransition(
                          turns: _radarController,
                          child: Container(
                            height: 180,
                            width: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.pinkAccent.withOpacity(0.6), width: 3),
                              gradient: RadialGradient(
                                colors: [Colors.pinkAccent.withOpacity(0.2), Colors.transparent],
                              ),
                            ),
                            child: const Center(
                              child: Icon(Icons.wifi_tethering, size: 60, color: Colors.cyanAccent),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          _isSearching ? 'Searching for random partner...' : 'Tap below to find live match',
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
            ),
            const Expanded(child: SizedBox()),

            // Bottom Action Button
            if (!_isMatched)
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
    );
  }
}
