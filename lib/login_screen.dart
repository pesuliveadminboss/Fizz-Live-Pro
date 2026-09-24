import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_controller.dart';
import 'onboarding_profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _agreedToTerms = false;
  final List<Map<String, dynamic>> _floatingAvatars = [
    {'name': 'Anitha', 'top': 40, 'left': 40, 'size': 68, 'color': const Color(0xFFE94057)},
    {'name': 'Priya', 'top': 60, 'right': 40, 'size': 56, 'color': const Color(0xFF8A2387)},
    {'name': 'Kavya', 'top': 190, 'left': 90, 'size': 74, 'color': const Color(0xFFF27121)},
    {'name': 'Divya', 'top': 210, 'right': 50, 'size': 70, 'color': const Color(0xFFE94057)},
    {'name': 'Meera', 'top': 380, 'left': 50, 'size': 78, 'color': const Color(0xFF8A2387)},
    {'name': 'Sneha', 'top': 430, 'right': 70, 'size': 58, 'color': const Color(0xFFE94057)},
  ];

  void _validateAndProceed({required BuildContext context, required String loginType, required String identifier, String? defaultNameForNewUser}) {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please agree to User Agreement and Privacy Policy first')));
      return;
    }
    Provider.of<AuthController>(context, listen: false).checkExistingAndLogin(
      identifier: identifier,
      loginType: loginType,
      context: context,
      onExistingSuccess: () => Navigator.pushReplacementNamed(context, '/main'),
      onNewUserNeedsProfile: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OnboardingProfileScreen(loginIdentifier: identifier, loginType: loginType, defaultName: defaultNameForNewUser))),
    );
  }

  void _showGoogleAccountPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Choose Google Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          ListTile(
            leading: const CircleAvatar(backgroundColor: Color(0xFFE94057), child: Text('A')),
            title: const Text('Anitha Live', style: TextStyle(color: Colors.white)),
            subtitle: const Text('anitha@gmail.com', style: TextStyle(color: Colors.white70)),
            onTap: () {
              Navigator.pop(ctx);
              _validateAndProceed(context: context, loginType: 'google', identifier: 'anitha@gmail.com', defaultNameForNewUser: 'Anitha Live');
            },
          ),
        ]),
      ),
    );
  }

  void _showPhoneOtpDialog(BuildContext context) {
    final phoneCtrl = TextEditingController();
    bool otpSent = false;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C),
          title: Text(otpSent ? 'Enter OTP (1234)' : 'Enter Phone Number'),
          content: TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone')),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (!otpSent) {
                  setDialogState(() => otpSent = true);
                } else {
                  Navigator.pop(ctx);
                  _validateAndProceed(context: context, loginType: 'phone', identifier: phoneCtrl.text.trim());
                }
              },
              child: Text(otpSent ? 'Verify' : 'Send OTP'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleGuestLogin(BuildContext context) {
    final randomNum = 100000 + Random().nextInt(900000);
    _validateAndProceed(context: context, loginType: 'guest', identifier: 'guest_$randomNum', defaultNameForNewUser: 'user_$randomNum');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07070F),
      body: SafeArea(
        child: Stack(
          children: [
            ..._floatingAvatars.map((item) {
              return Positioned(
                top: (item['top'] as int).toDouble(),
                left: item.containsKey('left') ? (item['left'] as int).toDouble() : null,
                right: item.containsKey('right') ? (item['right'] as int).toDouble() : null,
                child: Container(
                  width: (item['size'] as int).toDouble(),
                  height: (item['size'] as int).toDouble(),
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: (item['color'] as Color).withOpacity(0.6), width: 2.5), color: const Color(0xFF1E1E2C)),
                  child: Center(child: Text((item['name'] as String)[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                ),
              );
            }),
            Positioned(
              top: 310, left: 0, right: 0,
              child: Column(
                children: [
                  const Text('Fizz Live Pro', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white)),
                  const SizedBox(height: 6),
                  const Text('live stream • private call • 18+', style: TextStyle(fontSize: 13, color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Positioned(
              left: 20, right: 20, bottom: 24,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE94057)), onPressed: () => _validateAndProceed(context: context, loginType: 'fast_login', identifier: 'fast_token'), child: const Text('Fast Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
                  const SizedBox(height: 18),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    IconButton(icon: const Icon(Icons.g_mobiledata, color: Colors.redAccent, size: 32), onPressed: () => _showGoogleAccountPicker(context)),
                    IconButton(icon: const Icon(Icons.phone_android, color: Colors.greenAccent, size: 28), onPressed: () => _showPhoneOtpDialog(context)),
                    IconButton(icon: const Icon(Icons.person_outline, color: Colors.amberAccent, size: 28), onPressed: () => _handleGuestLogin(context)),
                  ]),
                  const SizedBox(height: 18),
                  CheckboxListTile(
                    title: RichText(text: const TextSpan(style: TextStyle(fontSize: 12, color: Colors.white70), children: [TextSpan(text: 'Agree to '), TextSpan(text: 'User Agreement', style: TextStyle(color: Color(0xFFE94057), fontWeight: FontWeight.bold)), TextSpan(text: ' and '), TextSpan(text: 'Privacy Policy', style: TextStyle(color: Color(0xFFE94057), fontWeight: FontWeight.bold))])),
                    value: _agreedToTerms,
                    activeColor: const Color(0xFFE94057),
                    onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
                  ),
                  const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.headphones_outlined, size: 15, color: Colors.white60), SizedBox(width: 6), Text('Having login issues? Find help', style: TextStyle(fontSize: 12, color: Colors.white70, decoration: TextDecoration.underline))]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
