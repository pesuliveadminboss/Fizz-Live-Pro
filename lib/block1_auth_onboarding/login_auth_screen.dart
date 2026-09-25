import 'package:flutter/material.dart';
import 'profile_setup_screen.dart';

class LoginAuthScreen extends StatefulWidget {
  const LoginAuthScreen({super.key});

  @override
  State<LoginAuthScreen> createState() => _LoginAuthScreenState();
}

class _LoginAuthScreenState extends State<LoginAuthScreen> {
  bool _isAgreementChecked = false;

  void _handleLoginAttempt(String method) {
    if (!_isAgreementChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please click agree to User Agreement and Privacy Policy!')),
      );
      return;
    }

    if (method == 'fast') {
      Navigator.pushReplacementNamed(context, '/main_shell');
    } else if (method == 'google') {
      _showGoogleAccountPicker();
    } else if (method == 'phone') {
      _showPhoneOtpModal();
    } else if (method == 'guest') {
      _loginAsGuestUser();
    }
  }

  void _showGoogleAccountPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose Google Email ID', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.pinkAccent, child: Text('G', style: TextStyle(color: Colors.white))),
              title: const Text('streamer.macha@gmail.com', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Auto-fills Name, DOB, Gender & Country (18+)', style: TextStyle(color: Colors.white70, fontSize: 11)),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileSetupScreen(defaultName: 'Google User')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPhoneOtpModal() {
    final phoneController = TextEditingController();
    final otpController = TextEditingController();
    bool otpSent = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C),
          title: Text(otpSent ? 'Enter OTP Code' : 'Phone Number Login', style: const TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!otpSent)
                TextField(
                  controller: phoneController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(hintText: 'Enter Mobile Number', hintStyle: TextStyle(color: Colors.white54)),
                )
              else
                TextField(
                  controller: otpController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Enter 4-digit OTP', hintStyle: TextStyle(color: Colors.white54)),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE94057)),
                onPressed: () {
                  if (!otpSent) {
                    if (phoneController.text.isNotEmpty) {
                      setDialogState(() => otpSent = true);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP sent to mobile!')));
                    }
                  } else {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileSetupScreen(defaultName: 'Phone User')),
                    );
                  }
                },
                child: Text(otpSent ? 'Verify OTP & Enter' : 'Get OTP', style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loginAsGuestUser() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileSetupScreen(defaultName: 'Guest 001')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Fizz Live Pro 18+', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE94057),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  onPressed: () => _handleLoginAttempt('fast'),
                  child: const Text('Fast Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
              const Text('or', style: TextStyle(color: Colors.white54)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const CircleAvatar(backgroundColor: Colors.white12, child: Text('G', style: TextStyle(color: Colors.white))),
                    onPressed: () => _handleLoginAttempt('google'),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const CircleAvatar(backgroundColor: Colors.white12, child: Icon(Icons.phone, color: Colors.white)),
                    onPressed: () => _handleLoginAttempt('phone'),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const CircleAvatar(backgroundColor: Colors.white12, child: Icon(Icons.person, color: Colors.white)),
                    onPressed: () => _handleLoginAttempt('guest'),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Checkbox(
                    value: _isAgreementChecked,
                    activeColor: const Color(0xFFE94057),
                    onChanged: (val) => setState(() => _isAgreementChecked = val ?? false),
                  ),
                  const Expanded(
                    child: Text('Agree to User Agreement and Privacy Policy', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text('Having login issues? Find help', style: TextStyle(color: Color(0xFFE94057), fontSize: 12, decoration: TextDecoration.underline)),
            ],
          ),
        ),
      ),
    );
  }
}

