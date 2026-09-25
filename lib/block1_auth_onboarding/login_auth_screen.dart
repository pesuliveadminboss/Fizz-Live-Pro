import 'package:flutter/material.dart';
import 'profile_setup_screen.dart';

class GlobalAuthRegistry {
  static final Set<String> registeredIdentifiers = {};
  static String userGender = 'Female';
}

class LoginAuthScreen extends StatefulWidget {
  const LoginAuthScreen({super.key});

  @override
  State<LoginAuthScreen> createState() => _LoginAuthScreenState();
}

class _LoginAuthScreenState extends State<LoginAuthScreen> {
  bool _isAgreementChecked = false;

  void _handleLoginAction(String type, String identifier) {
    if (!_isAgreementChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please click agree to User Agreement and Privacy Policy!')),
      );
      return;
    }

    bool isAlreadyRegistered = GlobalAuthRegistry.registeredIdentifiers.contains(identifier);

    // Fast login or any login for new user must go to profile setup first!
    if (isAlreadyRegistered && type != 'fast') {
      Navigator.pushReplacementNamed(context, '/main_shell');
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileSetupScreen(
            identifier: identifier,
            defaultName: type == 'guest' ? 'Guest 001' : (type == 'google' ? 'Google User' : 'Fast User'),
          ),
        ),
      );
    }
  }

  void _showGooglePicker() {
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
                _handleLoginAction('google', 'streamer.macha@gmail.com');
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
                    _handleLoginAction('phone', phoneController.text);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: SafeArea(
        child: Stack(
          children: [
            // Top floating circular streamer photo bubbles matching Screenshot 2
            Positioned(
              top: 30,
              left: 20,
              child: _circleBubble(Colors.pink, 'A'),
            ),
            Positioned(
              top: 50,
              right: 30,
              child: _circleBubble(Colors.purple, 'B'),
            ),
            Positioned(
              top: 140,
              left: 70,
              child: _circleBubble(Colors.deepOrange, 'C'),
            ),
            Positioned(
              top: 120,
              right: 60,
              child: _circleBubble(Colors.pinkAccent, 'D'),
            ),
            Positioned(
              top: 240,
              left: 40,
              child: _circleBubble(Colors.redAccent, 'E'),
            ),
            Positioned(
              top: 220,
              right: 90,
              child: _circleBubble(Colors.purpleAccent, 'F'),
            ),

            // Bottom login panel matching exact layout requirements
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE94057),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        onPressed: () => _handleLoginAction('fast', 'fast_user_unique_id'),
                        child: const Text('Fast Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('or', style: TextStyle(color: Colors.white54, fontSize: 12)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const CircleAvatar(backgroundColor: Colors.white12, child: Text('G', style: TextStyle(color: Colors.white))),
                          onPressed: _showGooglePicker,
                        ),
                        const SizedBox(width: 25),
                        IconButton(
                          icon: const CircleAvatar(backgroundColor: Colors.white12, child: Icon(Icons.phone, color: Colors.white, size: 18)),
                          onPressed: _showPhoneOtpModal,
                        ),
                        const SizedBox(width: 25),
                        IconButton(
                          icon: const CircleAvatar(backgroundColor: Colors.white12, child: Icon(Icons.person, color: Colors.white, size: 18)),
                          onPressed: () => _handleLoginAction('guest', 'Guest_001'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _isAgreementChecked,
                          activeColor: const Color(0xFFE94057),
                          onChanged: (val) => setState(() => _isAgreementChecked = val ?? false),
                        ),
                        const Text('Agree to User Agreement and Privacy Policy', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('Having login issues? Find help', style: TextStyle(color: Color(0xFFE94057), fontSize: 11, decoration: TextDecoration.underline)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleBubble(Color color, String label) {
    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
        color: Colors.white24,
      ),
      child: Center(
        child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}

