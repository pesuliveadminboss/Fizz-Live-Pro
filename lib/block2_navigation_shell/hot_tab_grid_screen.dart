import 'package:flutter/material.dart';
import 'streamer_model_data.dart';
import '../block3_hot_tab/streamer_profile_screen.dart';
import '../block3_hot_tab/streamer_profile_model.dart';

class HotTabGridScreen extends StatelessWidget {
  final String countryFilter;
  const HotTabGridScreen({super.key, this.countryFilter = 'All'});

  @override
  Widget build(BuildContext context) {
    final activeStreamers = kAllStreamers.where((s) {
      bool isNotOffline = s.status != 'offline';
      bool matchesCountry = (countryFilter == 'All' || s.country.toLowerCase() == countryFilter.toLowerCase());
      return isNotOffline && matchesCountry;
    }).toList();

    if (activeStreamers.isEmpty) {
      return const Center(
        child: Text('No active streamers found for this country.', style: TextStyle(color: Colors.white60, fontSize: 13)),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: activeStreamers.length,
      itemBuilder: (context, index) {
        final streamer = activeStreamers[index];
        
        Color statusColor;
        String statusText;
        if (streamer.status == 'live') {
          statusColor = Colors.pinkAccent;
          statusText = 'LIVE';
        } else if (streamer.status == 'party') {
          statusColor = Colors.blueAccent;
          statusText = 'PARTY';
        } else {
          statusColor = Colors.green;
          statusText = 'ONLINE';
        }

        return GestureDetector(
          onTap: () {
            final profileModel = StreamerProfileModel(
              id: streamer.id,
              name: streamer.name,
              country: streamer.country,
              flag: streamer.flag,
              age: streamer.age,
              status: streamer.status,
              intro: streamer.intro,
              language: streamer.language,
              isVerified: true,
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StreamerProfileScreen(streamer: profileModel),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1D1B36),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Stack(
              children: [
                const Center(child: Icon(Icons.person, size: 60, color: Colors.white24)),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(8)),
                    child: Text(statusText, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(streamer.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                          const SizedBox(height: 2),
                          Text('${streamer.flag} ${streamer.country}', style: const TextStyle(color: Colors.white70, fontSize: 10)),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Connecting 1-to-1 Video Call with ${streamer.name}...')),
                          );
                        },
                        child: const CircleAvatar(
                          radius: 14,
                          backgroundColor: Color(0xFFF97316),
                          child: Icon(Icons.videocam, size: 14, color: Colors.white),
                        ),
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
