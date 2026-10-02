import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import your main home screen or live screen here if needed
// import '../block5_live_streaming/live_room_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkExistingLogin();
  }

  // Check if the user has already completed profile setup previously
  Future<void> _checkExistingLogin() async {
    final prefs = await SharedPreferences.getInstance();
    bool isProfileCompleted = prefs.getBool('is_profile_completed') ?? false;

    if (isProfileCompleted) {
      if (!mounted) return;
      // If already logged in, directly navigate to Main/Home screen
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (_) => const MainHomeScreen()),
      // );
    }
  }

  // Save profile and mark as completed for new users
  Future<void> _handleLoginAndSaveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your profile name!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_profile_completed', true);
    await prefs.setString('user_name', _nameController.text.trim());

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login & Profile Setup Successful!')),
    );

    // Navigate to Main/Home screen after successful setup
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (_) => const MainHomeScreen()),
    // );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline, size: 80, color: Colors.pinkAccent),
                const SizedBox(height: 20),
                const Text(
                  'Welcome to Live App',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'First-time users please complete your profile setup',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Profile Setup Input Field (Shown only for new users)
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter your profile name...',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: Border.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Fast Login / Save Profile Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: _isLoading ? null : _handleLoginAndSaveProfile,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Fast Login / Continue',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
