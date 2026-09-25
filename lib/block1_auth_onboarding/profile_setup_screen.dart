import 'package:flutter/material.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  String _gender = 'Female'; // Default female to trigger Go Live option
  bool _is18PlusChecked = true;
  String _selectedCountry = 'India';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(backgroundColor: Colors.transparent, title: const Text('Setup Your Profile', style: TextStyle(color: Colors.white))),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(radius: 40, backgroundColor: Colors.white24, child: Icon(Icons.camera_alt, color: Colors.white)),
            const SizedBox(height: 20),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Profile Name / Guest 001',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF1E1E2C),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Gender: ', style: TextStyle(color: Colors.white)),
                ChoiceChip(
                  label: const Text('Male'),
                  selected: _gender == 'Male',
                  selectedColor: const Color(0xFFE94057),
                  onSelected: (val) => setState(() => _gender = 'Male'),
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text('Female (Streamer)'),
                  selected: _gender == 'Female',
                  selectedColor: const Color(0xFFE94057),
                  onSelected: (val) => setState(() => _gender = 'Female'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Country:', style: TextStyle(color: Colors.white)),
                DropdownButton<String>(
                  value: _selectedCountry,
                  dropdownColor: const Color(0xFF1E1E2C),
                  style: const TextStyle(color: Colors.white),
                  items: ['India', 'America', 'Bangladesh', 'Pakistan', 'Russia', 'Africa', 'Madagascar']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedCountry = val!),
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: _is18PlusChecked,
                  activeColor: const Color(0xFFE94057),
                  onChanged: (val) => setState(() => _is18PlusChecked = val ?? true),
                ),
                const Text('I confirm that I am 18 years of age or older (18+)', style: TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE94057), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/popups');
                },
                child: const Text('Complete & Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
