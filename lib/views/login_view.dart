import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/fizz_core_controller.dart';
import 'profile_onboarding_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool agreeChecked = true;
  final FizzCoreController core = Get.find<FizzCoreController>();

  final List<Map<String, dynamic>> avatarData = [
    {"top": 60, "left": 40, "size": 65, "img": "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200"},
    {"top": 40, "right": 50, "size": 55, "img": "https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200"},
    {"top": 210, "left": 90, "size": 75, "img": "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200"},
    {"top": 220, "right": 70, "size": 70, "img": "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200"},
    {"top": 450, "left": 50, "size": 75, "img": "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=200"},
    {"top": 440, "right": 90, "size": 55, "img": "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=200"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.2),
                radius: 1.2,
                colors: [Color(0xFF2E134B), Colors.black],
              ),
            ),
          ),
          ...avatarData.map((item) {
            return Positioned(
              top: (item["top"] as int).toDouble(),
              left: item.containsKey("left") ? (item["left"] as int).toDouble() : null,
              right: item.containsKey("right") ? (item["right"] as int).toDouble() : null,
              child: CircleAvatar(
                radius: (item["size"] as int) / 2,
                backgroundImage: NetworkImage(item["img"]),
                backgroundColor: Colors.pinkAccent,
              ),
            );
          }).toList(),
          Positioned(top: 290, left: 240, child: _glowingRing(Colors.pinkAccent, 24)),
          Positioned(top: 590, right: 90, child: _glowingRing(Colors.pinkAccent, 28)),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE91E63),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: Text(
                      "Fast Login",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => _handleAuthAction('fast'),
                  ),
                ),
                SizedBox(height: 18),
                Text("or", style: TextStyle(color: Colors.white54, fontSize: 12)),
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialRoundIcon(Icons.g_mobiledata, "Google", () => _handleAuthAction('google')),
                    SizedBox(width: 35),
                    _socialRoundIcon(Icons.phone_android, "Phone", () => _handleAuthAction('phone')),
                    SizedBox(width: 35),
                    _socialRoundIcon(Icons.person_outline, "Guest", () => _handleAuthAction('guest')),
                  ],
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: Checkbox(
                        value: agreeChecked,
                        activeColor: Color(0xFFE91E63),
                        shape: CircleBorder(),
                        onChanged: (val) {
                          setState(() {
                            agreeChecked = val ?? true;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 6),
                    Text("Agree to ", style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Text("User Agreement", style: TextStyle(color: Color(0xFFE91E63), fontSize: 12, fontWeight: FontWeight.bold)),
                    Text(" and ", style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Text("Privacy Policy", style: TextStyle(color: Color(0xFFE91E63), fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Get.snackbar("Help & Support", "Connecting to live support assistance...", snackPosition: SnackPosition.BOTTOM);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.headphones, color: Colors.amber, size: 16),
                      SizedBox(width: 6),
                      Text("Having login issues ", style: TextStyle(color: Colors.white70, fontSize: 12)),
                      Text("find help", style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _glowingRing(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: color, width: 2)),
    );
  }

  Widget _socialRoundIcon(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          SizedBox(height: 6),
          Text(label, style: TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }

  void _handleAuthAction(String mode) {
    if (!agreeChecked) {
      Get.snackbar("Notice", "Please agree to User Agreement and Privacy Policy first!");
      return;
    }
    // Route to profile onboarding setup flow per your rules
    if (mode == 'google') {
      Get.to(() => ProfileOnboardingView(mode: 'google', initialEmail: 'streamer.fizz@gmail.com'));
    } else {
      Get.to(() => ProfileOnboardingView(mode: mode));
    }
  }
}
