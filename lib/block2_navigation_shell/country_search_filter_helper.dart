import 'package:flutter/material.dart';

class CountrySearchFilterHelper {
  static Future<String?> showCountryFilterDialog(BuildContext context, String currentSelected) async {
    final List<String> countries = ['All', 'India', 'Egypt', 'Brazil', 'USA', 'Russia', 'Vietnam', 'Philippines'];

    return await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF1D1B36),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Country Filter 🌍',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: countries.length,
                  itemBuilder: (context, index) {
                    final country = countries[index];
                    return ListTile(
                      title: Text(
                        country,
                        style: TextStyle(
                          color: currentSelected == country ? Colors.pinkAccent : Colors.white,
                          fontWeight: currentSelected == country ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: currentSelected == country
                          ? const Icon(Icons.check, color: Colors.pinkAccent)
                          : null,
                      onTap: () {
                        Navigator.pop(context, country);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
