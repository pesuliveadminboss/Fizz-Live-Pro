import 'dart:async';
import 'package:flutter/material.dart';
import '../1_core/core_data.dart';
import '../5_dashboard/dashboard_shell.dart';
import 'user_profile_model.dart';
import 'legal_sheet.dart';

class SplashLoginScreen extends StatefulWidget {
  const SplashLoginScreen({super.key});
  @override
  State<SplashLoginScreen> createState() => _SplashLoginScreenState();
}

class _SplashLoginScreenState extends State<SplashLoginScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CustomLoginBubbleScreen()));
      }
    });
  }

  @override
  Widget build(context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.live_tv, size: 75, color: Colors.pinkAccent),
            SizedBox(height: 14),
            Text('FIZZ LIVE PRO', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.amber, letterSpacing: 1.5)),
            SizedBox(height: 6),
            Text('Live Stream • 18+ Mature Vibe', style: TextStyle(fontSize: 12, color: Colors.white54)),
          ],
        ),
      ),
    );
  }
}

class CustomLoginBubbleScreen extends StatefulWidget {
  const CustomLoginBubbleScreen({super.key});
  @override
  State<CustomLoginBubbleScreen> createState() => _CustomLoginBubbleScreenState();
}

class _CustomLoginBubbleScreenState extends State<CustomLoginBubbleScreen> {
  bool agreedToPolicy = false;

