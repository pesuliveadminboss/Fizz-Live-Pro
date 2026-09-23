import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- APP STATE ---
class AppState extends ChangeNotifier {
  int _gems = 450;
  String _userName = 'Fizz User';
  String _userHandle = '@fizzuser_101';
  final List<Map<String, dynamic>> _transactions = [
    {'title': 'Recharge 500 Gems', 'date': 'Today, 2:15 PM', 'amount': '+500 Gems', 'isCredit': true},
    {'title': 'Gift sent to Anitha_Live', 'date': 'Yesterday, 10:40 PM', 'amount': '-50 Gems', 'isCredit': false},
  ];
  int get gems => _gems;
  String get userName => _userName;
  String get userHandle => _userHandle;
  List<Map<String, dynamic>> get transactions => _transactions;

  void updateProfile(String name, String handle) {
    _userName = name;
    _userHandle = handle.startsWith('@') ? handle : '@$handle';
    notifyListeners();
  }

  bool sendGift(String receiver, String giftName, int cost) {
    if (_gems >= cost) {
      _gems -= cost;
      _transactions.insert(0, {
        'title': 'Sent $giftName to $receiver',
        'date': 'Just now',
        'amount': '-$cost Gems',
        'isCredit': false,
      });
      notifyListeners();
      return true;
    }
    return false;
  }

  void addRecharge(int amount, String priceLabel) {
    _gems += amount;
    _transactions.insert(0, {
      'title': 'Recharge $amount Gems ($priceLabel)',
      'date': 'Just now',
      'amount': '+$amount Gems',
      'isCredit': true,
    });
    notifyListeners();
  }
}

// --- AUTH & ROLE CONTROLLER ---
class AuthController extends ChangeNotifier {
  bool isLoggedIn = false;
  bool isExistingUser = false;
  bool isStreamer = false; // Female = streamer (Go-Live shown), Male = user (No Go-Live)
  String userName = 'Fizz User';
  String userHandle = '@fizzuser';
  String gender = 'Female';
  String country = 'India';
  String dob = '10/10/2000';
  final Set<String> _registeredUsers = {};

  Future<void> checkExistingAndLogin({
    required String identifier,
    required String loginType,
    required BuildContext context,
    required VoidCallback onNewUserNeedsProfile,
    required VoidCallback onExistingSuccess,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$loginType:$identifier';
    if (_registeredUsers.contains(key) || (prefs.getBool(key) ?? false)) {
      isExistingUser = true;
      isLoggedIn = true;
      notifyListeners();
      onExistingSuccess();
    } else {
      isExistingUser = false;
      onNewUserNeedsProfile();
    }
  }

  void completeNewUserProfile({
    required String name,
    required String selectedGender,
    required String selectedDob,
    required String selectedCountry,
    required String loginIdentifier,
    required String loginType,
  }) async {
    gender = selectedGender;
    isStreamer = (gender.toLowerCase() == 'female');
    userName = name;
    userHandle = '@${name.toLowerCase().replaceAll(' ', '_')}';
    dob = selectedDob;
    country = selectedCountry;
    isLoggedIn = true;
    final key = '$loginType:$loginIdentifier';
    _registeredUsers.add(key);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, true);
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    isExistingUser = false;
    notifyListeners();
  }
}

