import 'package:flutter/material.dart';

class LoginAuthScreen extends StatefulWidget {
  const LoginAuthScreen({super.key});

  @override
  State<LoginAuthScreen> createState() => _LoginAuthScreenState();
}

class _LoginAuthScreenState extends State<LoginAuthScreen> {
  bool _isAgreed = false;

  void _handleLogin(String method) {
    if (!_isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to User Agreement and Privacy Policy first!')),
      );
      return;
    }

    if (method == 'google') {
      _showGoogleAccountPicker();
    } else if (method == 'phone') {
      _showPhoneOtpDialog();
    } else if (method == 'guest') {
      _loginAsGuest();
    } else {
      // Fast Login / Already User Verify
      Navigator.pushReplacementNamed(context, '/main_shell');
    }
  }

  void _showGoogleAccountPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2C),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose Google Account', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.pink, child: Text('S', style: TextStyle(color: Colors.white))),
              title: const Text('streamer.user@gmail.com', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Auto-fill DOB, Gender & Country (18+)', style: TextStyle(color: Colors.white70, fontSize: 11)),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(context, '/profile_setup');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPhoneOtpDialog() {
    final phoneController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        title: const Text('Phone Login / OTP', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: phoneController,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(hintText: 'Enter mobile number', hintStyle: TextStyle(color: Colors.white54)),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE94057)),
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP Sent Successfully!')));
                Navigator.pushNamed(context, '/profile_setup');
              },
              child: const Text('Get OTP & Continue', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _loginAsGuest() {
    // Guest auto-name generation e.g. Guest 001
    Navigator.pushNamed(context, '/profile_setup');
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
                  onPressed: () => _handleLogin('fast'),
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
                    onPressed: () => _handleLogin('google'),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const CircleAvatar(backgroundColor: Colors.white12, child: Icon(Icons.phone, color: Colors.white)),
                    onPressed: () => _handleLogin('phone'),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const CircleAvatar(backgroundColor: Colors.white12, child: Icon(Icons.person, color: Colors.white)),
                    onPressed: () => _handleLogin('guest'),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Checkbox(
                    value: _isAgreed,
                    activeColor: const Color(0xFFE94057),
                    onChanged: (val) => setState(() => _isAgreed = val ?? false),
                  ),
                  const Expanded(
                    child: Text('Agree to User Agreement and Privacy Policy', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ),
                ],
              ),
              const Text('Having login issues? Find help', style: TextStyle(color: Color(0xFFE94057), fontSize: 12, decoration: TextDecoration.underline)),
            ],
          ),
        ),
      ),
    );
  }
}
