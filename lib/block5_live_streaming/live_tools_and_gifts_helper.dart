import 'package:flutter/material.dart';

class LiveToolsAndGiftsHelper {
  static void showToolsMenu(BuildContext context, VoidCallback onMinimize) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color(0xFF1D1B36),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tools & Options',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _buildToolItem(Icons.videogame_asset, 'Game Center', () {}),
                  _buildToolItem(Icons.auto_fix_high, 'Function Effect', () {}),
                  _buildToolItem(Icons.picture_in_picture, 'Minimize', () {
                    Navigator.pop(context);
                    onMinimize();
                  }),
                  _buildToolItem(Icons.message, 'Messages', () {}),
                  _buildToolItem(Icons.share, 'Share', () {}),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildToolItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white10,
            child: Icon(icon, color: Colors.pinkAccent, size: 22),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
