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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (_isTypingOpen) {
          setState(() {
            _isTypingOpen = false;
          });
        }
      },
      child: Row(
        children: [
          _isTypingOpen
              ? Expanded(
                  child: Container(
                    height: 38,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.pinkAccent),
                    ),
                    child: TextField(
                      controller: _messageController,
                      autofocus: true,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      decoration: InputDecoration(
                        hintText: 'Say something...',
                        hintStyle: const TextStyle(color: Colors.white54, fontSize: 12),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send, color: Colors.pinkAccent, size: 16),
                          padding: EdgeInsets.zero,
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
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isTypingOpen = true;
                        });
                      },
                      child: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 16),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: widget.onOpenTools,
                      child: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(Icons.grid_view, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),

          const Spacer(),

          // Center Big Heart Like Button
          GestureDetector(
            onTap: widget.onLikeTap,
            child: const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.pinkAccent,
              child: Icon(Icons.favorite, color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 8),

          // Gift Box Icon
          GestureDetector(
            onTap: widget.onGiftTap,
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.purpleAccent]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.card_giftcard, color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 8),

          // Video Call Button
          GestureDetector(
            onTap: widget.onVideoCall,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.videocam, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
