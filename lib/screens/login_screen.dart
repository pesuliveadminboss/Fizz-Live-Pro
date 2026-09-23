import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _agreedToTerms = false;

  final List<Map<String, dynamic>> _floatingAvatars = [
    {'name': 'Anitha', 'top': 40, 'left': 40, 'size': 68, 'color': Color(0xFFE94057)},
    {'name': 'Priya', 'top': 60, 'right': 40, 'size': 56, 'color': Color(0xFF8A2387)},
    {'name': 'Kavya', 'top': 190, 'left': 90, 'size': 74, 'color': Color(0xFFF27121)},
    {'name': 'Divya', 'top': 210, 'right': 50, 'size': 70, 'color': Color(0xFFE94057)},
    {'name': 'Meera', 'top': 380, 'left': 50, 'size': 78, 'color': Color(0xFF8A2387)},
    {'name': 'Sneha', 'top': 430, 'right': 70, 'size': 58, 'color': Color(0xFFE94057)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07070F),
      body: SafeArea(
        child: Stack(
          children: [
            // Ambient glowing radar / radial circles background decoration
            Positioned.fill(
              child: CustomPaint(
                painter: _RadarBackgroundPainter(),
              ),
            ),

            // Floating Circular Avatars like screenshot
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
                    boxShadow: [
                      BoxShadow(
                        color: (item['color'] as Color).withOpacity(0.35),
                        blurRadius: 14,
                        spreadRadius: 2,
                      ),
                    ],
                    color: const Color(0xFF1E1E2C),
                  ),
                  child: ClipOval(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Safe fallback avatar color + initial initial letter badge if image fails
                        Container(
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
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),

            // Center / Top Branding: Fizz Live Pro + Colorful gradient subtitle
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
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF00C9FF), Color(0xFF92FE9D), Color(0xFFFF9966)],
                    ).createShader(bounds),
                    child: const Text(
                      'live stream • private call • 18+',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom login panel matching screenshot layout
            Positioned(
              left: 20,
              right: 20,
              bottom: 24,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Fast Login Button (Gradient pink pill)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE94057), Color(0xFFFF6B6B)],
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE94057).withOpacity(0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        ),
                        onPressed: () {
                          if (!_agreedToTerms) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please agree to User Agreement and Privacy Policy first')),
                            );
                            return;
                          }
                          Navigator.pushReplacementNamed(context, '/main');
                        },
                        child: const Text(
                          'Fast Login',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // or divider
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

                  // Google, Phone, Guest circular option icons row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildLoginOptionItem(
                        context,
                        icon: Icons.g_mobiledata,
                        label: 'Google',
                        color: Colors.redAccent,
                      ),
                      _buildLoginOptionItem(
                        context,
                        icon: Icons.phone_android,
                        label: 'Phone',
                        color: Colors.greenAccent,
                      ),
                      _buildLoginOptionItem(
                        context,
                        icon: Icons.person_outline,
                        label: 'Guest',
                        color: Colors.amberAccent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Checkbox + User Agreement and Privacy Policy link text
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

                  // Having login issues find help
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

  Widget _buildLoginOptionItem(BuildContext context, {required IconData icon, required String label, required Color color}) {
    return GestureDetector(
      onTap: () {
        if (!_agreedToTerms) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please agree to User Agreement and Privacy Policy first')),
          );
          return;
        }
        Navigator.pushReplacementNamed(context, '/main');
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

    // Subtle red/pink accent dots on radar lines matching screenshot vibe
    final dotPaint = Paint()
      ..color = const Color(0xFFE94057).withOpacity(0.5)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx + 110, center.dy - 60), 3.5, dotPaint);

    final blueDotPaint = Paint()
      ..color = const Color(0xFF00C9FF).withOpacity(0.5)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx - 120, center.dy + 80), 3, blueDotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
