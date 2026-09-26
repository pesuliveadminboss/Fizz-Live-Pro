import 'package:flutter/material.dart';
import 'recharge_gems_dialog.dart';
import 'voice_recorder_helper.dart';
import '../block3_hot_tab/profile_actions_dialogs.dart';
import '../block3_hot_tab/streamer_profile_model.dart';

class PrivateChatScreen extends StatefulWidget {
  final String streamerName;
  const PrivateChatScreen({super.key, this.streamerName = 'sara'});

  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isEmojiPickerVisible = false;

  final List<String> _emojis = [
    '😊', '😂', '😍', '😲', '😢', '😡', '😎', '🔥',
    '❤️', '👍', '💋', '🎉', '✨', '🌹', '💎', '🎁'
  ];

  final List<Map<String, dynamic>> _messages = [
    {'sender': 'streamer', 'text': 'Hi! Welcome to my private chat ✨', 'type': 'text'},
    {'sender': 'user', 'text': 'Hello! How are you doing?', 'type': 'text'},
  ];

  void _sendMessage({String? customText, String type = 'text'}) {
    final textToSend = customText ?? _messageController.text.trim();
    if (textToSend.isEmpty) return;
    setState(() {
      _messages.add({'sender': 'user', 'text': textToSend, 'type': type});
      if (customText == null) _messageController.clear();
    });
  }

  void _addEmoji(String emoji) {
    setState(() {
      _messageController.text += emoji;
    });
  }

  void _pickImageFromGallery() {
    _sendMessage(customText: '[Photo Attachment 📷]', type: 'image');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Photo selected and sent from gallery!')),
    );
  }

  void _showGiftBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1D1B36),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 280,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Send Gift to Streamer 🎁', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  Icon(Icons.diamond, color: Colors.amber),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    _buildGiftItem('🌹 Rose', '10 Gems', Colors.redAccent),
                    _buildGiftItem('💍 Ring', '100 Gems', Colors.blueAccent),
                    _buildGiftItem('👑 Crown', '500 Gems', Colors.amber),
                    _buildGiftItem('🏎️ Sports Car', '2000 Gems', Colors.purpleAccent),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGiftItem(String name, String price, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _sendMessage(customText: 'Sent a gift: $name ($price) 🎁', type: 'gift');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully sent $name!')),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF121026),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.card_giftcard, color: color, size: 28),
            const SizedBox(height: 4),
            Text(name, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
            Text(price, style: const TextStyle(color: Colors.amber, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121026),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 14,
              backgroundColor: Color(0xFF6366F1),
              child: Icon(Icons.person, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Text(
              widget.streamerName,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.verified, color: Colors.blueAccent, size: 14),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.white),
            onPressed: () {
              final dummyModel = StreamerProfileModel(
                id: '1',
                name: widget.streamerName,
                country: 'Egypt',
                flag: '🇪🇬',
                age: 23,
                status: 'live',
                intro: 'Live streaming star',
                language: 'Arabic, English',
                isVerified: true,
              );
              ProfileActionsDialogs.showMoreOptionsSheet(
                context,
                dummyModel,
                () => setState(() {}),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1D1B36),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 12,
                      backgroundColor: Color(0xFF6366F1),
                      child: Icon(Icons.person, size: 12, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.streamerName,
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, color: Colors.blueAccent, size: 12),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Lv7', style: TextStyle(color: Colors.white, fontSize: 9)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white24,
                        child: const Icon(Icons.person, size: 18, color: Colors.white70),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Always gratefull 👑🎁',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['sender'] == 'user';
                final isAudio = msg['type'] == 'audio';

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isUser ? const Color(0xFF6366F1) : const Color(0xFF1D1B36),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isAudio) ...[
                          const Icon(Icons.play_arrow, color: Colors.white, size: 20),
                          const SizedBox(width: 6),
                          Container(
                            width: 80,
                            height: 4,
                            color: Colors.white54,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          msg['text']!,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            color: const Color(0xFF121026),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.mic, color: Colors.redAccent, size: 24),
                      onPressed: () {
                        VoiceRecorderHelper.startRecording(context, (voiceText) {
                          _sendMessage(customText: voiceText, type: 'audio');
                        });
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Send message',
                          hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
                          filled: true,
                          fillColor: const Color(0xFF1D1B36),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 20),
                      onPressed: () => _sendMessage(),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image, color: Colors.greenAccent, size: 22),
                      onPressed: _pickImageFromGallery,
                    ),
                    IconButton(
                      icon: const Icon(Icons.emoji_emotions, color: Colors.amber, size: 22),
                      onPressed: () {
                        setState(() {
                          _isEmojiPickerVisible = !_isEmojiPickerVisible;
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const RechargeGemsDialog(),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF97316),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.videocam, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text('1800/min', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.card_giftcard, color: Colors.pinkAccent, size: 22),
                      onPressed: _showGiftBottomSheet,
                    ),
                  ],
                ),
                if (_isEmojiPickerVisible)
                  Container(
                    height: 160,
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1D1B36),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 8,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemCount: _emojis.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _addEmoji(_emojis[index]),
                          child: Center(
                            child: Text(
                              _emojis[index],
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
