import 'package:flutter/material.dart';
import 'models_and_state.dart';
import 'popups_and_call.dart';

class StreamerProfileScreen extends StatefulWidget {
  final StreamerItem streamer;
  const StreamerProfileScreen({super.key, required this.streamer});

  @override
  State<StreamerProfileScreen> createState() => _StreamerProfileScreenState();
}

class _StreamerProfileScreenState extends State<StreamerProfileScreen> {
  bool isFollowing = false;
  bool isBlocked = false;
  int reportCount = 0;
  bool isBanned = false;

  bool r1 = true, r2 = false, r3 = false, r4 = false, r5 = false;

  void _showOptionsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              title: Center(child: Text(isFollowing ? 'Unlike' : 'Like', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
              onTap: () {
                Navigator.pop(ctx);
                setState(() => isFollowing = !isFollowing);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isFollowing ? 'Following' : 'Unfollowing'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
            const Divider(height: 1),
            ListTile(
              title: const Center(child: Text('Report', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
              onTap: () {
                Navigator.pop(ctx);
                _showReportDialog();
              },
            ),
            const Divider(height: 1),
            ListTile(
              title: Center(child: Text(isBlocked ? 'Unblock' : 'Block', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
              onTap: () {
                Navigator.pop(ctx);
                _showBlockConfirmDialog();
              },
            ),
            const Divider(height: 1),
            ListTile(
              title: const Center(child: Text('Cancel', style: TextStyle(color: Colors.grey))),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  void _showBlockConfirmDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(isBlocked ? 'Unblock ${widget.streamer.name}?' : 'Are you sure you want to block ${widget.streamer.name}?'),
        content: Text(isBlocked ? 'You can add her back anytime.' : 'You can remove her from the blocklist in the Settings.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => isBlocked = !isBlocked);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(isBlocked ? 'User Blocked successfully' : 'User Unblocked')),
              );
            },
            child: Text(isBlocked ? 'Unblock' : 'Confirm', style: const TextStyle(color: Color(0xFFE94057))),
          ),
        ],
      ),
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Report', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CheckboxListTile(title: const Text('Inappropriate content', style: TextStyle(fontSize: 13)), value: r1, activeColor: const Color(0xFFE94057), onChanged: (v) => setModalState(() => r1 = v ?? false)),
              CheckboxListTile(title: const Text('Sexual related content', style: TextStyle(fontSize: 13)), value: r2, activeColor: const Color(0xFFE94057), onChanged: (v) => setModalState(() => r2 = v ?? false)),
              CheckboxListTile(title: const Text('Abusement or discriminal', style: TextStyle(fontSize: 13)), value: r3, activeColor: const Color(0xFFE94057), onChanged: (v) => setModalState(() => r3 = v ?? false)),
              CheckboxListTile(title: const Text('Unreasonable demands', style: TextStyle(fontSize: 13)), value: r4, activeColor: const Color(0xFFE94057), onChanged: (v) => setModalState(() => r4 = v ?? false)),
              CheckboxListTile(title: const Text('Child Sexual Abuse and Exploitation', style: TextStyle(fontSize: 13)), value: r5, activeColor: const Color(0xFFE94057), onChanged: (v) => setModalState(() => r5 = v ?? false)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), side: const BorderSide(color: Color(0xFFE94057))),
                    onPressed: () {
                      reportCount++;
                      if (reportCount >= 3) isBanned = true;
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report submitted successfully. Thank you!')));
                    },
                    child: const Text('Report', style: TextStyle(color: Color(0xFFE94057))),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), side: const BorderSide(color: Colors.grey)),
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isBanned) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: const Text('Account Restricted / Customer Met 1 Month Ban due to reports.', textAlign: TextAlign.center, style: TextStyle(color: Colors.redAccent, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Big Profile Photo Section
                Container(
                  height: 380,
                  width: double.infinity,
                  color: widget.streamer.color.withOpacity(0.5),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Center(child: Text(widget.streamer.name[0], style: const TextStyle(fontSize: 90, color: Colors.white24, fontWeight: FontWeight.bold))),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: widget.streamer.color,
                                  child: Text(widget.streamer.name[0], style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(widget.streamer.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                        const SizedBox(width: 6),
                                        const Icon(Icons.verified, color: Colors.cyanAccent, size: 16),
                                      ],
                                    ),
                                    const Text('ID: 340301087', style: TextStyle(color: Colors.white70, fontSize: 11)),
                                  ],
                                ),
                              ],
                            ),
                            // Pink / Black Heart Follow Button with 2s Popup
                            GestureDetector(
                              onTap: () {
                                setState(() => isFollowing = !isFollowing);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(isFollowing ? 'Following' : 'Unfollowing'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                                child: Icon(
                                  isFollowing ? Icons.favorite : Icons.favorite_border,
                                  color: isFollowing ? Colors.pinkAccent : Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Status & Age
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: widget.streamer.status == 'live' ? Colors.red : Colors.green, borderRadius: BorderRadius.circular(10)),
                        child: Text(widget.streamer.status.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Text('${widget.streamer.flag} ${widget.streamer.country} • Age ${widget.streamer.age}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Introduction Box
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Introduction', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFF2A1B3D), Color(0xFF1E1E2C)]),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Text('Hi, I\'m ${widget.streamer.name}. Call me if you\'re free. I\'m waiting for you with bated breath ✨', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Speaking Language
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Speaking language', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 8),
                      Chip(
                        backgroundColor: const Color(0xFF1E1E2C),
                        label: Text(widget.streamer.country == 'India' ? 'Tamil / English' : 'Arabic / English', style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          // Top Back & Options Navigation
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.white),
                  onPressed: _showOptionsSheet,
                ),
              ],
            ),
          ),
          // Bottom Action Bar: Message + Video Call Button (1 min = 1800 gems)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFF151522),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: const BoxDecoration(color: Color(0xFF1E1E2C), shape: BoxShape.circle),
                    child: IconButton(
                      icon: const Icon(Icons.chat_bubble_outline, color: Colors.cyanAccent, size: 20),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening chat channel...')));
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFFE94057), Color(0xFFFF6B8B)]),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                          onPressed: () => showVideoCall1to1Dialog(context, widget.streamer),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.videocam, color: Colors.white),
                              SizedBox(width: 8),
                              Text('Video Call (1 min = 1800 💎)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                    ),
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
