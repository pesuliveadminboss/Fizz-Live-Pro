import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state_and_auth.dart';

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

class ForYouScreen extends StatefulWidget {
  const ForYouScreen({super.key});

  @override
  State<ForYouScreen> createState() => _ForYouScreenState();
}

class _ForYouScreenState extends State<ForYouScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCountry = 'All';
  final List<String> _countries = ['All', 'India', 'America', 'Bangladesh', 'Pakistan', 'Russia', 'Africa', 'Madagascar'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openCountryFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Country 🌎', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _countries.map((c) => ChoiceChip(
                label: Text(c),
                selected: _selectedCountry == c,
                selectedColor: const Color(0xFFE94057),
                onSelected: (val) {
                  setState(() => _selectedCountry = c);
                  Navigator.pop(ctx);
                },
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _openSearchDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        String query = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            final results = kMockStreamers.where((s) => !s.isOffline && s.name.toLowerCase().contains(query.toLowerCase())).toList();
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E2C),
              title: const Text('Search Streamers 🔍'),
              content: SizedBox(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(hintText: 'Type favorite streamer name...'),
                      onChanged: (val) => setModalState(() => query = val),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final item = results[index];
                          return ListTile(
                            leading: CircleAvatar(backgroundColor: item.color, child: Text(item.name[0])),
                            title: Text(item.name),
                            subtitle: Text('${item.flag} ${item.country}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.video_call, color: Color(0xFFE94057)),
                              onPressed: () {
                                Navigator.pop(ctx);
                                showVideoCall1to1Dialog(context, item);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<StreamerItem> getFilteredList(String tabName) {
      return kMockStreamers.where((s) {
        if (s.isOffline) return false;
        if (_selectedCountry != 'All' && s.country != _selectedCountry) return false;
        if (tabName == 'live') return s.status == 'live';
        if (tabName == 'party') return s.status == 'party';
        return true;
      }).toList();
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: const Color(0xFF0F0F1A),
          child: Row(
            children: [
              Expanded(
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: const Color(0xFFE94057),
                  unselectedLabelColor: Colors.white70,
                  indicatorColor: const Color(0xFFE94057),
                  tabs: const [
                    Tab(text: 'Hot'),
                    Tab(text: 'Live'),
                    Tab(text: 'Party'),
                    Tab(text: 'Match'),
                  ],
                ),
              ),
              IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: _openSearchDialog),
              IconButton(icon: const Icon(Icons.public, color: Colors.cyanAccent), onPressed: _openCountryFilter),
            ],
          ),
        ),
        if (_selectedCountry != 'All')
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            color: const Color(0xFF1E1E2C),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filtered by: 🌎 $_selectedCountry', style: const TextStyle(fontSize: 12, color: Colors.cyanAccent)),
                TextButton(
                  onPressed: () => setState(() => _selectedCountry = 'All'),
                  child: const Text('Reset', style: TextStyle(fontSize: 12, color: Colors.white70)),
                ),
              ],
            ),
          ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildStreamerGrid(getFilteredList('hot')),
              _buildStreamerGrid(getFilteredList('live')),
              _buildStreamerGrid(getFilteredList('party')),
              _buildStreamerGrid(getFilteredList('hot')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStreamerGrid(List<StreamerItem> list) {
    if (list.isEmpty) {
      return const Center(child: Text('No active streamers found in this selection'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.78,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final streamer = list[index];
        Color statusBg = Colors.green;
        String statusText = 'Online';
        if (streamer.status == 'live') {
          statusBg = const Color(0xFFE94057);
          statusText = 'Live';
        } else if (streamer.status == 'party') {
          statusBg = Colors.blueAccent;
          statusText = 'Party';
        }

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFF1E1E2C),
            border: Border.all(color: Colors.white12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  color: streamer.color.withOpacity(0.4),
                  child: Center(
                    child: Text(streamer.name[0], style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Col
