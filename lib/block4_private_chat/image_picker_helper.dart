import 'package:flutter/material.dart';

class ImagePickerHelper {
  // Real Gallery Simulation / Image Picker method
  static void pickImageFromGallery(BuildContext context, Function(String) onImageSelected) {
    // In a real app with image_picker package, you would use ImagePicker().pickImage()
    // Here we simulate gallery picker success and pass a file path/indicator
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1D1B36),
          title: const Text('Select Gallery Image', style: TextStyle(color: Colors.white, fontSize: 16)),
          content: const Text('Choose a photo to send to streamer:', style: TextStyle(color: Colors.white70, fontSize: 13)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
              onPressed: () {
                Navigator.pop(context);
                onImageSelected('[Gallery Photo Attached 📷]');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Photo sent successfully from gallery!')),
                );
              },
              child: const Text('Send Photo', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