// --- ONBOARDING PROFILE SCREEN ---
class OnboardingProfileScreen extends StatefulWidget {
  final String loginIdentifier;
  final String loginType;
  final String? defaultName;
  const OnboardingProfileScreen({super.key, required this.loginIdentifier, required this.loginType, this.defaultName});
  @override
  State<OnboardingProfileScreen> createState() => _OnboardingProfileScreenState();
}
class _OnboardingProfileScreenState extends State<OnboardingProfileScreen> {
  late TextEditingController _nameController;
  String _selectedGender = 'Female';
  String _selectedDob = '10/10/2000';
  String _selectedCountry = 'India';
  bool _agreed18Plus = false;
  final List<String> _countries = ['India', 'USA', 'UAE', 'Singapore', 'UK'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.defaultName ?? '');
  }
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(title: const Text('Complete Your Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: CircleAvatar(radius: 46, backgroundColor: Color(0xFFE94057), child: Icon(Icons.camera_alt, size: 32, color: Colors.white)),
            ),
            const SizedBox(height: 24),
            TextField(controller: _nameController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Profile Name', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            const Text('Gender (Women = Streamer/Go-Live, Men = User)', style: TextStyle(color: Colors.white70)),
            Row(
              children: [
                Expanded(child: RadioListTile<String>(title: const Text('Female'), value: 'Female', groupValue: _selectedGender, activeColor: const Color(0xFFE94057), onChanged: (val) => setState(() => _selectedGender = val!))),
                Expanded(child: RadioListTile<String>(title: const Text('Male'), value: 'Male', groupValue: _selectedGender, activeColor: const Color(0xFFE94057), onChanged: (val) => setState(() => _selectedGender = val!))),
              ],
            ),
            TextField(controller: TextEditingController(text: _selectedDob), style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Date of Birth (DD/MM/YYYY)', border: OutlineInputBorder()), onChanged: (val) => _selectedDob = val),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(value: _selectedCountry, dropdownColor: const Color(0xFF1E1E2C), style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Country', border: OutlineInputBorder()), items: _countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(), onChanged: (val) => setState(() => _selectedCountry = val!)),
            const SizedBox(height: 16),
            CheckboxListTile(title: const Text('I confirm I am 18+ years old', style: TextStyle(fontSize: 13)), value: _agreed18Plus, activeColor: const Color(0xFFE94057), onChanged: (val) => setState(() => _agreed18Plus = val ?? false)),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE94057), padding: const EdgeInsets.symmetric(vertical: 14)),
              onPressed: () {
                if (_nameController.text.trim().isEmpty || !_agreed18Plus) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill name and check 18+')));
                  return;
                }
                Provider.of<AuthController>(context, listen: false).completeNewUserProfile(
                  name: _nameController.text.trim(),
                  selectedGender: _selectedGender,
                  selectedDob: _selectedDob,
                  selectedCountry: _selectedCountry,
                  loginIdentifier: widget.loginIdentifier,
                  loginType: widget.loginType,
                );
                Navigator.pushReplacementNamed(context, '/main');
              },
              child: const Text('Save & Enter App'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- LOGIN SCREEN WITH SCREENSHOT UI ---
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
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Choose Google Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ListTile(leading: const CircleAvatar(backgroundColor: Color(0xFFE94057), child: Text('A')), title: const Text('Anitha Live', style: TextStyle(color: Colors.white)), subtitle: const Text('anitha@gmail.com', style: TextStyle(color: Colors.white70)), onTap: () { Navigator.pop(ctx); _validateAndProceed(context: context, loginType: 'google', identifier: 'anitha@gmail.com', defaultNameForNewUser: 'Anitha Live'); }),
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
            ElevatedButton(onPressed: () { if (!otpSent) { setDialogState(() => otpSent = true); } else { Navigator.pop(ctx); _validateAndProceed(context: context, loginType: 'phone', identifier: phoneCtrl.text.trim()); } }, child: Text(otpSent ? 'Verify' : 'Send OTP')),
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

// --- APP SCREENS ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final authCtrl = context.watch<AuthController>();
    return Scaffold(
      appBar: AppBar(title: Text(authCtrl.isStreamer ? 'Fizz Live Pro (Streamer)' : 'Fizz Live Pro (User)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8A2387)),
            icon: const Icon(Icons.mic, color: Colors.white),
            label: const Text('Join Live Voice Party Room 🎙️'),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PartyRoomScreen())),
          ),
          const SizedBox(height: 24),
          const Expanded(child: Center(child: Text('Live feed recommended creators card list'))),
        ]),
      ),
    );
  }
}

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Explore Streams')));
}

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Messages')), body: const Center(child: Text('Chat List')));
}

class LiveStreamScreen extends StatelessWidget {
  const LiveStreamScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Anitha_Live • 💎 ${appState.gems}'), actions: [IconButton(icon: const Icon(Icons.card_giftcard), onPressed: () => appState.sendGift('Anitha_Live', 'Rose', 50))]),
      body: const Center(child: Text('Live Stream View', style: TextStyle(color: Colors.white))),
    );
  }
}

class PartyRoomScreen extends StatelessWidget {
  const PartyRoomScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Voice Party Room')), body: const Center(child: Text('8-Seat Voice Room')));
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Center(child: Text('${appState.userName}\n${appState.userHandle}\nGems: ${appState.gems}')),
    );
  }
}

