import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core_data.dart';

class EntryPopupsHelper {
  static void showDailyRewardsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        title: const Text('Daily Rewards'),
        content: const Text('Claim your daily bonus gems!'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Provider.of<AppState>(context, listen: false).claimDailyReward();
              Navigator.pop(ctx);
            },
            child: const Text('Claim'),
          ),
        ],
      ),
    );
  }

  static void showAuthorizationSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        title: const Text('Authorization Settings'),
        content: const Text('Camera, Mic, and Notifications are enabled.'),
        actions: [
          ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }

  static void showCallReminderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        title: const Text('Call Reminder'),
        content: const Text('Call reminder notifications are active.'),
        actions: [
          ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }
}

void showVideoCall1to1Dialog(BuildContext context, StreamerItem streamer) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.black,
      title: Text('Video Call with ${streamer.name}'),
      content: const Text('Connecting ZegoCloud Secure Stream...'),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => Navigator.pop(ctx),
          child: const Text('End Call'),
        ),
      ],
    ),
  );
}

class OnboardingProfileScreen extends StatefulWidget {
  final String loginIdentifier;
  final String loginType;
  final String? defaultName;
  const OnboardingProfileScreen({super.key, required this.loginIdentifier, required this.loginType, this.defaultName});

  @override
  State<OnboardingProfileScreen> createState() => OnboardingProfileScreenState();
}

class OnboardingProfileScreenState extends State<OnboardingProfileScreen> {
  late TextEditingController _nameController;
  final TextEditingController _dobController = TextEditingController(text: '10/10/2000');
  String _selectedGender = 'Female';
  String _selectedCountry = 'India';
  bool _agreed18Plus = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.defaultName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('I am 18+ years old'),
              value: _agreed18Plus,
              onChanged: (val) => setState(() => _agreed18Plus = val ?? false),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Provider.of<AuthController>(context, listen: false).completeNewUserProfile(
                  name: _nameController.text.trim(),
                  selectedGender: _selectedGender,
                  selectedDob: _dobController.text.trim(),
                  selectedCountry: _selectedCountry,
                  loginIdentifier: widget.loginIdentifier,
                  loginType: widget.loginType,
                );
                Navigator.pushReplacementNamed(context, '/main');
              },
              child: const Text('Save & Enter'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _agreedToTerms = false;

  void _validateAndProceed(BuildContext context, String loginType, String identifier, String? defaultName) {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please agree to terms first')));
      return;
    }
    Provider.of<AuthController>(context, listen: false).checkExistingAndLogin(
      identifier: identifier,
      loginType: loginType,
      context: context,
      onExistingSuccess: () => Navigator.pushReplacementNamed(context, '/main'),
      onNewUserNeedsProfile: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OnboardingProfileScreen(loginIdentifier: identifier, loginType: loginType, defaultName: defaultName))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Fizz Live Pro', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _validateAndProceed(context, 'fast_login', 'fast_token', 'Fizz User'),
                child: const Text('Fast Login'),
              ),
              CheckboxListTile(
                title: const Text('Agree to Terms & Privacy Policy', style: TextStyle(fontSize: 12)),
                value: _agreedToTerms,
                onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
