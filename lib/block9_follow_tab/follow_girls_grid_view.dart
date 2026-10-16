import 'package:flutter/material.dart';
import 'follow_tab_model.dart';

class FollowGirlsGridView extends StatelessWidget {
  final List<FollowTabModel> followedGirls;
  final Function(FollowTabModel) onUnfollow;

  const FollowGirlsGridView({
    super.key,
    required this.followedGirls,
    required this.onUnfollow,
  });

  @override
  Widget build(BuildContext context) {
    if (followedGirls.isEmpty) {
      const centerText = 'No followed streamers yet. Explore Hot & Live tabs to follow!';
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            centerText,
            style: TextStyle(color: Colors.white60, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.72,
      ),
      itemCount: followedGirls.length,
      itemBuilder: (context, index) {
        final streamer = followedGirls[index];
        
        // Status color logic
        Color statusColor = Colors.green;
        if (streamer.status == 'Live') statusColor = Colors.pinkAccent;
        if (streamer.status == 'Busy') statusColor = Colors.amber;
        if (streamer.status == 'Party') statusColor = Colors.cyan;

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1D1B36),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white12),
          ),
          child: Stack(
            children: [
              // Background / Avatar Placeholder
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    color: Colors.black45,
                    child: const Center(
                      child: Icon(Icons.person, size: 50, color: Colors.white30),
                    ),
                  ),
                ),
              ),
              
              // Gradient Overlay for text readability
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              // Status Badge on top-left
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    streamer.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Name and Details at bottom
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      streamer.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      streamer.details,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
