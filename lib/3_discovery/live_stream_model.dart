class LiveViewerItem {
  final String id;
  final String name;
  final String avatarUrl;
  final String age;
  final String country;

  const LiveViewerItem({required this.id, required this.name, required this.avatarUrl, required this.age, required this.country});
}

class LiveChatMessage {
  final String senderName;
  final String text;
  final bool isStreamer;
  final bool isJoinEvent;

  const LiveChatMessage({required this.senderName, required this.text, this.isStreamer = false, this.isJoinEvent = false});
}

final List<LiveViewerItem> mockLiveViewers = [
  const LiveViewerItem(id: '90002001', name: 'user_0001', avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200', age: '24', country: 'India'),
  const LiveViewerItem(id: '90002002', name: 'vibe_master', avatarUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200', age: '26', country: 'Russia'),
];

List<LiveChatMessage> getInitialLiveChat() => [
  const LiveChatMessage(senderName: 'System', text: 'Pornographic, vulgar, violent and under age is forbidden to appear in the live.', isStreamer: true),
  const LiveChatMessage(senderName: 'Kamyla', text: 'Hello 👋 Stay and enjoy the live with me!'),
  const LiveChatMessage(senderName: 'user_0001', text: 'joined the stream', isJoinEvent: true),
];
