import 'package:flutter/material.dart';
import 'live_streamer_model.dart';
import 'streamer_follow_manager.dart';
import 'live_viewers_list_helper.dart';
import '../block4_private_chat/profile_navigation_bridge.dart';

class LiveRoomHeader extends StatelessWidget {
  final LiveStreamer streamer;
  final VoidCallback onMinimize;
  final VoidCallback onClose;
  final int viewerCount;
  final List<String> viewersList;

  const LiveRoomHeader({
    super.key,
    required this.streamer,
    required this.onMinimize,
    required this.onClose,
    required this.viewerCount,
    required this.viewersList,
  });

  @override
  Widget build(BuildContext context) {
    final followNotifier = StreamerFollowManager().getFollowNotifier(streamer.name);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                ProfileNavigationBridge.openStreamerProfile(
                  context: context,
                  streamerId: '340301087',
                  streamerName: streamer.name,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.pinkAccent,
                      child: Icon(Icons.person, color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      streamer.name,
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        StreamerFollowManager().toggleFollow(streamer.name);
                        final status = StreamerFollowManager().isFollowing(streamer.name);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(status ? 'Successfully Followed Streamer ❤️' : 'Unfollowed Streamer'),
                            duration: const Duration(milliseconds: 500),
                          ),
                        );
                      },
                      child: ValueListenableBuilder<bool>(
                        valueListenable: followNotifier,
                        builder: (context, isFollowing, child) {
                          return CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.black54,
                            child: Icon(
                              isFollowing ? Icons.favorite : Icons.favorite_border,
                              color: isFollowing ? Colors.pinkAccent : Colors.white,
                              size: 20,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Clickable Viewer Count Badge next to close button
                GestureDetector(
                  onTap: () => LiveViewersListHelper.showViewersModal(context, viewersList),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.visibility, color: Colors.white70, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '$viewerCount',
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: onClose,
                  child: const Text(
                    '×',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
