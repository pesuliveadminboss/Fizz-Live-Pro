import 'package:flutter/material.dart';

class ProfileSetupScreen extends StatefulWidget {
  final String defaultName;
  const ProfileSetupScreen({super.key, this.defaultName = 'New User'});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  late TextEditingController _nameController;
  String _gender = 'Female'; // Female -> Streamer (Go Live shown), Male -> User
  String _selectedCountry = 'India';
  bool _is18PlusChecked = true;
  final TextEditingController _dobController = TextEditingController(text: '10/10/2000');

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.defaultName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(backgroundColor: Colors.transparent, title: const Text('New User Profile Setup', style: TextStyle(color: Colors.white))),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: CircleAvatar(radius: 40, backgroundColor: Colors.white24, child: Icon(Icons.camera_alt, color: Colors.white, size: 30)),
              ),
              const SizedBox(height: 20),
              const Text('Profile Name / Random ID', style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF1E1E2C),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Gender (Male = User | Female = Streamer)', style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 6),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('Male (User)'),
                    selected: _gender == 'Male',
                    selectedColor: const Color(0xFFE94057),
                    onSelected: (val) => setState(() => _gender = 'Male'),
                  ),
                  const SizedBox(width: 12),
                  ChoiceChip(
                    label: const Text('Female (Streamer)'),
                    selected: _gender == 'Female',
                    selectedColor: const Color(0xFFE94057),
                    onSelected: (val) => setState(() => _gender = 'Female'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Country Selector', style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedCountry,
                dropdownColor: const Color(0xFF1E1E2C),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF1E1E2C),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                items: ['India', 'America', 'Bangladesh', 'Pakistan', 'Russia', 'Africa', 'Madagascar']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCountry = val!),
              ),
              const SizedBox(height: 20),
              const Text('Date of Birth', style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 6),
              TextField(
                controller: _dobController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF1E1E2C),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: _is18PlusChecked,
                    activeColor: const Color(0xFFE94057),
                    onChanged: (val) => setState(() => _is18PlusChecked = val ?? true),
                  ),
                  const Text('I confirm I am 18 years of age or older (18+)', style: TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE94057),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/popups');
                  },
                  child: const Text('Confirm & Enter App', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
