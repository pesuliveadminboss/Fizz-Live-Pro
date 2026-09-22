import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onCompleteOnboarding;
  const OnboardingScreen({super.key, required this.onCompleteOnboarding});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController nameController = TextEditingController();
  String selectedGender = 'Male';
  String dobText = '';
  String selectedCountry = 'India 🇮🇳';

  final List<String> allCountries = [
    'India 🇮🇳',
    'United States 🇺🇸',
    'United Arab Emirates 🇦🇪',
    'United Kingdom 🇬🇧',
    'Canada 🇨🇦',
    'Australia 🇦🇺',
    'Singapore 🇸🇬',
    'Malaysia 🇲🇾',
    'Germany 🇩🇪',
    'France 🇫🇷',
    'Japan 🇯🇵',
    'South Korea 🇰🇷',
    'Saudi Arabia 🇸🇦',
    'Qatar 🇶🇦',
  ];

  void _pickCountryDialog() {
    String searchKeyword = '';
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          final filtered = allCountries.where((c) => c.toLowerCase().contains(searchKeyword.toLowerCase())).toList();
          return AlertDialog(
            backgroundColor: const Color(0xFF1F1A24),
            title: const Text('Select Country', style: TextStyle(color: Colors.white, fontSize: 15)),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: Column(
                children: [
                  TextField(
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'Search country...',
                      hintStyle: TextStyle(color: Colors.white54),
                      prefixIcon: Icon(Icons.search, color: Colors.white54, size: 18),
                    ),
                    onChanged: (val) {
                      setDialogState(() => searchKeyword = val);
                    },
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, index) {
                        final c = filtered[index];
                        return ListTile(
                          title: Text(c, style: const TextStyle(color: Colors.white, fontSize: 13)),
                          trailing: selectedCountry == c ? const Icon(Icons.check, color: Colors.pinkAccent, size: 18) : null,
                          onTap: () {
                            setState(() => selectedCountry = c);
                            Navigator.pop(ctx);
                          },
                        );
                      },
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

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0B1E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Complete Profile', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                const Text('First time setup for live & social discovery', style: TextStyle(color: Colors.white54, fontSize: 12)),
                const SizedBox(height: 24),
                // Profile photo placeholder
                const Center(
                  child: Stack(
                    children: [
                      CircleAvatar(radius: 45, backgroundColor: Colors.pinkAccent, child: Icon(Icons.camera_alt, size: 30, color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Name', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 6),
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: const Color(0xFF1F1A24),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Gender', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 6),
                Row(
                  children: ['Male', 'Female', 'Other'].map((g) {
                    final selected = selectedGender == g;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedGender = g),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: selected ? Colors.pinkAccent : const Color(0xFF1F1A24),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(child: Text(g, style: TextStyle(color: Colors.white, fontWeight: selected ? FontWeight.bold : FontWeight.normal, fontSize: 12))),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text('Date of Birth (18+ Only)', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000, 1, 1),
                      firstDate: DateTime(1960),
                      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
                    );
                    if (picked != null) {
                      setState(() {
                        dobText = '${picked.day}/${picked.month}/${picked.year}';
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F1A24),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(dobText.isEmpty ? 'Select DOB (18+)' : dobText, style: TextStyle(color: dobText.isEmpty ? Colors.white38 : Colors.white, fontSize: 13)),
                        const Icon(Icons.calendar_today, color: Colors.white54, size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Country (Default India 🇮🇳)', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _pickCountryDialog,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F1A24),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(selectedCountry, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                        const Icon(Icons.arrow_drop_down, color: Colors.white54),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      if (nameController.text.trim().isEmpty || dobText.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill name and 18+ DOB!')),
                        );
                        return;
                      }
                      widget.onCompleteOnboarding();
                    },
                    child: const Text('Save & Enter App 🚀', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
