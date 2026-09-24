import 'package:flutter/material.dart';

class LiveChatAndWarningBanner extends StatefulWidget {
  const LiveChatAndWarningBanner({Key? key}) : super(key: key);

  @override
  State<LiveChatAndWarningBanner> createState() => _LiveChatAndWarningBannerState();
}

class _LiveChatAndWarningBannerState extends State<LiveChatAndWarningBanner> {
  final List<Map<String, String>> _messages = [
    {'user': 'Cute Princess', 'msg': '@mystery too.... Hey, glad you\'re here! 😊'},
    {'user': 'Guest', 'msg': 'joined the room'},
    {'user': 'Admin', 'msg': 'Welcome to Fizz Live Pro! Be respectful.'},
  ];

  final TextEditingController _msgController = TextEditingController();

  void _sendMessage() {
    if (_msgController.text.trim().isEmpty) return;
    setState(() {
      _messages.add({'user': 'Fizz User', 'msg': _msgController.text.trim()});
      _msgController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pinned Warning Banner (Screenshot 3 style)
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.amber.withOpacity(0.5), width: 1),
          ),
          child: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 16),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Room! Something pornographic, vulgar, violent and under age is forbidden to appear in the live. You\'ll be punished seriously once you violate the rules!',
                  style: TextStyle(color: Colors.amberAccent, fontSize: 10),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Scrolling Live Chat Container (with history view capability)
        Container(
          height: 140,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.builder(
            reverse: true,
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[_messages.length - 1 - index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${msg['user']}: ',
                        style: const TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      TextSpan(
                        text: msg['msg'],
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),

        // Chat Input Row
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _msgController,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                decoration: InputDecoration(
                  hintText: 'Say something...',
                  hintStyle: const TextStyle(color: Colors.white54, fontSize: 12),
                  filled: true,
                  fillColor: Colors.black54,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.pinkAccent, size: 20),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ],
    );
  }
}

