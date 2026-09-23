import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_controller.dart';
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

  void _validateAndProceed({
    required BuildContext context,
    required String loginType,
    required String identifier,
    String? defaultNameForNewUser,
  }) {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to User Agreement and Privacy Policy first')),
      );
      return;
    }

    final authCtrl = Provider.of<AuthController>(context, listen: false);
    authCtrl.checkExistingAndLogin(
      identifier: identifier,
      loginType: loginType,
      context: context,
      onExistingSuccess: () {
        Navigator.pushReplacementNamed(context, '/main');
      },
      onNewUserNeedsProfile: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OnboardingProfileScreen(
              loginIdentifier: identifier,
              loginType: loginType,
              defaultName: defaultNameForNewUser,
            ),
          ),
        );
      },
    );
  }

  void _showGoogleAccountPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose a Google Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            ListTile(
              leading: const CircleAvatar(backgroundColor: Color(0xFFE94057), child: Text('A')),
              title: const Text('Anitha Live', style: TextStyle(color: Colors.white)),
              subtitle: const Text('anitha.fizz@gmail.com', style: TextStyle(color: Colors.white70)),
              onTap: () {
                Navigator.pop(ctx);
                _validateAndProceed(
                  context: context,
                  loginType: 'google',
                  identifier: 'anitha.fizz@gmail.com',
                  defaultNameForNewUser: 'Anitha Live',
                );
              },
            ),
            ListTile(
              leading: const CircleAvatar(backgroundColor: Color(0xFF8A2387), child: Text('K')),
              title: const Text('Karthik Pro', style: TextStyle(color: Colors.white)),
              subtitle: const Text('karthik.fizz@gmail.com', style: TextStyle(color: Colors.white70)),
              onTap: () {
                Navigator.pop(ctx);
                _validateAndProceed(
                  context: context,
                  loginType: 'google',
                  identifier: 'karthik.fizz@gmail.com',
                  defaultNameForNewUser: 'Karthik Pro',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPhoneOtpDialog(BuildContext context) {
    final phoneCtrl = TextEditingController();
    final otpCtrl = TextEditingController(text: '1234');
    bool otpSent = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C),
          title: Text(otpSent ? 'Enter OTP' : 'Enter Phone Number'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!otpSent)
                TextField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone Number (+91...)'),
                )
              else
                TextField(
                  controller: otpCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'OTP sent (use 1234)'),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE94057)),
              onPressed: () {
                if (!otpSent) {
                  if (phoneCtrl.text.trim().length < 10) return;
                  setDialogState(() => otpSent = true);
                } else {
                  Navigator.pop(ctx);
                  _validateAndProceed(
                    context: context,
                    loginType: 'phone',
                    identifier: phoneCtrl.text.trim(),
                  );
                }
              },
              child: Text(otpSent ? 'Verify OTP' : 'Send OTP'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleGuestLogin(BuildContext context) {
    final randomNum = 100000 + Random().nextInt(900000);
    final guestName = 'user_$randomNum';
    _validateAndProceed(
      context: context,
      loginType: 'guest',
      identifier: 'guest_$randomNum',
      defaultNameForNewUser: guestName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07070F),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _RadarBackgroundPainter())),
            ..._floatingAvatars.map((item) {
              return Positioned(
                top: (item['top'] as int).toDouble(),
                left: item.containsKey('left') ? (item['left'] as int).toDouble() : null,
                right: item.containsKey('right') ? (item['right'] as int).toDouble() : null,
                child: Container(
                  width: (item['size'] as int).toDouble(),
                  height: (item['size'] as int).toDouble(),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: (item['color'] as Color).withOpacity(0.6), width: 2.5),
                  ),
                  child: ClipOval(
                    child: Container(
                      color: (item['color'] as Color).withOpacity(0.2),
                      child: Center(
                        child: Text(
                          (item['name'] as String)[0],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: (item['size'] as int) * 0.35,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
            Positioned(
              top: 310,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFFF416C), Color(0xFFFF4B2B), Color(0xFFE94057)],
                    ).createShader(bounds),
                    child: const Text(
                      'Fizz Live Pro',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.2),
                    ),
                  ),
                  const SizedBox(height: 6),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF00C9FF), Color(0xFF92FE9D), Color(0xFFFF9966)],
                    ).createShader(bounds),
                    child: const Text(
                      'live stream • private call • 18+',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 24,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE94057), Color(0xFFFF6B6B)],
                        ),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        ),
                        onPressed: () {
                          // Fast login checks device/auth session or defaults to quick verification
                          _validateAndProceed(
                            context: context,
                            loginType: 'fast_login',
                            identifier: 'device_primary_token',
                          );
                        },
                        child: const Text(
                          'Fast Login',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: const [
                      Expanded(child: Divider(color: Colors.white24, thickness: 0.8)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: Text('or', style: TextStyle(color: Colors.white54, fontSize: 13)),
                      ),
                      Expanded(child: Divider(color: Colors.white24, thickness: 0.8)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildLoginOptionItem(
                        context,
                        icon: Icons.g_mobiledata,
                        label: 'Google',
                        color: Colors.redAccent,
                        onTap: () => _showGoogleAccountPicker(context),
                      ),
                      _buildLoginOptionItem(
                        context,
                        icon: Icons.phone_android,
                        label: 'Phone',
                        color: Colors.greenAccent,
                        onTap: () => _showPhoneOtpDialog(context),
                      ),
                      _buildLoginOptionItem(
                        context,
                        icon: Icons.person_outline,
                        label: 'Guest',
                        color: Colors.amberAccent,
                        onTap: () => _handleGuestLogin(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          value: _agreedToTerms,
                          activeColor: const Color(0xFFE94057),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          onChanged: (val) {
                            setState(() {
                              _agreedToTerms = val ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _agreedToTerms = !_agreedToTerms;
                          });
                        },
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(fontSize: 12, color: Colors.white70),
                            children: [
                              TextSpan(text: 'Agree to '),
                              TextSpan(
                                text: 'User Agreement',
                                style: TextStyle(color: Color(0xFFE94057), fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(color: Color(0xFFE94057), fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.headphones_outlined, size: 15, color: Colors.white60),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Support help desk opened.')),
                          );
                        },
                        child: const Text(
                          'Having login issues? Find help',
                          style: TextStyle(fontSize: 12, color: Colors.white70, decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginOptionItem(BuildContext context, {required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: () {
        if (!_agreedToTerms) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please agree to User Agreement and Privacy Policy first')),
          );
          return;
        }
        onTap();
      },
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1E1E2C),
              border: Border.all(color: Colors.white12),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
        ],
      ),
    );
  }
}

class _RadarBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    final center = Offset(size.width * 0.5, size.height * 0.42);
    canvas.drawCircle(center, 90, paint);
    canvas.drawCircle(center, 155, paint);
    canvas.drawCircle(center, 220, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
