import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_profile_controller.dart';
import 'home_feed_view.dart';

class ProfileOnboardingView extends StatefulWidget {
  final String mode; // 'fast', 'google', 'phone', 'guest'
  final String? initialEmail;

  ProfileOnboardingView({required this.mode, this.initialEmail});

  @override
  _ProfileOnboardingView createState() => _ProfileOnboardingView();
}

class _ProfileOnboardingView extends State<ProfileOnboardingView> {
  final UserProfileController uController = Get.find<UserProfileController>();

  late TextEditingController nameController;
  late TextEditingController dobController;
  late TextEditingController phoneController;
  late TextEditingController otpController;

  String selectedGender = 'Female';
  String selectedCountry = 'India';
  bool otpSent = false;
  bool otpVerified = false;

  @override
  void initState() {
    super.initState();
    if (widget.mode == 'fast') {
      uController.resetForFastLogin();
    } else if (widget.mode == 'google') {
      uController.fillFromGoogleAccount(widget.initialEmail ?? 'streamer@gmail.com');
    } else if (widget.mode == 'guest') {
      uController.setupGuestProfile('Female', '10/10/2000', 'India');
    }

    nameController = TextEditingController(text: uController.profileName.value);
    dobController = TextEditingController(text: uController.dob.value);
    phoneController = TextEditingController();
    otpController = TextEditingController();
    selectedGender = uController.gender.value;
    selectedCountry = uController.country.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.mode == 'phone' && otpSent && !otpVerified ? "Verify OTP" : "Complete Profile (${widget.mode.toUpperCase()})"),
        backgroundColor: Color(0xFF1E0B36),
      ),
      body: widget.mode == 'phone'
          ? (otpVerified ? _buildProfileForm() : _buildPhoneStepOrOtp())
          : _buildProfileForm(),
    );
  }

  Widget _buildPhoneStepOrOtp() {
    if (!otpSent) {
      return Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enter Mobile Number", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "+91 9876543210",
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFE91E63), minimumSize: Size(double.infinity, 50)),
              child: Text("Send OTP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () {
                if (phoneController.text.trim().length < 8) {
                  Get.snackbar("Error", "Enter valid phone number");
                  return;
                }
                setState(() => otpSent = true);
                Get.snackbar("OTP Sent", "Mock OTP: 1234 sent");
              },
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enter OTP sent to phone", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "1234",
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFE91E63), minimumSize: Size(double.infinity, 50)),
              child: Text("Verify OTP & Proceed", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () {
                if (otpController.text.trim().isNotEmpty) {
                  setState(() => otpVerified = true);
                  // Per your rule: phone number otp user otp enter panathu direct ulla poganum (or fill form if first time, if existing user auto mark)
                  if (uController.isRegistered.value) {
                    Get.offAll(() => HomeFeedView());
                  }
                } else {
                  Get.snackbar("Error", "Enter OTP");
                }
              },
            ),
          ],
        ),
      );
    }
  }

  Widget _buildProfileForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Obx(() => Column(
            children: [
              CircleAvatar(
                radius: 45,
                backgroundImage: NetworkImage(uController.profilePhotoUrl.value),
              ),
              SizedBox(height: 8),
              Text(
                widget.mode == 'guest' ? uController.profileName.value : "Edit / Confirm Profile details",
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          )),
          SizedBox(height: 20),
          TextField(
            controller: nameController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Profile Name",
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFE91E63))),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text("Gender (18+ required): ", style: TextStyle(color: Colors.white, fontSize: 14)),
              SizedBox(width: 10),
              DropdownButton<String>(
                value: selectedGender,
                dropdownColor: Color(0xFF1E0B36),
                style: TextStyle(color: Colors.white),
                items: ['Female', 'Male'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedGender = val ?? 'Female';
                    uController.updateGenderAvatar(selectedGender);
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          TextField(
            controller: dobController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Date of Birth (DD/MM/YYYY)",
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text("Country: ", style: TextStyle(color: Colors.white, fontSize: 14)),
              SizedBox(width: 10),
              Expanded(
                child: DropdownButton<String>(
                  value: selectedCountry,
                  isExpanded: true,
                  dropdownColor: Color(0xFF1E0B36),
                  style: TextStyle(color: Colors.white),
                  items: uController.allCountries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedCountry = val ?? 'India';
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE91E63),
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            ),
            child: Text("Save & Enter Fizz Live Pro", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            onPressed: () {
              uController.updateCustomProfile(
                name: nameController.text.trim().isEmpty ? uController.profileName.value : nameController.text.trim(),
                g: selectedGender,
                d: dobController.text.trim(),
                c: selectedCountry,
              );
              uController.markAsExistingUser();
              Get.offAll(() => HomeFeedView());
            },
          ),
        ],
      ),
    );
  }
}
