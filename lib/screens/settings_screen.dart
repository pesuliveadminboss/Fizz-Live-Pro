import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _darkMode = true;
  bool _showOnlineStatus = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Safety'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Account & Privacy', style: TextStyle(color: Color(0xFFE94057), fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Show Online Status'),
            subtitle: const Text('Allow others to see when you are active'),
            value: _showOnlineStatus,
            activeColor: const Color(0xFFE94057),
            onChanged: (val) => setState(() => _showOnlineStatus = val),
          ),
          ListTile(
            leading: const Icon(Icons.block, color: Colors.orangeAccent),
            title: const Text('Blocked Users'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.report, color: Colors.redAccent),
            title: const Text('Report History'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const Divider(height: 32),
          const Text('Preferences', style: TextStyle(color: Color(0xFFE94057), fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Push Notifications'),
            value: _pushNotifications,
            activeColor: const Color(0xFFE94057),
            onChanged: (val) => setState(() => _pushNotifications = val),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _darkMode,
            activeColor: const Color(0xFFE94057),
            onChanged: (val) => setState(() => _darkMode = val),
          ),
          const Divider(height: 32),
          const Text('Support & Legal', style: TextStyle(color: Color(0xFFE94057), fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ListTile(
            title: const Text('Terms of Service'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Help & Support'),
            onTap: () {},
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Logout', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out safely.')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Delete Account', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
