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

class CallScreen extends StatefulWidget {
  final String host, pic;
  final int gems;
  final Function(int) onGems;
  const CallScreen({super.key, required this.host, required this.pic, required this.gems, required this.onGems});
  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  int _sec = 0;
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _sec++);
      if (_sec > 0 && _sec % 60 == 0) {
        if (widget.gems >= 1800) {
          widget.onGems(widget.gems - 1800);
        } else {
          Navigator.pop(context);
        }
      }
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 40, backgroundImage: NetworkImage(widget.pic)),
            const SizedBox(height: 10),
            Text(widget.host, style: const TextStyle(color: Colors.white, fontSize: 18)),
            Text('${_sec ~/ 60}:${(_sec % 60).toString().padLeft(2, '0')}', style: const TextStyle(color: Colors.greenAccent, fontSize: 16)),
            const SizedBox(height: 20),
            IconButton(icon: const Icon(Icons.call_end, color: Colors.red, size: 40), onPressed: () => Navigator.pop(context)),
          ],
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
  final _hosts = const [
    {'name': 'Pooja', 'pic': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200'},
    {'name': 'Ananya', 'pic': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200'},
  ];

  void _dial(String name, String pic) {
    if (_gems >= 1800) {
      setState(() => _gems -= 1800);
      Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen(host: name, pic: pic, gems: _gems, onGems: (g) => setState(() => _gems = g))));
    } else {
      setState(() => _gems += 4050);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Fizz Live Pro'),
        actions: [TextButton(onPressed: () => setState(() => _gems += 4050), child: Text('💎 $_gems', style: const TextStyle(color: Colors.amber)))],
      ),
      body: GridView.count(
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
                  ElevatedButton(onPressed: () => _dial(h['name']!, h['pic']!), child: const Text('Call')),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
