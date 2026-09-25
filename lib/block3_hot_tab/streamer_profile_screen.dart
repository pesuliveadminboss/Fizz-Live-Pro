import 'package:flutter/material.dart';
import 'core_data.dart';
import '../block5_live_room_immersive/zego_video_call.dart';

class StreamerProfileScreen extends StatelessWidget {
  final StreamerItem streamer;

  const StreamerProfileScreen({super.key, required this.streamer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header Image & Back Button matching Screenshot 4 / Screenshot 9
            Stack(
              children: [
                Container(
                  height: 380,
                  width: double.infinity,
                  color: streamer.color.withOpacity(0.5),
                  child: Center(
                    child: Text(
                      streamer.name[0],
                      style: const TextStyle(fontSize: 90, fontWeight: FontWeight.bold, color: Colors.white24),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: IconButton(
                      icon: const Icon(Icons.more_horiz, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
            
            // Profile Details Container matching Screenshot 4 / Screenshot 9
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF0F0F1A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                streamer.name,
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.verified, color: Colors.blue, size: 18),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ID: 720474292 • ${streamer.flag} ${streamer.country} • ${streamer.age}',
                            style: const TextStyle(fontSize: 12, color: Colors.white70),
                          ),
                        ],
                      ),
                      const Icon(Icons.favorite, color: Colors.pinkAccent, size: 28),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Introduction Box matching Screenshot 4 / Screenshot 9
                  const Text('Introduction', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white54)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2C),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      streamer.bio,
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Speaking Language matching Screenshot 4 / Screenshot 9
                  const Text('Speaking language', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white54)),
                  const SizedBox(height: 8),
                  Row(
                    children: streamer.speakingLanguage.split(', ').map((lang) => Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E2C),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(lang, style: const TextStyle(fontSize: 12, color: Colors.white)),
                    )).toList(),
                  ),
                  const SizedBox(height: 30),

                  // Bottom 1-to-1 Video Call Action Button matching Screenshot 4 / Screenshot 9
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE94057),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        showVideoCall1to1Dialog(context, streamer);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.videocam, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Video Call • 1800/min',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
