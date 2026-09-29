import 'package:flutter/material.dart';
import 'live_streamer_model.dart';
import 'live_category_filter_bar.dart';
import 'live_streamer_grid_card.dart';
import 'live_ads_integration_helper.dart';

class LiveTabScreen extends StatefulWidget {
  const LiveTabScreen({super.key});

  @override
  State<LiveTabScreen> createState() => _LiveTabScreenState();
}

class _LiveTabScreenState extends State<LiveTabScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredStreamers = _selectedCategory == 'All'
        ? LiveStreamer.dummyStreamers
        : LiveStreamer.dummyStreamers.where((s) => s.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      body: Column(
        children: [
          LiveCategoryFilterBar(
            selectedCategory: _selectedCategory,
            onCategorySelected: (cat) {
              setState(() {
                _selectedCategory = cat;
              });
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: filteredStreamers.length,
                    itemBuilder: (context, index) {
                      return LiveStreamerGridCard(streamer: filteredStreamers[index]);
                    },
                  ),
                  const SizedBox(height: 10),
                  // AdMob Banner between grid content
                  LiveAdsIntegrationHelper.buildGridBannerAd(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

