import 'package:flutter/material.dart';

class AuthorizationSettingsDialog extends StatelessWidget {
  const AuthorizationSettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2C),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header with Close Button matching Screenshot 12
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 24), // Spacer
                const Text(
                  'Authorization Settings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Please open authorization setting for better experience',
              style: TextStyle(fontSize: 12, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Permission Items (Camera, Phone, Microphone, Notification) matching Screenshot 12
            _buildPermissionRow(Icons.camera_alt, 'Camera'),
            const SizedBox(height: 10),
            _buildPermissionRow(Icons.phone, 'Phone'),
            const SizedBox(height: 10),
            _buildPermissionRow(Icons.mic, 'Microphone'),
            const SizedBox(height: 10),
            _buildPermissionRow(Icons.notifications, 'Notification'),
            const SizedBox(height: 24),

            // Allow All Button matching Screenshot 12
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE94057),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All permissions granted successfully! ✅')),
                  );
                  Navigator.pop(context);
                },
                child: const Text(
                  'Allow all',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionRow(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.pinkAccent, size: 20),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
