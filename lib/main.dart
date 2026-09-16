import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Splash()));
}

class Splash extends StatefulWidget {
  const Splash({super.key});
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PinGate()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: Text('FIZZ LIVE PRO', style: TextStyle(color: Colors.amber, fontSize: 22, fontWeight: FontWeight.bold))),
    );
  }
}

class PinGate extends StatefulWidget {
  const PinGate({super.key});
  @override
  State<PinGate> createState() => _PinGateState();
}

class _PinGateState extends State<PinGate> {
  final _c = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Admin PIN (7777)', style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 10),
              TextField(controller: _c, keyboardType: TextInputType.number, obscureText: true, textAlign: TextAlign.center, style: const TextStyle(color: Colors.amber, fontSize: 22), decoration: const InputDecoration(filled: true, fillColor: Colors.grey, hintText: "••••")),
              const SizedBox(height: 10),
              ElevatedButton(onPressed: () { if (_c.text.trim() == "7777") Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Dashboard())); }, child: const Text('Unlock')),
            ],
          ),
        ),
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _gems = 1670;
  String _userName = 'User7789';
  String _userBio = 'VIP Member';

  final _hosts = const [
    {'name': 'Pooja', 'pic': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200'},
    {'name': 'Ananya', 'pic': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200'},
  ];

  void _editProfile() {
    final nameCtrl = TextEditingController(text: _userName);
    final bioCtrl = TextEditingController(text: _userBio);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: bioCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Bio')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _userName = nameCtrl.text;
                _userBio = bioCtrl.text;
              });
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Fizz Live Pro'),
          actions: [TextButton(onPressed: () => setState(() => _gems += 4050), child: Text('💎 $_gems', style: const TextStyle(color: Colors.amber)))],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.favorite)),
              Tab(icon: Icon(Icons.person)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(10),
              children: [
                for (var h in _hosts)
                  Card(
                    color: Colors.grey[900],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(radius: 28, backgroundImage: NetworkImage(h['pic']!)),
                        const SizedBox(height: 6),
                        Text(h['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        ElevatedButton(onPressed: () => setState(() => _gems -= 100), child: const Text('Call')),
                      ],
                    ),
                  ),
              ],
            ),
            const Center(child: Text('No Favorites yet!', style: TextStyle(color: Colors.grey))),
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(radius: 30, child: Icon(Icons.person)),
                      const SizedBox(height: 6),
                      Text(_userName, style: const TextStyle(color: Colors.white, fontSize: 16)),
                      Text(_userBio, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                      const SizedBox(height: 6),
                      const Text('👑 VIP Lv.5', style: TextStyle(color: Colors.amber)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _editProfile,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                  child: const Text('Edit Profile'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

