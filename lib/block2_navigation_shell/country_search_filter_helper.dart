import 'package:flutter/material.dart';
import 'streamer_model_data.dart';

class SearchStreamerDialog extends StatefulWidget {
  const SearchStreamerDialog({super.key});

  @override
  State<SearchStreamerDialog> createState() => _SearchStreamerDialogState();
}

class _SearchStreamerDialogState extends State<SearchStreamerDialog> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final results = kAllStreamers.where((s) => s.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return AlertDialog(
      backgroundColor: const Color(0xFF1D1B36),
      title: const Text('Search Streamers / Users', style: TextStyle(color: Colors.white, fontSize: 16)),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Type name to search...',
                hintStyle: TextStyle(color: Colors.white54),
              ),
              onChanged: (val) => setState(() => searchQuery = val),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (ctx, i) {
                  final streamer = results[i];
                  return ListTile(
                    leading: const CircleAvatar(backgroundColor: Colors.pink, child: Icon(Icons.person, color: Colors.white)),
                    title: Text(streamer.name, style: const TextStyle(color: Colors.white)),
                    subtitle: Text('${streamer.flag} ${streamer.country}', style: const TextStyle(color: Colors.white60, fontSize: 11)),
                    onTap: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Selected ${streamer.name} from ${streamer.country}')),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close', style: TextStyle(color: Color(0xFFF97316)))),
      ],
    );
  }
}

class CountryFilterListModal extends StatelessWidget {
  final String selectedCountry;
  final ValueChanged<String> onSelected;

  const CountryFilterListModal({super.key, required this.selectedCountry, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final countries = ['All', 'India', 'America', 'Bangladesh', 'Pakistan', 'Russia', 'Africa', 'Madagascar'];

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Country Filter', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 250,
            child: ListView.builder(
              itemCount: countries.length,
              itemBuilder: (ctx, i) {
                final country = countries[i];
                return ListTile(
                  title: Text(country, style: const TextStyle(color: Colors.white)),
                  trailing: selectedCountry == country ? const Icon(Icons.check, color: Color(0xFFF97316)) : null,
                  onTap: () => onSelected(country),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
