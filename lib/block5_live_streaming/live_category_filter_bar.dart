import 'package:flutter/material.dart';

class LiveCategoryFilterBar extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const LiveCategoryFilterBar({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> categories = ['All', 'Hot', 'Pretty', 'New', 'Sexy'];

    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              selectedColor: Colors.pinkAccent,
              backgroundColor: const Color(0xFF1D1B36),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              onSelected: (selected) {
                onCategorySelected(cat);
              },
            ),
          );
        },
      ),
    );
  }
}
