import 'package:flutter/material.dart';

class LiveRoomMainScreen extends StatelessWidget {
  final String streamerName;
  final String streamerId;
  final String streamerCountry;
  final Widget childContent;
  final VoidCallback onClosePressed;
  final VoidCallback onProfilePressed;

  const LiveRoomMainScreen({
    Key? key,
    required this.streamerName,
    required this.streamerId,
    required this.streamerCountry,
    required this.childContent,
    required this.onClosePressed,
    required this.onProfilePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Stream Video Placeholder
          Container(
            color: Colors.grey[900],
            child: Center(
              child: Text(
                'Live Video Stream: $streamerName',
                style: const TextStyle(color: Colors.white54, fontSize: 16),
              ),
            ),
          ),
          
          // Child content (Chat, Overlay controls, etc.)
          childContent,

          // Top Header Bar
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Streamer Profile & Name Container
                GestureDetector(
                  onTap: onProfilePressed,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.pinkAccent,
                          child: Text(
                            streamerName.isNotEmpty ? streamerName[0] : 'S',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              streamerName,
                              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'ID: $streamerId',
                              style: const TextStyle(color: Colors.white70, fontSize: 10),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),

                // Close / PiP minimize button
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 22),
                  onPressed: onClosePressed,
                  style: IconButton.styleFrom(backgroundColor: Colors.black45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
