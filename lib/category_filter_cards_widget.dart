import 'package:flutter/material.dart';
import 'live_stream_model_and_filters.dart';

class CategoryFilterCardsWidget extends StatelessWidget {
  final StreamerCategory? selectedCategory;
  final Function(StreamerCategory?) onCategorySelected;

  const CategoryFilterCardsWidget({
    Key? key,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
              SizedBox(width: 6),
              Text(
                'Hot',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCard(context, 'Pretty', StreamerCategory.pretty, Colors.pinkAccent),
              _buildCard(context, 'New', StreamerCategory.newStreamer, Colors.blueAccent),
              _buildCard(context, 'Sexy', StreamerCategory.sexy, Colors.purpleAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, StreamerCategory category, Color accentColor) {
    final isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () {
        if (isSelected) {
          onCategorySelected(null); // Toggle off if already selected
        } else {
          onCategorySelected(category);
        }
      },
      child: Container(
        width: 95,
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? accentColor : Colors.transparent, width: 2),
          gradient: LinearGradient(
            colors: [Colors.grey[850]!, Colors.grey[900]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withOpacity(0.3),
              ),
              child: Icon(Icons.star, color: accentColor, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? accentColor : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
