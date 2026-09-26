import 'package:flutter/material.dart';
import 'streamer_profile_model.dart';

class ProfileActionsDialogs {
  // More options (...) popup menu
  static void showMoreOptionsSheet(BuildContext context, StreamerProfileModel streamer, VoidCallback onUpdate) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1D1B36),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(streamer.isBlocked ? Icons.lock_open : Icons.block, color: Colors.redAccent),
              title: Text(streamer.isBlocked ? 'Unblock ${streamer.name}' : 'Block ${streamer.name}', style: const TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
                _confirmBlockUnblock(context, streamer, onUpdate);
              },
            ),
            ListTile(
              leading: const Icon(Icons.report_problem, color: Colors.orangeAccent),
              title: const Text('Report Streamer', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
                _showReportDialog(context, streamer, onUpdate);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: Colors.white54),
              title: const Text('Cancel', style: TextStyle(color: Colors.white54)),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  static void _confirmBlockUnblock(BuildContext context, StreamerProfileModel streamer, VoidCallback onUpdate) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1D1B36),
        title: Text(streamer.isBlocked ? 'Unblock ${streamer.name}?' : 'Block ${streamer.name}?', style: const TextStyle(color: Colors.white)),
        content: Text(
          streamer.isBlocked ? 'Do you want to remove her from the blocklist?' : 'Are you sure you want to block ${streamer.name}? You can remove her from the blocklist in settings.',
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
          TextButton(
            onPressed: () {
              streamer.isBlocked = !streamer.isBlocked;
              Navigator.pop(ctx);
              onUpdate();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(streamer.isBlocked ? '${streamer.name} has been blocked.' : '${streamer.name} has been unblocked.')),
              );
            },
            child: Text(streamer.isBlocked ? 'Block' : 'Unblock', style: const TextStyle(color: Color(0xFFF97316))),
          ),
        ],
      ),
    );
  }

  static void _showReportDialog(BuildContext context, StreamerProfileModel streamer, VoidCallback onUpdate) {
    final List<String> reasons = [
      'Inappropriate content',
      'Sexual repeated content',
      'Abusement or discrimination',
      'Unresponsible demands',
      'Child sexual abuse and exploitation'
    ];
    String selectedReason = reasons[0];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateModal) => AlertDialog(
          backgroundColor: const Color(0xFF1D1B36),
          title: const Text('Report Streamer', style: TextStyle(color: Colors.white, fontSize: 16)),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: reasons.length,
              itemBuilder: (context, index) {
                return RadioListTile<String>(
                  title: Text(reasons[index], style: const TextStyle(color: Colors.white, fontSize: 13)),
                  value: reasons[index],
                  groupValue: selectedReason,
                  activeColor: const Color(0xFFF97316),
                  onChanged: (val) => setStateModal(() => selectedReason = val!),
                );
              },
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                streamer.reportCount++;
                if (streamer.reportCount >= 3) {
                  streamer.isBanned = true;
                }
                onUpdate();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Report submitted successfully. Thank you.')),
                );
              },
              child: const Text('Submit Report', style: TextStyle(color: Color(0xFFF97316))),
            ),
          ],
        ),
      ),
    );
  }
}

