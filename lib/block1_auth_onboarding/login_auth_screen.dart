import 'package:flutter/material.dart';

class LoginAuthScreen extends StatefulWidget {
  const LoginAuthScreen({super.key});

  @override
  State<LoginAuthScreen> createState() => _LoginAuthScreenState();
}

class _LoginAuthScreenState extends State<LoginAuthScreen> {
  bool _agreedToTerms = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top glowing background avatar circles simulation (matching screenshot 10)
              Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMiniAvatar(Colors.pinkAccent, 'A'),
                      _buildMiniAvatar(Colors.purpleAccent, 'B'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMiniAvatar(Colors.cyanAccent, 'C'),
                    ],
                  ),
                ],
              ),

              // Bottom Login Controls matching Screenshot 10
              Column(
                children: [
                  // Fast Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE94057),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        // Proceed to profile setup or main shell
                        Navigator.pushReplacementNamed(context, '/profile_setup');
                      },
                      child: const Text(
                        'Fast Login',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('or', style: TextStyle(color: Colors.white54, fontSize: 14)),
                  const SizedBox(height: 16),

                  // Google, Phone, Guest Login Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialIcon(Icons.g_mobiledata, 'Google', () {}),
                      const SizedBox(width: 30),
                      _buildSocialIcon(Icons.phone, 'Phone', () {}),
                      const SizedBox(width: 30),
                      _buildSocialIcon(Icons.person, 'Guest', () {}),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Agreement Checkbox & Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _agreedToTerms,
                        activeColor: const Color(0xFFE94057),
                        onChanged: (val) {
                          setState(() {
                            _agreedToTerms = val ?? true;
                          });
                        },
                      ),
                      const Text(
                        'Agree to User Agreement and Privacy Policy',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Having login issues find help
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Help & Support: Contact admin support.')),
                      );
                    },
                    child: const Text(
                      'Having login issues? Find help',
                      style: TextStyle(
                        color: Colors.pinkAccent,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniAvatar(Color color, String text) {
    return CircleAvatar(
      radius: 32,
      backgroundColor: color.withOpacity(0.3),
      child: CircleAvatar(
        radius: 28,
        backgroundColor: Colors.grey[800],
        child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF1E1E2C),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
        ],
      ),
    );
  }
}

