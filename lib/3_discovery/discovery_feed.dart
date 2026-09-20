import 'package:flutter/material.dart';
import 'streamer_model.dart';
import 'streamer_profile_sheet.dart';
import 'live_stream_room_screen.dart';
import '../4_interactions/call_and_party_screens.dart';

class DiscoveryFeedScreen extends StatefulWidget {
  const DiscoveryFeedScreen({super.key});

  @override
  State<DiscoveryFeedScreen> createState() => _DiscoveryFeedScreenState();
}

class _DiscoveryFeedScreenState extends State<DiscoveryFeedScreen> {
  StreamerItemData? pipActiveStreamer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF110B22),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Main Discovery Grid Feed
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    'Discovery Feed',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: globalHotStreamers.length,
                    itemBuilder: (_, index) {
                      final item = globalHotStreamers[index];
                      return GestureDetector(
                        onTap: () {
                          if (item.status == 'live') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LiveStreamRoomScreen(
                                  streamer: item,
                                  onMinimizePIP: (s) => setState(() => pipActiveStreamer = s),
                                  onDismissTotal: () => setState(() => pipActiveStreamer = null),
                                ),
                              ),
                            );
                          } else if (item.status == 'party') {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: const Color(0xFF140D26),
                              builder: (_) => const SizedBox(height: 500, child: PartyRoomGridWidget()),
                            );
                          } else {
                            showStreamerProfileModal(context, item);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white.withOpacity(0.05),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                item.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(color: Colors.white12, child: const Icon(Icons.person, color: Colors.white24)),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.transparent, Colors.black87],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                left: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: item.status == 'live' ? Colors.redAccent : Colors.purpleAccent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item.status.toUpperCase(),
                                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                right: 10,
                                child: Text(
                                  item.name,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Floating Draggable Floating PIP Overlay if minimized
          if (pipActiveStreamer != null)
            DraggableLivePIPWrapper(
              streamer: pipActiveStreamer!,
              onDismissTotal: () => setState(() => pipActiveStreamer = null),
              onExpandFull: () {
                final target = pipActiveStreamer!;
                setState(() => pipActiveStreamer = null);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LiveStreamRoomScreen(
                      streamer: target,
                      onMinimizePIP: (s) => setState(() => pipActiveStreamer = s),
                      onDismissTotal: () => setState(() => pipActiveStreamer = null),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
