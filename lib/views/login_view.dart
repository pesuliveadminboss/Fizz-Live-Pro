import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/user_prefs.dart';
import 'profile_setup_view.dart';
import 'home_feed_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool agreeTerms = false;
  String selectedMethod = 'Phone';

  void _handleLogin() async {
    if (!agreeTerms) {
      Get.snackbar('Agreement Required', 'Please agree to user agreement & privacy policy', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    await UserPrefs.setLoggedIn(true);
    bool profileDone = await UserPrefs.isProfileDone();
    if (profileDone) {
      Get.off(() => const HomeFeedView());
    } else {
      Get.off(() => const ProfileSetupView());
    }
  }

  void _openHelpDialog() {
    Get.defaultDialog(
      title: 'Having Login Issues?',
      backgroundColor: Colors.grey[900],
      titleStyle: const TextStyle(color: Colors.white),
      content: const Text(
        'Contact support@fizzlivepro.com or check your internet connection, OTP spam folder, or try Guest Login.',
        style: TextStyle(color: Colors.white70),
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
        onPressed: () => Get.back(),
        child: const Text('OK', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Fizz Live Pro Login', textAlign: TextAlign.center, style: TextStyle(color: Colors.pinkAccent, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['Phone', 'Gmail', 'Guest'].map((m) => ChoiceChip(
                label: Text(m),
                selected: selectedMethod == m,
                onSelected: (val) => setState(() => selectedMethod = m),
              )).toList(),
            ),
            const SizedBox(height: 20),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: selectedMethod == 'Phone' ? 'Enter Phone Number' : (selectedMethod == 'Gmail' ? 'Enter Gmail' : 'Guest Mode'),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              enabled: selectedMethod != 'Guest',
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(value: agreeTerms, onChanged: (v) => setState(() => agreeTerms = v!)),
                const Expanded(child: Text('I agree to User Agreement & Privacy Policy', style: TextStyle(fontSize: 12, color: Colors.white70))),
              ],
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              icon: const Icon(Icons.headset_mic, color: Colors.pinkAccent, size: 18),
              label: const Text('Having login issues? Find help', style: TextStyle(color: Colors.pinkAccent, fontSize: 13)),
              onPressed: _openHelpDialog,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, padding: const EdgeInsets.symmetric(vertical: 16)),
              onPressed: _handleLogin,
              child: const Text('Continue / Fast Login', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

