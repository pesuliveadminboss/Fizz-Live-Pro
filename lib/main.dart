import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'models.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Splash(),
  ));
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
    return const Scaffold(backgroundColor: Colors.black, body: Center(child: Icon(Icons.live_tv, size: 70, color: Colors.pinkAccent)));
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
              const Text('Admin PIN (7777)', style: TextStyle(color: Colors.white)),
              TextField(controller: _c, obscureText: true, textAlign: TextAlign.center, style: const TextStyle(color: Colors.amber)),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                onPressed: () {
                  if (_c.text.trim() == "7777") {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Login()));
                  }
                },
                child: const Text('Unlock'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Login extends StatelessWidget {
  const Login({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Dashboard())),
          child: const Text('Confirm Login'),
        ),
      ),
    );
  }
}

