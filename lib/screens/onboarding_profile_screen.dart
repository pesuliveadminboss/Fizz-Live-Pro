import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../services/auth_controller.dart';

class OnboardingProfileScreen extends StatefulWidget {
  const OnboardingProfileScreen({
    super.key,
    required this.loginIdentifier,
    required this.loginType,
    this.defaultName,
  });

  final String loginIdentifier;
  final String loginType;
  final String? defaultName;

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
            // Profile photo placeholder
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 46,
                    backgroundColor: Color(0xFFE94057),
                    child: Icon(Icons.camera_alt, size: 32, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Profile Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Gender (Women = Streamer/Go-Live, Men = User)', style: TextStyle(color: Colors.white70)),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Female'),
                    value: 'Female',
                    groupValue: _selectedGender,
                    activeColor: const Color(0xFFE94057),
                    onChanged: (val) => setState(() => _selectedGender = val!),
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Male'),
                    value: 'Male',
                    groupValue: _selectedGender,
                    activeColor: const Color(0xFFE94057),
                    onChanged: (val) => setState(() => _selectedGender = val!),
                  ),
                ),
              ],
            ),
            TextField(
              controller: TextEditingController(text: _selectedDob),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Date of Birth (DD/MM/YYYY)',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => _selectedDob = val,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCountry,
              dropdownColor: const Color(0xFF1E1E2C),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Country', border: OutlineInputBorder()),
              items: _countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => _selectedCountry = val!),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('I confirm I am 18+ years old', style: TextStyle(fontSize: 13)),
              value: _agreed18Plus,
              activeColor: const Color(0xFFE94057),
              onChanged: (val) => setState(() => _agreed18Plus = val ?? false),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE94057),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: () {
                if (_nameController.text.trim().isEmpty || !_agreed18Plus) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill name and check 18+ confirmation')),
                  );
                  return;
                }
                final authCtrl = Provider.of<AuthController>(context, listen: false);
                authCtrl.completeNewUserProfile(
                  name: _nameController.text.trim(),
                  selectedGender: _selectedGender,
                  selectedDob: _selectedDob,
                  selectedCountry: _selectedCountry,
                  loginIdentifier: widget.loginIdentifier,
                  loginType: widget.loginType,
                );
                Navigator.pushReplacementNamed(context, '/main');
              },
              child: const Text('Save & Enter App', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
