import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FizzLiveProApp());
}

class FizzLiveProApp extends StatelessWidget {
  const FizzLiveProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fizz Live Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF07070A),
        primaryColor: const Color(0xFFFFD700),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFD700),
          secondary: Color(0xFF00E5FF),
          surface: Color(0xFF141419),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// -------------------------------------------------------------
// 1. Splash Screen
// -------------------------------------------------------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminGatewayScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07070A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFF2E93), width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF2E93).withOpacity(0.35),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Icon(Icons.videocam_rounded, size: 52, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              'FIZZ',
              style: GoogleFonts.montserrat(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
                color: Colors.white,
              ),
            ),
            Text(
              'LIVE PRO',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 8,
                color: const Color(0xFFFFD700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// 2. Secret Admin Gateway
// -------------------------------------------------------------
class AdminGatewayScreen extends StatefulWidget {
  const AdminGatewayScreen({super.key});

  @override
  State<AdminGatewayScreen> createState() => _AdminGatewayScreenState();
}

class _AdminGatewayScreenState extends State<AdminGatewayScreen> {
  final TextEditingController _pinController = TextEditingController();
  final String _masterPin = "7777";
  String _errorMessage = "";

  void _verifyPin() {
    if (_pinController.text.trim() == _masterPin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      setState(() {
        _errorMessage = "Invalid PIN! Access Denied.";
      });
      _pinController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07070A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.admin_panel_settings_rounded, size: 60, color: Color(0xFFFFD700)),
                  const SizedBox(height: 16),
                  Text(
                    'Admin Verification',
                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Enter secret Admin PIN to proceed',
                    style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 28),
                  TextField(
                    controller: _pinController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    maxLength: 4,
                    style: const TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: 26,
                      letterSpacing: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      filled: true,
                      fillColor: const Color(0xFF14141E),
                      hintText: "••••",
                      hintStyle: TextStyle(color: Colors.grey[600], fontSize: 24, letterSpacing: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF262635)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFFFD700), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_errorMessage.isNotEmpty)
                    Text(_errorMessage, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _verifyPin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD700),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Unlock App',
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// 3. Login Screen (Matching Screenshots)
// -------------------------------------------------------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _agreedToPolicy = true;

  void _proceedToNext() {
    if (!_agreedToPolicy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to User Agreement & Privacy Policy'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login Success! Proceeding to Permissions screen.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF07070A),
      body: Stack(
        children: [
          // Floating Host Bubbles
          Positioned(
            top: size.height * 0.08,
            left: 20,
            child: _buildHostAvatar("https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200", 75),
          ),
          Positioned(
            top: size.height * 0.05,
            right: 40,
            child: _buildHostAvatar("https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200", 65),
          ),
          Positioned(
            top: size.height * 0.22,
            left: size.width * 0.32,
            child: _buildHostAvatar("https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200", 95),
          ),
          Positioned(
            top: size.height * 0.20,
            right: 20,
            child: _buildHostAvatar("https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200", 80),
          ),
          Positioned(
            top: size.height * 0.42,
            left: 25,
            child: _buildHostAvatar("https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200", 85),
          ),
          Positioned(
            top: size.height * 0.40,
            right: size.width * 0.25,
            child: _buildHostAvatar("https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=200", 65),
          ),

          // Neon Accent Ring
          Positioned(
            top: size.height * 0.56,
            right: 45,
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFF2E93), width: 2),
              ),
            ),
          ),

          // Bottom Login Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF07070A).withOpacity(0.95),
                    const Color(0xFF07070A),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Fast Login Button
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFBA28A9), Color(0xFFFF2E93)],
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: _proceedToNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      child: Text(
                        'Fast Login',
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Container(height: 1, color: Colors.white12)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text('or', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                      ),
                      Expanded(child: Container(height: 1, color: Colors.white12)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Social Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSocialOption(Icons.g_mobiledata_rounded, "Google", _proceedToNext),
                      _buildSocialOption(Icons.phone_android_rounded, "Phone", _proceedToNext),
                      _buildSocialOption(Icons.person_rounded, "Guest", _proceedToNext),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Policy Agreement
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _agreedToPolicy = !_agreedToPolicy),
                        child: Icon(
                          _agreedToPolicy ? Icons.check_circle : Icons.radio_button_unchecked,
                          size: 18,
                          color: _agreedToPolicy ? const Color(0xFFFF2E93) : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: 'Agree to ',
                            style: const TextStyle(color: Colors.grey, fontSize: 11),
                            children: [
                              TextSpan(
                                text: 'User Agreement ',
                                style: const TextStyle(color: Color(0xFFFF2E93), fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(text: 'and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: const TextStyle(color: Color(0xFFFF2E93), fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Help Option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.headset_mic_rounded, size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        'Having login issues? Find help',
                        style: TextStyle(color: Colors.grey[400], fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHostAvatar(String imgUrl, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white24, width: 2),
        image: DecorationImage(image: NetworkImage(imgUrl), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildSocialOption(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1E1E28),
              border: Border.all(color: Colors.white12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }
}
