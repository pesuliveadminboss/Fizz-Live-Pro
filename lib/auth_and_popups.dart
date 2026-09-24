import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

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
            {'day': 7, 'label': 'x 1 (🎁 200)', 'icon': Icons.card_giftcard, 'color': Colors.pinkAccent},
          ];
          return Dialog(
            backgroundColor: const Color(0xFF1E1E2C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Daily rewards', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                          SizedBox(height: 2),
                          Text('Sign in for 7 days to get a surprise', style: TextStyle(fontSize: 11, color: Colors.white70)),
                        ],
                      ),
                      IconButton(icon: const Icon(Icons.close, color: Colors.white70, size: 20), onPressed: () => Navigator.pop(ctx)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 0.82,
                    ),
                    itemCount: dayRewards.length,
                    itemBuilder: (context, index) {
                      final item = dayRewards[index];
                      final dayNum = item['day'] as int;
                      final isSelected = dayNum == appState.currentStreakDay;
                      return Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFE94057).withOpacity(0.25) : const Color(0xFF151522),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: isSelected ? const Color(0xFFE94057) : Colors.white10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('day $dayNum', style: const TextStyle(fontSize: 9, color: Colors.white60)),
                            const Spacer(),
                            Icon(item['icon'] as IconData, size: 20, color: item['color'] as Color),
                            const Spacer(),
                            Text(item['label'] as String, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity, height: 44,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFE94057), Color(0xFFFF8E53)]),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                        onPressed: () {
                          appState.claimDailyReward();
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Daily reward claimed successfully! 🎁')));
                        },
                        child: Text(appState.claimedToday ? 'Claimed Today ✓' : 'Check-in', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
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
              width: double.infinity, height: 48,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFE94057), Color(0xFFFF6B8B)]),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All permissions allowed (Camera, Phone, Mic, Notification) ✓')));
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
      decoration: BoxDecoration(color: const Color(0xFF151522), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white10)),
      child: Row(children: [Icon(icon, color: color, size: 20), const SizedBox(width: 14), Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500))]),
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
              Container(
                width: double.infinity, padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFE94057), Color(0xFFFF416C)]), borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    const CircleAvatar(radius: 28, backgroundColor: Colors.green, child: Icon(Icons.phone, color: Colors.white, size: 28)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Users call reminder', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        Switch(value: callReminderOn, activeColor: Colors.white, activeTrackColor: Colors.green, onChanged: (val) => setStateModal(() => callReminderOn = val)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('Turn on the call reminder and don\'t miss any call from users', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.white70)),
              const SizedBox(height: 20),
              const Row(children: [Icon(Icons.star_outline, color: Colors.amberAccent, size: 20), SizedBox(width: 10), Text('Received evaluation', style: TextStyle(color: Colors.white, fontSize: 14))]),
              const SizedBox(height: 14),
              const Row(children: [Icon(Icons.notifications_active_outlined, color: Colors.pinkAccent, size: 20), SizedBox(width: 10), Text('New message', style: TextStyle(color: Colors.white, fontSize: 14))]),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 48,
                child: DecoratedBox(
                  decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFE94057), Color(0xFFFF6B8B)]), borderRadius: BorderRadius.circular(24)),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                    onPressed: () { Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notifications & Call reminder turned on! 🔔'))); },
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

void showVideoCall1to1Dialog(BuildContext context, StreamerItem streamer) {
  showDialog(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.black,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: streamer.color.withOpacity(0.3),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 50, backgroundColor: streamer.color, child: Text(streamer.name[0], style: const TextStyle(fontSize: 40, color: Colors.white))),
                  const SizedBox(height: 16),
                  Text('1-to-1 Video Call with ${streamer.name}', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('${streamer.flag} ${streamer.country} • Age ${streamer.age}', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 24),
                  const Text('Connecting secure ZegoCloud channel...', style: TextStyle(color: Colors.greenAccent, fontSize: 12)),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 40, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Video call ended')));
                  },
                  child: const Icon(Icons.call_end, color: Colors.white),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40, right: 20,
            child: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(ctx)),
          ),
        ],
      ),
    ),
  );
}

class OnboardingProfileScreen extends StatefulWidget {
  final String loginIdentifier;
  final String loginType;
  final String? defaultName;
  const OnboardingProfileScreen({super.key, required this.loginIdentifier, required this.loginType, this.defaultName});
  @override
  State<OnboardingProfileScreen> createState() => OnboardingProfileScreenState();
}

class OnboardingProfileScreenState extends State<OnboardingProfileScreen> {
  late TextEditingController _nameController;
  final TextEditingController _dobController = TextEditingController(text: '10/10/2000');
  String _selectedGender = 'Female';
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
    _dobController.dispose();
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
            const Center(child: CircleAvatar(radius: 46, backgroundColor: Color(0xFFE94057), child: Icon(Icons.camera_alt, size: 32, color: Colors.white))),
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
            const SizedBox(height: 16),
            TextField(controller: _dobController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Date of Birth (DD/MM/YYYY)', border: OutlineInputBorder())),
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
                  selectedDob: _dobController.text.trim(),
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
 
