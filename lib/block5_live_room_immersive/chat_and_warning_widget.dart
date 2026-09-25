import 'package:flutter/material.dart';

class ChatAndWarningWidget extends StatefulWidget {
  const ChatAndWarningWidget({super.key});

  @override
  State<ChatAndWarningWidget> createState() => _ChatAndWarningWidgetState();
}

class _ChatAndWarningWidgetState extends State<ChatAndWarningWidget> {
  final TextEditingController _chatController = TextEditingController();
  final List<String> _messages = [
    'Room! Something pornographic, vulgar, violent and under age is forbidden to appear in the live. You\'ll be punished seriously once you violate the rules!',
    'Cute Princess 👑: @mystery too.... Hey, glad you\'re here! 😍',
    'Guest joined the room',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pinned Warning Banner matching Screenshot 18 & 19
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.withOpacity(0.5)),
          ),
          child: const Text(
            'Room! Something pornographic, vulgar, violent and under age is forbidden to appear in the live. You\'ll be punished seriously once you violate the rules!',
            style: TextStyle(color: Colors.amber, fontSize: 10),
          ),
        ),
        const SizedBox(height: 8),

        // Scrolling Chat Messages List
        SizedBox(
          height: 110,
          child: ListView.builder(
            reverse: true,
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              final isWarning = index == _messages.length - 1 && msg.contains('Room!');
              if (isWarning) return const SizedBox.shrink(); // Already shown above

              return Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  msg,
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),

        // Chat Input Field & Send Button
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 38,
                child: TextField(
                  controller: _chatController,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'Say something...',
                    hintStyle: const TextStyle(color: Colors.white54, fontSize: 12),
                    filled: true,
                    fillColor: Colors.black54,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.pinkAccent, size: 20),
              onPressed: () {
                if (_chatController.text.isNotEmpty) {
                  setState(() {
                    _messages.insert(0, 'Macha User: ${_chatController.text}');
                    _chatController.clear();
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
