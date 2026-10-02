import 'package:flutter/material.dart';
import 'live_streamer_model.dart';

class StreamerProfilePopup extends StatelessWidget {
  final LiveStreamer streamer;

  const StreamerProfilePopup({super.key, required this.streamer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Cover Photo & Back Button
            Stack(
              children: [
                Container(
                  height: 280,
                  width: double.infinity,
                  color: Colors.purple.shade900,
                  child: const Center(
                    child: Icon(Icons.person, size: 100, color: Colors.white24),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.black45,
                      child: Icon(Icons.arrow_back, color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ],
            ),

            // Mini Gallery Row matching second screenshot
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: List.generate(5, (index) {
                  return Expanded(
                    child: Container(
                      height: 55,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.pinkAccent.withOpacity(0.4)),
                      ),
                      child: const Center(
                        child: Icon(Icons.image, color: Colors.white54, size: 20),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Profile Info Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        streamer.name,
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.verified, color: Colors.blueAccent, size: 16),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'ID: 340301087',
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(10)),
                        child: const Text('Lv6', style: TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.green.withOpacity(0.6), borderRadius: BorderRadius.circular(10)),
                        child: const Text('Egypt', style: TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Close Friends Section
                  const Text(
                    'Close Friends (0/3)',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: List.generate(3, (index) {
                      return Expanded(
                        child: Container(
                          height: 80,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.lock_outline, color: Colors.white54, size: 18),
                              SizedBox(height: 4),
                              Text('Waiting for someone', style: TextStyle(color: Colors.white54, fontSize: 8), textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),

                  // Introduction Section
                  const Text(
                    'Introduction',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Colors.purpleAccent, Colors.pinkAccent]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Hi, I\'m ${streamer.name}. Call me if you\'re free. I\'m waiting for you with bated breath!',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Speaking Language
                  const Text(
                    'Speaking language',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text('Arabic', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                  const SizedBox(height: 80), // Bottom padding for toolbar
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Action Toolbar (Chat Button + Video Call Button matching second screenshot)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: const Color(0xFF121026),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: Colors.cyan,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.chat_bubble, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Initiating Video Call...'), duration: Duration(seconds: 1)),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.videocam, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Video Call',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
