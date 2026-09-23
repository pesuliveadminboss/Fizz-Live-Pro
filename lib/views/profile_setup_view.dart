import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/user_prefs.dart';
import 'home_feed_view.dart';

class ProfileSetupView extends StatefulWidget {
  const ProfileSetupView({super.key});

  @override
  State<ProfileSetupView> createState() => _ProfileSetupViewState();
}

class _ProfileSetupViewState extends State<ProfileSetupView> {
  final nameController = TextEditingController();
  String gender = 'Male';
  String country = 'India';
  DateTime? selectedDob;

  int calculateAge(DateTime dob) {
    DateTime today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month || (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }

  void _saveProfile() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Enter your name', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (selectedDob == null) {
      Get.snackbar('Error', 'Select Date of Birth', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    int age = calculateAge(selectedDob!);
    if (age < 18) {
      Get.snackbar('Age Restriction', 'You must be 18+ to use Fizz Live Pro', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    await UserPrefs.setProfileDone(true);
    Get.off(() => const HomeFeedView());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Complete Profile'), backgroundColor: Colors.grey[900]),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const Center(child: CircleAvatar(radius: 50, backgroundColor: Colors.grey, child: Icon(Icons.camera_alt, size: 30, color: Colors.white))),
            const SizedBox(height: 20),
            TextField(controller: nameController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Full Name', filled: true, fillColor: Colors.grey9actions)) ?? InputDecoration(labelText: 'Full Name')),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: gender,
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white),
              items: ['Male', 'Female', 'Other'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: (v) => setState(() => gender = v!),
              decoration: const InputDecoration(labelText: 'Gender'),
            ),
            const SizedBox(height: 15),
            ListTile(
              title: Text(selectedDob == null ? 'Select Date of Birth (18+)' : 'DOB: ${selectedDob!.toLocal().toString().split(' ')[0]}', style: const TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.calendar_today, color: Colors.pinkAccent),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2004, 1, 1),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                );
                if (picked != null) setState(() => selectedDob = picked);
              },
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: country,
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white),
              items: ['India', 'USA', 'UAE', 'Singapore'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => country = v!),
              decoration: const InputDecoration(labelText: 'Country'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, padding: const EdgeInsets.symmetric(vertical: 16)),
              onPressed: _saveProfile,
              child: const Text('Save & Enter App', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
