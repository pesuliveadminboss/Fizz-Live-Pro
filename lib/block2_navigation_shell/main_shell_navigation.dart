import 'package:flutter/material.dart';

class MainShellNavigation extends StatefulWidget {
  const MainShellNavigation({super.key});

  @override
  State<MainShellNavigation> createState() => _MainShellNavigationState();
}

class _MainShellNavigationState extends State<MainShellNavigation> {
  int _currentIndex = 0;
  bool _isStreamer = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F1A),
        elevation: 0,
        title: const Text(
          'Fizz Live Pro',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.security, color: Colors.cyanAccent),
            onPressed: () {
              // Open auth dialog or settings
            },
          ),
          IconButton(
            icon: const Icon(Icons.card_giftcard, color: Colors.pinkAccent),
            onPressed: () {
              // Open daily rewards
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Selected Tab Index: $_currentIndex',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E1E2C),
        selectedItemColor: const Color(0xFFE94057),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.thumb_up_alt_outlined), label: 'For You'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Follow'),
          BottomNavigationBarItem(icon: Icon(Icons.games_outlined), label: 'Game'),
          BottomNavigationBarItem(icon: Icon(Icons.message_outlined), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Me'),
        ],
      ),
    );
  }
}
