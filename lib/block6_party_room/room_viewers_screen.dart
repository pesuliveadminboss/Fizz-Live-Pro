import 'package:flutter/material.dart';
import '../block3_hot_tab/streamer_profile_screen.dart';
import '../block3_hot_tab/streamer_profile_model.dart';

class RoomViewersScreen extends StatefulWidget {
  final List<Map<String, String>> viewers;

  const RoomViewersScreen({super.key, required this.viewers});

  @override
  State<RoomViewersScreen> createState() => _RoomViewersScreenState();
}

class _RoomViewersScreenState extends State<RoomViewersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F051D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A0B2E),
        title: Text('Room Viewers (${widget.viewers.length})', style: const TextStyle(color: Colors.white, fontSize: 16)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: widget.viewers.isEmpty
          ? const Center(
              child: Text('No viewers in the room', style: TextStyle(color: Colors.white54, fontSize: 14)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.viewers.length,
              itemBuilder: (context, index) {
                final viewer = widget.viewers[index];
                final serialNumber = index + 1;

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: InkWell(
                    onTap: () {
                      final streamerModel = StreamerProfileModel(
                        name: viewer['name']!,
                        id: 'user_id_$serialNumber',
                        country: 'India',
                        flag: '🇮🇳',
                        age: 23,
                        status: viewer['status']!,
                        intro: 'Hello! Welcome to my profile.',
                        language: 'Tamil / English',
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StreamerProfileScreen(streamer: streamerModel),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3), width: 1),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '$serialNumber.',
                            style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(width: 12),
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.pinkAccent.withOpacity(0.4),
                            child: Text(viewer['name']![0], style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  viewer['name']!,
                                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  viewer['status']!,
                                  style: const TextStyle(color: Colors.white60, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 14),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

