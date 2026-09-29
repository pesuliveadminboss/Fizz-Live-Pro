import 'package:flutter/material.dart';

class LiveRoomBottomToolbar extends StatefulWidget {
  final VoidCallback onOpenTools;
  final VoidCallback onVideoCall;
  final VoidCallback onGiftTap;
  final VoidCallback onLikeTap;
  final ValueChanged<String> onSendMessage;

  const LiveRoomBottomToolbar({
    super.key,
    required this.onOpenTools,
    required this.onVideoCall,
    required this.onGiftTap,
    required this.onLikeTap,
    required this.onSendMessage,
  });

  @override
  State<LiveRoomBottomToolbar> createState() => _LiveRoomBottomToolbarState();
}

class _LiveRoomBottomToolbarState extends State<LiveRoomBottomToolbar> {
  bool _isTypingOpen = false;
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Toggle Message Input / Small Message Icon
        _isTypingOpen
            ? Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.pinkAccent),
                  ),
                  child: TextField(
                    controller: _messageController,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Say something...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send, color: Colors.pinkAccent, size: 18),
                        onPressed: () {
                          if (_messageController.text.isNotEmpty) {
                            widget.onSendMessage(_messageController.text);
                            _messageController.clear();
                            setState(() {
                              _isTypingOpen = false;
                            });
                          }
                        },
                      ),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        widget.onSendMessage(value);
                        _messageController.clear();
                        setState(() {
                          _isTypingOpen = false;
                        });
                      }
                    },
                  ),
                ),
              )
            : GestureDetector(
                onTap: () {
                  setState(() {
                    _isTypingOpen = true;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.chat_bubble_outline, color: Colors.white, size: 18),
                      SizedBox(width: 4),
                      Text('Say something...', style: TextStyle(color: Colors.white54, fontSize: 12)),
                    ],
                  ),
                ),
              ),

        const Spacer(),

        // Center Big Heart Like Button
        GestureDetector(
          onTap: widget.onLikeTap,
          child: const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.pinkAccent,
            child: Icon(Icons.favorite, color: Colors.white, size: 18),
          ),
        ),
        const SizedBox(width: 8),

        // Gift Box Icon
        GestureDetector(
          onTap: widget.onGiftTap,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.purpleAccent]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.card_giftcard, color: Colors.white, size: 18),
          ),
        ),
        const SizedBox(width: 8),

        // Video Call Button (Red accent as in screenshot)
        GestureDetector(
          onTap: widget.onVideoCall,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.videocam, color: Colors.white, size: 18),
          ),
        ),
      ],
    );
  }
}
