import 'package:flutter/material.dart';

class SyncedHeartsAndFollowController extends StatefulWidget {
  final VoidCallback? onFollowStateChanged;

  const SyncedHeartsAndFollowController({
    Key? key,
    this.onFollowStateChanged,
  }) : super(key: key);

  @override
  State<SyncedHeartsAndFollowController> createState() => _SyncedHeartsAndFollowControllerState();
}

class _SyncedHeartsAndFollowControllerState extends State<SyncedHeartsAndFollowController> {
  bool _isFollowing = false;

  void _toggleFollow(BuildContext context) {
    setState(() {
      _isFollowing = !_isFollowing;
    });

    if (widget.onFollowStateChanged != null) {
      widget.onFollowStateChanged!();
    }

    // Show popup matching requirement
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFollowing ? 'Following successfully! ❤️' : 'Unfollowing... 🖤',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: _isFollowing ? Colors.pinkAccent : Colors.grey[850],
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top or Bottom Synced Heart / Follow Button
        GestureDetector(
          onTap: () => _toggleFollow(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _isFollowing ? Colors.grey[900] : Colors.pinkAccent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.pinkAccent, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isFollowing ? '🖤' : '🩷',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 6),
                Text(
                  _isFollowing ? 'Following' : 'Follow',
                  style: TextStyle(
                    color: _isFollowing ? Colors.pinkAccent : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

