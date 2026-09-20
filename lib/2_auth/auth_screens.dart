import 'package:flutter/material.dart';
import '../1_core/core_data.dart';
import '../5_dashboard/dashboard_shell.dart';

class AgeGateAndAuthScreen extends StatefulWidget {
  const AgeGateAndAuthScreen({super.key});
  @override
  State<AgeGateAndAuthScreen> createState() => _AgeGateAndAuthScreenState();
}

class _AgeGateAndAuthScreenState extends State<AgeGateAndAuthScreen> {
  bool is18Plus = false;

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: Padding(
        padding: const EdgeInsets.all(24),
        key: const Key('age_gate_body'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.verified_user, size: 70, color: AppTheme.accentAmber),
            const SizedBox(height: 16),
            const Text('18+ Mature Platform', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Confirm you are 18 years or older to enter Fizz Live Pro.', style: TextStyle(color: Colors.white54, fontSize: 13), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            SwitchListTile(
              title: const Text('I confirm I am 18+ years old', style: TextStyle(color: Colors.white)),
              value: is18Plus,
              activeColor: AppTheme.primaryPink,
              onChanged: (val) => setState(() => is18Plus = val),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: is18Plus ? AppTheme.primaryPink : Colors.grey, minimumSize: const Size(double.infinity, 50)),
              onPressed: is18Plus ? () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardShell())) : null,
              child: const Text('Enter App (Fast Login / Guest)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
