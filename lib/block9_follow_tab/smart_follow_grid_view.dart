import 'package:flutter/material.dart';
import 'follow_sync_service.dart';

class SmartFollowGridView extends StatelessWidget {
  final List<FollowUserModel> userList;
  final Function(FollowUserModel) onCardTap;

  const SmartFollowGridView({
    super.key,
    required this.userList,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    if (userList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'No online followed users found. Follow streamers from Hot or Live tabs!',
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
      itemCount: userList.length,
      itemBuilder: (context, index) {
        final user = userList[index];

        Color statusColor = Colors.green;
        if (user.status == 'Live') statusColor = Colors.pinkAccent;
        if (user.status == 'Busy') statusColor = Colors.amber;
        if (user.status == 'Party') statusColor = Colors.cyan;

        return GestureDetector(
          onTap: () => onCardTap(user),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1D1B36),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white12),
            ),
            child: Stack(
              children: [
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
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      user.status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
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
                        user.details,
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
          ),
        );
      },
    );
  }
}
