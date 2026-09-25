import 'package:flutter/material.dart';

void showViewerListDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF1E1E2C),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Active Viewers (3)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Icon(Icons.people, color: Colors.pinkAccent),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView(
              children: [
                _buildViewerTile('Macha User 1', '@macha_1', Colors.pink),
                _buildViewerTile('Macha User 2', '@macha_2', Colors.blue),
                _buildViewerTile('Macha User 3', '@macha_3', Colors.purple),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildViewerTile(String name, String handle, Color color) {
  return ListTile(
    leading: CircleAvatar(
      backgroundColor: color.withOpacity(0.3),
      child: Text(name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    ),
    title: Text(name, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
    subtitle: Text(handle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
    trailing: const Icon(Icons.star, color: Colors.amber, size: 16),
  );
}
