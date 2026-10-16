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

  void _showToolsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1D1B36),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 240,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tool',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildToolItem(context, Icons.sports_esports, 'Games Center', Colors.blueAccent),
                  _buildToolItem(context, Icons.volume_up, 'Function Effect', Colors.purpleAccent),
                  _buildToolItem(context, Icons.aspect_ratio, 'Minimize', Colors.orangeAccent),
                  _buildToolItem(context, Icons.message, 'Messages', Colors.greenAccent),
                  _buildToolItem(context, Icons.share, 'Share', Colors.pinkAccent),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildToolItem(BuildContext context, IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label clicked!'), duration: const Duration(seconds: 1)),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF121026),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.5)),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _submitMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text);
      _messageController.clear();
      setState(() {
        _isTypingOpen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isTypingOpen) {
      return Container(
        width: 195, // 👉 அகலத்தைக் குறைத்து வலது பக்க பட்டன்களில் மோதாதவாறு சரிசெய்யப்பட்டுள்ளது
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.85),
          borderRadius: BorderRadius.circular(20),
          // 👉 பிங்க் கலர் கேப்சூல் அவுட்லைன் பார்டர் முழுமையாக நீக்கப்பட்டது
        ),
        child: Center(
          child: TextField(
            controller: _messageController,
            autofocus: true,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Say something...',
              hintStyle: const TextStyle(color: Colors.white54, fontSize: 13),
              border: InputBorder.none,
              isDense: true,
              suffixIcon: IconButton(
                icon: const Icon(Icons.send, color: Colors.pinkAccent, size: 18),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                onPressed: _submitMessage,
              ),
            ),
            onSubmitted: (_) => _submitMessage(),
          ),
        ),
      );
    }

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isTypingOpen = true;
            });
          },
          child: Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(19),
            ),
            child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 18),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => _showToolsBottomSheet(context),
          child: Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(19),
            ),
            child: const Icon(Icons.grid_view, color: Colors.white, size: 18),
          ),
        ),
      ],
    );
  }
}
