import 'package:flutter/material.dart';

class CountryFilterAndSearchDialog {
  static void showCountryFilter(
    BuildContext context,
    String selectedCountry,
    Function(String) onCountrySelected,
  ) {
    final List<String> countries = [
      'All',
      'India',
      'America',
      'Bangladesh',
      'Pakistan',
      'Russia',
      'Africa',
      'Madagascar'
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Country 🌎',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: countries
                  .map(
                    (c) => ChoiceChip(
                      label: Text(c),
                      selected: selectedCountry == c,
                      selectedColor: const Color(0xFFE94057),
                      onSelected: (val) {
                        onCountrySelected(c);
                        Navigator.pop(ctx);
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  static void showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        String query = '';
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C),
          title: const Text('Search Streamers 🔍', style: TextStyle(color: Colors.white)),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Type favorite streamer name...',
                    hintStyle: TextStyle(color: Colors.white54),
                  ),
                  onChanged: (val) {
                    query = val;
                  },
                ),
                const SizedBox(height: 12),
                const Text(
                  'Type to search live streamers...',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close', style: TextStyle(color: Color(0xFFE94057))),
            ),
          ],
        );
      },
    );
  }
}
