import 'package:flutter/material.dart';
import '../controllers/app_state_controller.dart';
import 'profile_detail_view_screen.dart';

class FollowTabScreen extends StatelessWidget {
  const FollowTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppStateController.instance,
      builder: (context, _) {
        final list = AppStateController.instance.getFollowedOnlineUsers();
        if (list.isEmpty) {
          return const Center(
            child: Text('No online followed users', style: TextStyle(color: Colors.white54, fontSize: 13)),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemCount: list.length,
          itemBuilder: (_, index) {
            final u = list[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfileDetailViewScreen(streamer: u)),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1A24),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    const Center(child: Icon(Icons.person, size: 50, color: Colors.white24)),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
                        child: Text(u.status.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      right: 8,
                      child: Text(
                        '${u.name} | ${u.country}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
