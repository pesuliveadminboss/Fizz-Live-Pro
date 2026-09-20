import 'package:flutter/material.dart';
import '../1_core/core_data.dart';
import '../5_dashboard/dashboard_shell.dart';
import 'user_profile_model.dart';

class AgeGateAndAuthScreen extends StatefulWidget {
  const AgeGateAndAuthScreen({super.key});
  @override
  State<AgeGateAndAuthScreen> createState() => _AgeGateAndAuthScreenState();
}

class _AgeGateAndAuthScreenState extends State<AgeGateAndAuthScreen> {
  bool is18Plus = false;
  String selectedAuthMethod = 'Guest';

  void _proceedToNext() {
    if (!is18Plus) return;
    if (!userProfile.isProfileCompleted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfileSetupScreen()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardShell()));
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.verified_user, size: 70, color: AppTheme.accentAmber),
            const SizedBox(height: 16),
            const Text('FIZZ LIVE PRO — 18+', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Live • Connect • Vibe. Confirm 18+ age to continue.', style: TextStyle(color: Colors.white54, fontSize: 13), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            SwitchListTile(
              title: const Text('I confirm I am 18+ years old & agree to Terms/Privacy', style: TextStyle(color: Colors.white, fontSize: 13)),
              value: is18Plus,
              activeColor: AppTheme.primaryPink,
              onChanged: (val) => setState(() => is18Plus = val),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['Guest', 'Phone OTP', 'Google'].map((m) {
                return ChoiceChip(
                  label: Text(m),
                  selected: selectedAuthMethod == m,
                  onSelected: (_) => setState(() => selectedAuthMethod = m),
                  selectedColor: AppTheme.primaryPink,
                  labelStyle: const TextStyle(color: Colors.white),
                  backgroundColor: AppTheme.cardDark,
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: is18Plus ? AppTheme.primaryPink : Colors.grey, minimumSize: const Size(double.infinity, 50)),
              onPressed: is18Plus ? _proceedToNext : null,
              child: Text('Continue with $selectedAuthMethod', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});
  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final nameCtrl = TextEditingController(text: 'FizzUser_${DateTime.now().second}');
  final dobCtrl = TextEditingController(text: '10/10/2004');
  String gender = 'Female';
  String lang = 'Tamil';

  void _saveProfile() {
    userProfile.username = nameCtrl.text.trim();
    userProfile.dob = dobCtrl.text.trim();
    userProfile.gender = gender;
    userProfile.language = lang;
    userProfile.isProfileCompleted = true;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardShell()));
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(backgroundColor: Colors.black, title: const Text('Profile Onboarding', style: TextStyle(color: Colors.white))),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Center(child: CircleAvatar(radius: 45, backgroundColor: Colors.pinkAccent, child: Icon(Icons.person, size: 50, color: Colors.white))),
            const SizedBox(height: 20),
            TextField(controller: nameCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Username', labelStyle: TextStyle(color: Colors.white54), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)))),
            const SizedBox(height: 16),
            TextField(controller: dobCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Date of Birth (DD/MM/YYYY)', labelStyle: TextStyle(color: Colors.white54), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)))),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: gender,
              dropdownColor: AppTheme.cardDark,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Gender Identity', labelStyle: TextStyle(color: Colors.white54)),
              items: ['Female', 'Male', 'Non-Binary'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: (v) => setState(() => gender = v ?? 'Female'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryPink, minimumSize: const Size(double.infinity, 50)),
              onPressed: _saveProfile,
              child: const Text('Save & Enter Home', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

