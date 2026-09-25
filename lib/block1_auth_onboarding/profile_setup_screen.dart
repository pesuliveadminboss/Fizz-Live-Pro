import 'package:flutter/material.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedGender = 'Female';
  bool _is18PlusChecked = true;
  String _selectedCountry = 'India';

  final List<String> _countries = ['India', 'America', 'Bangladesh', 'Pakistan', 'Russia', 'Africa', 'Madagascar'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Setup Your Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Photo Upload Placeholder
            Stack(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF1E1E2C),
                  child: Icon(Icons.person, size: 60, color: Colors.white54),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE94057),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Profile Name Input
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Profile Name',
                labelStyle: const TextStyle(color: Colors.white60),
                filled: true,
                fillColor: const Color(0xFF1E1E2C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Gender Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Gender:', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(width: 20),
                ChoiceChip(
                  label: const Text('Male'),
                  selected: _selectedGender == 'Male',
                  selectedColor: const Color(0xFFE94057),
                  onSelected: (val) => setState(() => _selectedGender = 'Male'),
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text('Female'),
                  selected: _selectedGender == 'Female',
                  selectedColor: const Color(0xFFE94057),
                  onSelected: (val) => setState(() => _selectedGender = 'Female'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Country Dropdown / Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Country:', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: _selectedCountry,
                  dropdownColor: const Color(0xFF1E1E2C),
                  style: const TextStyle(color: Colors.white),
                  items: _countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) => setState(() => _selectedCountry = val ?? 'India'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 18+ Age Checkbox Verification
            Row(
              children: [
                Checkbox(
                  value: _is18PlusChecked,
                  activeColor: const Color(0xFFE94057),
                  onChanged: (val) => setState(() => _is18PlusChecked = val ?? true),
                ),
                const Text(
                  'I confirm that I am 18 years of age or older (18+)',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Continue Button to App Popups / Main Shell
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE94057),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () {
                  // Move to entry popups / main
                  Navigator.pushReplacementNamed(context, '/popups');
                },
                child: const Text(
                  'Complete & Continue',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
