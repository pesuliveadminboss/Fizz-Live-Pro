import 'package:flutter/material.dart';

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
    Future.delayed(const Duration(milliseconds: 2000), () {
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
          children: const [
            Icon(Icons.videocam_rounded, size: 70, color: Color(0xFFFF2E93)),
            SizedBox(height: 16),
            Text(
              'FIZZ LIVE PRO',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                color: Color(0xFFFFD700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// 2. Secret Admin Gateway Screen
// -------------------------------------------------------------
class AdminGatewayScreen extends StatefulWidget {
  const AdminGatewayScreen({super.key});

  @override
  State<AdminGatewayScreen> createState() => _AdminGatewayScreenState();
}

class _AdminGatewayScreenState extends State<AdminGatewayScreen> {
  final TextEditingController _pinController = TextEditingController();
  final String _masterPin = "7777";
  String _errorText = "";

  void _verifyPin() {
    if (_pinController.text.trim() == _masterPin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      setState(() {
        _errorText = "Invalid PIN! Access Denied.";
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
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.admin_panel_settings_rounded, size: 60, color: Color(0xFFFFD700)),
                  const SizedBox(height: 16),
                  const Text(
                    'Admin Verification',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Enter secret PIN to proceed',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _pinController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    maxLength: 4,
                    style: const TextStyle(color: Color(0xFFFFD700), fontSize: 26, letterSpacing: 12),
                    decoration: InputDecoration(
                      counterText: "",
                      filled: true,
                      fillColor: const Color(0xFF14141E),
                      hintText: "••••",
                      hintStyle: const TextStyle(color: Colors.grey, letterSpacing: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  if (_errorText.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(_errorText, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _verifyPin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD700),
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Unlock App', style: TextStyle(fontWeight: FontWeight.bold)),
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
// 3. Login Screen
// -------------------------------------------------------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _agreed = true;

  void _proceed() {
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to Terms & Privacy Policy')),
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthorizationScreen()),
    );
  }

  Widget _buildAvatar(String url, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white24, width: 2),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildSocialBtn(IconData icon, String label) {
    return InkWell(
      onTap: _proceed,
      child: Column(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFF1E1E28),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF07070A),
      body: Stack(
        children: [
          Positioned(top: h * 0.08, left: 24, child: _buildAvatar("https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200", 70)),
          Positioned(top: h * 0.06, right: 36, child: _buildAvatar("https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200", 60)),
          Positioned(top: h * 0.22, left: w * 0.35, child: _buildAvatar("https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200", 90)),
          Positioned(top: h * 0.20, right: 20, child: _buildAvatar("https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200", 75)),
          Positioned(top: h * 0.40, left: 30, child: _buildAvatar("https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200", 80)),
          Positioned(top: h * 0.38, right: w * 0.25, child: _buildAvatar("https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=200", 65)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              color: const Color(0xFF07070A).withOpacity(0.95),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _proceed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF2E93),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: const Text('Fast Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSocialBtn(Icons.g_mobiledata_rounded, "Google"),
                      _buildSocialBtn(Icons.phone_android_rounded, "Phone"),
                      _buildSocialBtn(Icons.person_rounded, "Guest"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _agreed,
                        activeColor: const Color(0xFFFF2E93),
                        onChanged: (val) => setState(() => _agreed = val ?? true),
                      ),
                      const Text('Agree to User Agreement & Privacy Policy', style: TextStyle(color: Colors.grey, fontSize: 11)),
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
}

// -------------------------------------------------------------
// 4. Authorization Screen
// -------------------------------------------------------------
class AuthorizationScreen extends StatelessWidget {
  const AuthorizationScreen({super.key});

  Widget _buildItem(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF14141E),
            child: Icon(icon, color: const Color(0xFFFFD700)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07070A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Authorization Settings',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text(
                'Allow required permissions for seamless live video call experience.',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 28),
              _buildItem(Icons.videocam_rounded, 'Camera', 'Required for live video broadcasting and 1-on-1 calls.'),
              _buildItem(Icons.mic_rounded, 'Microphone', 'Required for real-time audio voice talk.'),
              _buildItem(Icons.phone_in_talk_rounded, 'Phone', 'Manages calls when carrier calls arrive.'),
              _buildItem(Icons.notifications_active_rounded, 'Notification', 'Instant alerts for invitations and messages.'),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const CallReminderScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E5FF),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('Allow all permissions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// 5. Call Reminder Screen
// -------------------------------------------------------------
class CallReminderScreen extends StatelessWidget {
  const CallReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07070A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.ring_volume_rounded, color: Color(0xFFFF2E93), size: 60),
              const SizedBox(height: 20),
              const Text(
                'Never Miss a Call',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text(
                'Enable notifications to receive instant video calls and messages from hosts.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainDashboardScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF2E93),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('Turn on notifications', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainDashboardScreen()),
                  );
                },
                child: const Text('Maybe later', style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// புள்ளி 5 முதல் 20: பிரதான டேஷ்போர்டு & ஹோஸ்ட் கார்டுகள்
// -------------------------------------------------------------
class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _tabIndex = 0;
  int _categoryIndex = 0;
  int _subFilterIndex = 0;

  final List<String> _topCategories = ['Hot', 'Live', 'Party', 'Match'];
  final List<String> _subFilters = ['All', 'Exotic', 'Pretty', 'New', 'Sexy', 'Young'];

  // மாதிரி ஹோஸ்ட்கள் தரவு (புள்ளி 16-20)
  final List<Map<String, dynamic>> _hosts = [
    {
      'name': 'Pooja Sharma',
      'id': 'ID: 78921',
      'age': '22',
      'country': 'India',
      'level': 'LV7',
      'status': 'Live',
      'isFree': true,
      'image': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500',
    },
    {
      'name': 'Ananya Roy',
      'id': 'ID: 65412',
      'age': '24',
      'country': 'India',
      'level': 'LV6',
      'status': 'Busy',
      'isFree': false,
      'image': 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=500',
    },
    {
      'name': 'Sneha Patel',
      'id': 'ID: 99421',
      'age': '21',
      'country': 'India',
      'level': 'LV8',
      'status': 'Active',
      'isFree': true,
      'image': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=500',
    },
    {
      'name': 'Kavya Nair',
      'id': 'ID: 33109',
      'age': '23',
      'country': 'India',
      'level': 'LV5',
      'status': 'Live',
      'isFree': false,
      'image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500',
    },
  ];

  Color _getStatusColor(String status) {
    if (status == 'Live') return Colors.greenAccent;
    if (status == 'Busy') return Colors.redAccent;
    return const Color(0xFF00E5FF); // Active
  }

  Widget _buildHostCard(Map<String, dynamic> host) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF14141E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // ஹோஸ்ட் புகைப்படம்
            Positioned.fill(
              child: Image.network(
                host['image'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF222230),
                  child: const Icon(Icons.person, color: Colors.grey, size: 50),
                ),
              ),
            ),
            // நிழல் பகுதி (Gradient Overlay)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.85),
                    ],
                  ),
                ),
              ),
            ),
            // மேல் பகுதி: நிலை (Status) & இலவச டேக் (FREE Tag)
            Positioned(
              top: 8,
              left: 8,
              right: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Live / Active / Busy பேட்ஜ்
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _getStatusColor(host['status']), width: 1.2),
                    ),
        
