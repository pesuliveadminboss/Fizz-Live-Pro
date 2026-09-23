import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  final List<Map<String, dynamic>> _chats = const [
    {'name': 'Anitha_Live', 'lastMessage': 'Super show macha!', 'time': '10m', 'unread': 2, 'online': true},
    {'name': 'Karthik_Talks', 'lastMessage': 'Call me back', 'time': '1h', 'unread': 0, 'online': false},
    {'name': 'Priya_Dance', 'lastMessage': 'Sent a gift 🎁', 'time': '3h', 'unread': 5, 'online': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(icon: const Icon(Icons.edit_square), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        itemCount: _chats.length,
        itemBuilder: (context, index) {
          final chat = _chats[index];
          return ListTile(
            leading: Stack(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFE94057),
                  child: Text(chat['name'][0], style: const TextStyle(color: Colors.white)),
                ),
                if (chat['online'] == true)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF0F0F1A), width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            title: Text(chat['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(chat['lastMessage'], maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(chat['time'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                if ((chat['unread'] as int) > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE94057),
                      shape: BoxShape.circle,
                    ),
                    child: Text('${chat['unread']}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            onTap: () {},
          );
        },
      ),
    );
  }
}
