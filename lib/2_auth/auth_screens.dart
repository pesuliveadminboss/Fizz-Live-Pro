// Complete Profile Setup Screen with Auto-Name (user_0001), Gender-based Default Avatar, Camera/Gallery Mock Change
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
    // Auto-fill logic: if email login passed name, use it; else generate sequential user_0001
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
      // Auto update default avatar if user hasn't uploaded custom photo
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
                currentAvatar = 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200'; // Mock camera capture
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
                currentAvatar = 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200'; // Mock gallery pick
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
