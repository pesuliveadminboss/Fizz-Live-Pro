import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Music', 'Dance', 'Talk', 'Gaming', 'PK Battle'];

  final List<Map<String, String>> _mockCreators = [
    {'name': 'Anitha_Live', 'category': 'Music', 'viewers': '1.2K', 'status': 'Live'},
    {'name': 'Karthik_Talks', 'category': 'Talk', 'viewers': '850', 'status': 'Live'},
    {'name': 'Priya_Dance', 'category': 'Dance', 'viewers': '3.4K', 'status': 'Live'},
    {'name': 'Gamer_Leo', 'category': 'Gaming', 'viewers': '540', 'status': 'Busy'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore & Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search username, tags, creators...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFF1E1E2C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: const Color(0xFFE94057),
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _mockCreators.length,
              itemBuilder: (context, index) {
                final creator = _mockCreators[index];
                return Card(
                  color: const Color(0xFF1E1E2C),
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFE94057),
                      child: Text(creator['name']![0]),
                    ),
                    title: Text(creator['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${creator['category']} • ${creator['viewers']} viewers'),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: creator['status'] == 'Live' ? Colors.redAccent : Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(creator['status']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    onTap: () {},
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
