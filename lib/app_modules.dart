import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- APP STATE ---
class AppState extends ChangeNotifier {
  int _gems = 450;
  int _currentStreakDay = 1;
  bool _claimedToday = false;
  
  String _userName = 'Fizz User';
  String _userHandle = '@fizzuser_101';
  final List<Map<String, dynamic>> _transactions = [
    {'title': 'Recharge 500 Gems', 'date': 'Today, 2:15 PM', 'amount': '+500 Gems', 'isCredit': true},
    {'title': 'Gift sent to Anitha_Live', 'date': 'Yesterday, 10:40 PM', 'amount': '-50 Gems', 'isCredit': false},
  ];
  int get gems => _gems;
  int get currentStreakDay => _currentStreakDay;
  bool get claimedToday => _claimedToday;
  String get userName => _userName;
  String get userHandle => _userHandle;
  List<Map<String, dynamic>> get transactions => _transactions;

  void claimDailyReward() {
    if (_claimedToday) return;
    int rewardGems = 0;
    if (_currentStreakDay == 1) rewardGems = 40;
    else if (_currentStreakDay == 2) rewardGems = 0; // Card reward handled separately or bonus gems
    else if (_currentStreakDay == 3) rewardGems = 50;
    else if (_currentStreakDay == 4) rewardGems = 90;
    else if (_currentStreakDay == 5) rewardGems = 120;
    else if (_currentStreakDay == 6) rewardGems = 180;
    else if (_currentStreakDay == 7) rewardGems = 200; // Gift box 200 gems as per screenshot screenshot 1 rule

    if (_currentStreakDay == 2) {
      _transactions.insert(0, {'title': 'Daily Reward Day 2 (Surprise Card 🃏)', 'date': 'Today', 'amount': '+1 Card', 'isCredit': true});
    } else {
      _gems += rewardGems;
      _transactions.insert(0, {'title': 'Daily Reward Day $_currentStreakDay', 'date': 'Today', 'amount': '+$rewardGems Gems', 'isCredit': true});
    }

    _claimedToday = true;
    if (_currentStreakDay < 7) {
      _currentStreakDay++;
    } else {
      _currentStreakDay = 1; // cycle reset or keep completed
    }
    notifyListeners();
  }

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

// --- POPUPDIALOG HELPER FOR ENTRY FLOW ---
class EntryPopupsHelper {
  static void showDailyRewardsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Consumer<AppState>(
        builder: (context, appState, child) {
          final dayRewards = [
            {'day': 1, 'label': 'x 40', 'icon': Icons.diamond, 'color': Colors.amberAccent},
            {'day': 2, 'label': 'x 1', 'icon': Icons.credit_card, 'color': Colors.orangeAccent},
            {'day': 3, 'label': 'x 50', 'icon': Icons.diamond, 'color': Colors.amberAccent},
            {'day': 4, 'label': 'x 90', 'icon': Icons.diamond, 'color': Colors.amberAccent},
            {'day': 5, 'label': 'x 120', 'icon': Icons.diamond, 'color': Colors.amberAccent},
            {'day': 6, 'label': 'x 180', 'icon': Icons.diamond, 'color': Colors.amberAccent},
            {'day': 7, 'label': 'x 1 (🎁)', 'icon': Icons.card_giftcard, 'color': Colors.pinkAccent},
          ];

          return Dialog(
            backgroundColor: const Color(0xFF1E1E2C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Daily rewards', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                          SizedBox(height: 4),
                          Text('Sign in for 7 days to get a surprise', style: TextStyle(fontSize: 12, color: Colors.white70)),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: dayRewards.length,
                    itemBuilder: (context, index) {
                      final item = dayRewards[index];
                      final dayNum = item['day'] as int;
                      final isSelected = dayNum == appState.currentStreakDay;
                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFE94057).withOpacity(0.25) : const Color(0xFF151522),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isSelected ? const Color(0xFFE94057) : Colors.white10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('day $dayNum', style: const TextStyle(fontSize: 10, color: Colors.white60)),
                            const Spacer(),
                            Icon(item['icon'] as IconData, size: 24, color: item['color'] as Color),
                            const Spacer(),
                            Text(item['label'] as String, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFE94057), Color(0xFFFF8E53)]),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                        onPressed: () {
                          appState.claimDailyReward();
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Daily reward claimed successfully! 🎁')),
                          );
                        },
                        child: Text(
                          appState.claimedToday ? 'Claimed Today ✓' : 'Check-in',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static void showAuthorizationSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(icon: const Icon(Icons.close, color: Colors.white54, size: 20), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const Text('Authorization Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            const Text('Please open authorization setting for better experience', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.white70)),
            const SizedBox(height: 20),
            _buildAuthItem(Icons.camera_alt_outlined, 'Camera', Colors.pinkAccent),
            const SizedBox(height: 10),
            _buildAuthItem(Icons.phone_outlined, 'Phone', Colors.orangeAccent),
            const SizedBox(height: 10),
            _buildAuthItem(Icons.mic_none, 'Microphone', Colors.redAccent),
            const SizedBox(height: 10),
            _buildAuthItem(Icons.notifications_none, 'Notification', Colors.purpleAccent),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFE94057), Color(0xFFFF6B8B)]),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All permissions allowed (Camera, Phone, Mic, Notification) ✓')),
                    );
                  },
                  child: const Text('Allow all', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildAuthItem(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF151522),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 14),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  static void showCallReminderDialog(BuildContext context) {
    bool callReminderOn = true;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateModal) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top banner representation matching screenshot 3 phone icon badge
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFE94057), Color(0xFFFF416C)]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const CircleAvatar(radius: 28, backgroundColor: Colors.green, child: Icon(Icons.phone, color: Colors.white, size: 28)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Users call reminder', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        Switch(
                          value: callReminderOn,
                          activeColor: Colors.white,
                          activeTrackColor: Colors.green,
                          onChanged: (val) => setStateModal(() => callReminderOn = val),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('Turn on the call reminder and don\'t miss any call from users', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.white70)),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.star_outline, color: Colors.amberAccent, size: 20),
                  const SizedBox(width: 10),
                  const Text('Received evaluation', style: TextStyle(color: Colors.white, fontSize: 14)),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(Icons.notifications_active_outlined, color: Colors.pinkAccent, size: 20),
                  const SizedBox(width: 10),
                  const Text('New message', style: TextStyle(color: Colors.white, fontSize: 14)),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFE94057), Color(0xFFFF6B8B)]),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Notifications & Call reminder turned on! 🔔')),
                      );
                    },
                    child: const Text('Turn on notifications', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
            TextField(controller: TextEditingCont