  final List<Map<String, dynamic>> _bubbles = const [
    {'img': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200', 'top': 60, 'left': 30, 'size': 75},
    {'img': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200', 'top': 50, 'right': 40, 'size': 68},
    {'img': 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200', 'top': 210, 'left': 45, 'size': 90},
    {'img': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?top=225', 'top': 225, 'right': 35, 'size': 85},
    {'img': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200', 'top': 380, 'left': 120, 'size': 80},
  ];

  void _handleFastLogin() {
    if (!agreedToPolicy) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please agree to User Agreement and Privacy Policy first!')));
      return;
    }
    _navigateBasedOnProfile();
  }

  void _navigateBasedOnProfile() {
    if (!userProfile.isProfileCompleted) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileSetupScreen(isNewUser: true)));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardShell()));
    }
  }

  void _openLoginBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardDark,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Login to Fizz Live Pro', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.g_mobiledata, color: Colors.amber, size: 36),
              title: const Text('Continue with Gmail', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Auto-fill name, DOB & gender from Google', style: TextStyle(color: Colors.white54, fontSize: 11)),
              onTap: () {
                Navigator.pop(ctx);
                userProfile.username = 'GoogleUser_Live';
                userProfile.gender = 'Female';
                userProfile.dob = '12/05/2001';
                _navigateBasedOnProfile();
              },
            ),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.pinkAccent),
              title: const Text('Continue with Phone OTP', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Verify mobile number with OTP', style: TextStyle(color: Colors.white54, fontSize: 11)),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PhoneOtpScreen()));
              },
            ),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.person_outline, color: Colors.white70),
              title: const Text('Guest Mode', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
                _navigateBasedOnProfile();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0713),
      body: Stack(
        children: [
          ..._bubbles.map((b) => Positioned(
            top: (b['top'] as num).toDouble(),
            left: b.containsKey('left') ? (b['left'] as num).toDouble() : null,
            right: b.containsKey('right') ? (b['right'] as num).toDouble() : null,
            child: Container(
              width: (b['size'] as num).toDouble(),
              height: (b['size'] as num).toDouble(),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                image: DecorationImage(image: NetworkImage(b['img'] as String), fit: BoxFit.cover),
              ),
            ),
          )),
          Positioned(
            bottom: 30, left: 24, right: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: _handleFastLogin,
                  child: Container(
                    width: double.infinity, height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.purpleAccent]),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    alignment: Alignment.center,
                    child: const Text('Fast Login', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already a member? ', style: TextStyle(color: Colors.white54, fontSize: 13)),
                    GestureDetector(
                      onTap: _openLoginBottomSheet,
                      child: const Text('Login', style: TextStyle(color: Colors.pinkAccent, fontSize: 13, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: agreedToPolicy,
                      activeColor: Colors.pinkAccent,
                      onChanged: (v) => setState(() => agreedToPolicy = v ?? false),
                    ),
                    Expanded(
                      child: Wrap(
                        children: [
                          const Text('Agree to ', style: TextStyle(color: Colors.white70, fontSize: 11)),
                          GestureDetector(
                            onTap: () => showLegalModal(context, 'User Agreement', userAgreementText),
                            child: const Text('User Agreement', style: TextStyle(color: Colors.pinkAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                          const Text(' and ', style: TextStyle(color: Colors.white70, fontSize: 11)),
                          GestureDetector(
                            onTap: () => showLegalModal(context, 'Privacy Policy', privacyPolicyText),
                            child: const Text('Privacy Policy', style: TextStyle(color: Colors.pinkAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.headset_mic, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Support helpline: support@fizzlivepro.com')));
                      },
                      child: const Text('Having login issues? Find help', style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PhoneOtpScreen extends StatefulWidget {
  const PhoneOtpScreen({super.key});
  @override
  State<PhoneOtpScreen> createState() => _PhoneOtpScreenState();
}

class _PhoneOtpScreenState extends State<PhoneOtpScreen> {
  final phoneCtrl = TextEditingController();
  final otpCtrl = TextEditingController();
  bool otpSent = false;

  void _verifyOtp() {
    userProfile.username = 'PhoneUser_${DateTime.now().second}';
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => userProfile.isProfileCompleted ? const DashboardShell() : const ProfileSetupScreen(isNewUser: true)),
      (_) => false,
    );
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(backgroundColor: Colors.black, title: const Text('Phone OTP Login', style: TextStyle(color: Colors.white))),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Enter Mobile Number (+91...)', labelStyle: TextStyle(color: Colors.white54))),
            const SizedBox(height: 16),
            if (otpSent) ...[
              TextField(controller: otpCtrl, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Enter OTP (Tip: enter any 6 digits for instant test)', labelStyle: TextStyle(color: Colors.white54))),
              const SizedBox(height: 24),
              ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryPink), onPressed: _verifyOtp, child: const Text('Verify & Continue')),
            ] else ...[
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryPink), 
                onPressed: () {
                  setState(() => otpSent = true);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mock OTP generated: Use any 6 digits (e.g. 123456) to verify.')));
                }, 
                child: const Text('Generate OTP'),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class ProfileSetupScreen extends StatefulWidget {
  final bool isNewUser;
  final String? initialEmailName;
  const ProfileSetupScreen({super.key, this.isNewUser = true, this.initialEmailName});
  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final nameCtrl = TextEditingController();
  final dobCtrl = TextEditingController(text: '10/10/2004');
  String gender = 'Female';
  String currentAvatar = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200';
  bool is18PlusConfirmed = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialEmailName != null && widget.initialEmailName!.isNotEmpty) {
      nameCtrl.text = widget.initialEmailName!;
    } else {
      nameCtrl.text = UserProfileData.generateNextDefaultUsername();
    }
    currentAvatar = UserProfileData.getDefaultAvatarForGender(gender);
  }

  void _onGenderChanged(String? newGender) {
    setState(() {
      gender = newGender ?? 'Female';
      currentAvatar = UserProfileData.getDefaultAvatarForGender(gender);
    });
  }

  void _pickPhotoOption() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardDark,
      builder: (ctx) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt, color: Colors.pinkAccent),
            title: const Text('Take Photo via Camera', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(ctx);
              setState(() {
                currentAvatar = 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200';
              });
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Camera photo captured & applied!')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: Colors.amber),
            title: const Text('Upload from Gallery', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(ctx);
              setState(() {
                currentAvatar = 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200';
              });
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gallery photo uploaded & applied!')));
            },
          ),
        ],
      ),
    );
  }

  void _saveProfile() {
    final finalName = nameCtrl.text.trim().isEmpty ? UserProfileData.generateNextDefaultUsername() : nameCtrl.text.trim();
    userProfile.username = finalName;
    userProfile.dob = dobCtrl.text.trim();
    userProfile.gender = gender;
    userProfile.avatarUrl = currentAvatar;
    userProfile.isProfileCompleted = true;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardShell()));
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(backgroundColor: Colors.black, title: const Text('Complete Profile (18+)', style: TextStyle(color: Colors.white))),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickPhotoOption,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.pinkAccent,
                      backgroundImage: NetworkImage(currentAvatar),
                    ),
                    Positioned(
                      bottom: 0, right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, size: 16, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Center(child: Text('Tap avatar to change via Camera / Gallery', style: TextStyle(color: Colors.white54, fontSize: 11, height: 2))),
            const SizedBox(height: 16),
            TextField(controller: nameCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Username (Auto-generated or custom)', labelStyle: TextStyle(color: Colors.white54), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)))),
            const SizedBox(height: 16),
            TextField(controller: dobCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Date of Birth (DD/MM/YYYY)', labelStyle: TextStyle(color: Colors.white54), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)))),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: gender,
              dropdownColor: AppTheme.cardDark,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Gender Identity (Auto sets default avatar)', labelStyle: TextStyle(color: Colors.white54)),
              items: ['Female', 'Male', 'Non-Binary'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: _onGenderChanged,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('I confirm I am 18+ years old', style: TextStyle(color: Colors.white, fontSize: 13)),
              value: is18PlusConfirmed,
              activeColor: AppTheme.primaryPink,
              onChanged: (val) => setState(() => is18PlusConfirmed = val),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryPink, minimumSize: const Size(double.infinity, 50)),
              onPressed: _saveProfile,
              child: const Text('Save & Enter App', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

