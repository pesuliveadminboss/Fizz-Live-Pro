import 'package:flutter/material.dart';
import 'core_data.dart';

class StreamerProfileScreen extends StatefulWidget {
  final StreamerModel streamer;
  const StreamerProfileScreen({super.key, required this.streamer});

  @override
  State<StreamerProfileScreen> createState() => _StreamerProfileScreenState();
}

class _StreamerProfileScreenState extends State<StreamerProfileScreen> {
  bool _isLiked = false;
  bool _isBlocked = false;

  void _showOptionsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2C),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(_isLiked ? Icons.favorite : Icons.favorite_border, color: Colors.pink),
            title: Text(_isLiked ? 'Unlike' : 'Like', style: const TextStyle(color: Colors.white)),
            onTap: () {
              setState(() => _isLiked = !_isLiked);
              Navigator.pop(ctx);
            },
          ),
          ListTile(
            leading: const Icon(Icons.block, color: Colors.red),
            title: Text(_isBlocked ? 'Unblock User' : 'Block User', style: const TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(ctx);
              _confirmBlockDialog();
            },
          ),
          ListTile(
            leading: const Icon(Icons.report, color: Colors.amber),
            title: const Text('Report User', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(ctx);
              _showReportDialog();
            },
          ),
        ],
      ),
    );
  }

  void _confirmBlockDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        title: Text('Are you sure you want to block ${widget.streamer.name}?', style: const TextStyle(color: Colors.white, fontSize: 16)),
        content: const Text('You can remove her from the blocklist in settings.', style: TextStyle(color: Colors.white70, fontSize: 12)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() => _isBlocked = !_isBlocked);
              Navigator.pop(ctx);
            },
            child: const Text('Confirm', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        title: const Text('Report Content', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CheckboxListTile(title: Text('Inappropriate content', style: TextStyle(color: Colors.white, fontSize: 12)), value: false, onChanged: null),
            CheckboxListTile(title: Text('Sexual repeated content', style: TextStyle(color: Colors.white, fontSize: 12)), value: false, onChanged: null),
            CheckboxListTile(title: Text('Abuse or discrimination', style: TextStyle(color: Colors.white, fontSize: 12)), value: false, onChanged: null),
          ],
        ),
        actions: [
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE94057)), onPressed: () => Navigator.pop(ctx), child: const Text('Submit Report')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(height: 300, width: double.infinity, color: Colors.pink.withOpacity(0.3), child: const Center(child: Icon(Icons.person, size: 100, color: Colors.white54))),
                Positioned(top: 40, left: 16, child: CircleAvatar(backgroundColor: Colors.black45, child: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)))),
                Positioned(top: 40, right: 16, child: CircleAvatar(backgroundColor: Colors.black45, child: IconButton(icon: const Icon(Icons.more_horiz, color: Colors.white), onPressed: _showOptionsSheet))),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(widget.streamer.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 6),
                          const Icon(Icons.verified, color: Colors.blue, size: 16),
                        ],
                      ),
                      IconButton(
                        icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border, color: Colors.pink, size: 28),
                        onPressed: () => setState(() => _isLiked = !_isLiked),
                      ),
                    ],
                  ),
                  Text('${widget.streamer.flag} ${widget.streamer.country} • Age: ${widget.streamer.age}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 16),
                  const Text('Introduction', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 4),
                  Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFF1E1E2C), borderRadius: BorderRadius.circular(12)), child: Text(widget.streamer.intro, style: const TextStyle(color: Colors.white))),
                  const SizedBox(height: 16),
                  const Text('Speaking language', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(widget.streamer.language, style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE94057), minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Connecting 1-to-1 Video Call (1800 gems/min)...')));
                    },
                    child: const Text('Video • 1800/min', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

