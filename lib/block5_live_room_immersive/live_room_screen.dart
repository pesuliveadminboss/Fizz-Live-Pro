import 'package:flutter/material.dart';

class LiveRoomScreen extends StatefulWidget {
  final String streamerName;
  const LiveRoomScreen({super.key, required this.streamerName});

  @override
  State<LiveRoomScreen> createState() => _LiveRoomScreenState();
}

class _LiveRoomScreenState extends State<LiveRoomScreen> {
  bool _isFollowing = false;
  final List<String> _chatMessages = ['User 1: Hello!', 'Guest joined the room'];
  final TextEditingController _msgController = TextEditingController();

  void _toggleFollow() {
    setState(() => _isFollowing = !_isFollowing);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isFollowing ? 'Following (+2s)' : 'Unfollowing (-2s)', style: const TextStyle(fontSize: 12)), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: Colors.purple.withOpacity(0.3), child: const Center(child: Text('Live Video Stream Active', style: TextStyle(color: Colors.white24, fontSize: 20)))),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            const CircleAvatar(radius: 14, backgroundColor: Colors.pink, child: Icon(Icons.person, size: 14, color: Colors.white)),
                            const SizedBox(width: 6),
                            Text(widget.streamerName, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: _toggleFollow,
                              child: Icon(_isFollowing ? Icons.favorite : Icons.favorite_border, color: Colors.pink, size: 18),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(12)),
                            child: Row(children: const [Icon(Icons.remove_red_eye, color: Colors.white70, size: 12), SizedBox(width: 4), Text('12', style: TextStyle(color: Colors.white, fontSize: 11))]),
                          ),
                          const SizedBox(width: 8),
                          IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.amber)),
                        child: const Text('Warning: Pornographic, vulgar or violent content is forbidden!', style: TextStyle(color: Colors.amber, fontSize: 9)),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 90,
                        child: ListView.builder(
                          reverse: true,
                          itemCount: _chatMessages.length,
                          itemBuilder: (ctx, i) => Text(_chatMessages[i], style: const TextStyle(color: Colors.white, fontSize: 11)),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 35,
                              child: TextField(
                                controller: _msgController,
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                                decoration: InputDecoration(
                                  hintText: 'Say something...',
                                  hintStyle: const TextStyle(color: Colors.white54, fontSize: 11),
                                  filled: true,
                                  fillColor: Colors.black54,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.send, color: Colors.pink, size: 18),
                            onPressed: () {
                              if (_msgController.text.isNotEmpty) {
                                setState(() => _chatMessages.insert(0, 'Me: ${_msgController.text}'));
                                _msgController.clear();
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(_isFollowing ? Icons.favorite : Icons.favorite_border, color: Colors.pink, size: 22),
                            onPressed: _toggleFollow,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
