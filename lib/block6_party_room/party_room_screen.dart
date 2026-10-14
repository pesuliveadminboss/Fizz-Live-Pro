import 'package:flutter/material.dart';
import '../block3_hot_tab/streamer_profile_screen.dart';
import '../block3_hot_tab/streamer_profile_model.dart';
import '../block4_private_chat/private_chat_screen.dart';
import '../block5_live_streaming/streamer_follow_manager.dart';
import 'room_viewers_screen.dart';
import 'gift_bottom_sheet.dart';
import 'party_room_minimize_helper.dart';

class PartyRoomScreen extends StatefulWidget {
  final dynamic room;

  const PartyRoomScreen({
    super.key,
    this.room,
  });

  @override
  State<PartyRoomScreen> createState() => _PartyRoomScreenState();
}

class _PartyRoomScreenState extends State<PartyRoomScreen> with SingleTickerProviderStateMixin {
  bool isMinimized = false;
  Offset floatingOffset = const Offset(20, 100);
  final TextEditingController _messageController = TextEditingController();

  final String streamerKey = 'Alsha Live';

  bool isMuted = false;
  String? activeGiftEffect;

  final List<Map<String, String>> chatMessages = [
    {"user": "System", "text": "Welcome to Party Room! Keep it clean and respectful."},
    {"user": "Raj Shukla", "text": "Nice to meet you! Grab the mic."},
    {"user": "System", "text": "Karthik Kumar joined the Party Room 🚀"},
  ];

  final List<Map<String, String>> roomViewers = [
    {"name": "Raj Shukla", "status": "Active Listener"},
    {"name": "Alsha Live (Host)", "status": "Broadcaster"},
    {"name": "Karthik Kumar", "status": "Joined via For You"},
    {"name": "Priya Ramesh", "status": "Active Listener"},
    {"name": "Suresh Babu", "status": "Active Listener"},
  ];

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  final List<Map<String, dynamic>> voiceSeats = List.generate(10, (index) => {
        'index': index + 1,
        'name': index == 0 ? 'Host' : 'User ${index + 1}',
        'isSpeaking': index == 1 || index == 4,
        'isMuted': false,
      });

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 2.0, end: 6.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _toggleMute() {
    setState(() {
      isMuted = !isMuted;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isMuted ? 'Mic Muted 🔇' : 'Mic Unmuted 🎙️'),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  void _openViewersScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoomViewersScreen(viewers: roomViewers),
      ),
    );
    setState(() {});
  }

  void _openFullHostProfile(BuildContext context) async {
    final streamerModel = StreamerProfileModel(
      name: 'Alsha Live',
      id: streamerKey,
      country: 'India',
      flag: '🇮🇳',
      age: 22,
      status: 'Online',
      intro: 'Welcome to my party room! Enjoy the music & vibes 🎉',
      language: 'Tamil / English',
    );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StreamerProfileScreen(streamer: streamerModel),
      ),
    );
    setState(() {});
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        chatMessages.add({
          "user": "You",
          "text": _messageController.text.trim(),
        });
      });
      _messageController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  void _triggerGiftEffect(String giftName) {
    setState(() {
      activeGiftEffect = giftName;
    });
    Future.
      
