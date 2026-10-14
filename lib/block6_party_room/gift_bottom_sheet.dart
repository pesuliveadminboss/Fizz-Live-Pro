import 'package:flutter/material.dart';

class GiftBottomSheet extends StatefulWidget {
  final Function(String giftName, int quantity) onSendGift;

  const GiftBottomSheet({
    super.key,
    required this.onSendGift,
  });

  @override
  State<GiftBottomSheet> createState() => _GiftBottomSheetState();
}

class _GiftBottomSheetState extends State<GiftBottomSheet> {
  String selectedCategory = 'Bag';
  String? selectedGiftName;
  int selectedQuantity = 1;

  final Map<String, List<Map<String, dynamic>>> giftCategories = {
    'Bag': [
      {'name': 'Linked Ring', 'price': 2},
      {'name': 'RosePerfume', 'price': 2},
      {'name': 'LoveCrown', 'price': 2},
      {'name': 'Fluttering Ring', 'price': 2},
      {'name': 'Voting', 'price': 10},
    ],
    'Festival': [
      {'name': 'Cute Love', 'price': 890},
      {'name': 'Flower Heart', 'price': 3990},
      {'name': 'Love Galaxy', 'price': 17000},
      {'name': 'Valentine Wish', 'price': 57000},
      {'name': 'Eid Blessing', 'price': 770},
      {'name': 'Eid Night', 'price': 27770},
      {'name': 'Eid Feast', 'price': 50770},
      {'name': 'Christmas Wish', 'price': 97000},
      {'name': 'Christmas Tree', 'price': 225000},
      {'name': '2026', 'price': 2},
      {'name': 'New Year Cheers', 'price': 890},
      {'name': 'New Year Celebration', 'price': 3990},
      {'name': 'New Year Romance', 'price': 97000},
      {'name': 'Countdown', 'price': 270000},
      {'name': 'Pink Heart', 'price': 2},
      {'name': 'Blessing Lantern', 'price': 3},
      {'name': 'Blessing Light', 'price': 770},
      {'name': 'Golden Moon', 'price': 5770},
      {'name': 'Ramadan Kareem', 'price': 20770},
      {'name': 'Christmas Pine', 'price': 2},
      {'name': 'Christmas Wreath', 'price': 500},
      {'name': 'Enchanting Tree', 'price': 3990},
      {'name': 'Santa\'s Gift', 'price': 57000},
    ],
    'Wealth': [
      {'name': 'Exclusive Car', 'price': 339900},
      {'name': 'Wealth Castle', 'price': 995800},
      {'name': 'Star Wand', 'price': 798000},
      {'name': 'Love Jet', 'price': 550000},
      {'name': 'Coin Burst', 'price': 370000},
      {'name': 'Victory Crown', 'price': 277000},
      {'name': 'Crystal Dragon', 'price': 100000},
      {'name': 'Heart of Ocean', 'price': 30000},
      {'name': 'Rocket', 'price': 4158000},
    ],
    'Intimacy': [
      {'name': 'Passionate Night', 'price': 3700},
      {'name': 'Wedding Ring', 'price': 17000},
      {'name': 'Yacht Party', 'price': 57000},
      {'name': 'Yacht Wedding', 'price': 17000},
      {'name': 'Holding You', 'price': 3700},
      {'name': 'Twilight Yacht', 'price': 890},
      {'name': 'Private Lounge', 'price': 3700},
      {'name': 'Sweet Cake', 'price': 1770},
      {'name': 'Date & Drink', 'price': 17770},
      {'name': 'Love Couple', 'price': 27770},
      {'name': 'Oath Blade', 'price': 770},
      {'name': 'Starry Rose', 'price': 17700},
      {'name': 'Pink Romance', 'price': 17700},
      {'name': 'Dance Lover', 'price': 2},
      {'name': 'Shining Dancer', 'price': 890},
      {'name': 'Manor Love', 'price': 17770},
      {'name': 'Growing Love', 'price': 1770},
      {'name': 'Romantic Candy', 'price': 70},
      {'name': 'Romantic Butterfly', 'price': 2},
      {'name': 'Diamond Ring', 'price': 2},
      {'name': 'Gold Watch', 'price': 770},
      {'name': 'Cash Rain', 'price': 3770},
      {'name': 'Luxury House', 'price': 12770},
      {'name': 'Castle Romance', 'price': 17700},
      {'name': 'Cruise Romance', 'price': 77700},
      {'name': 'Hot Air Balloon', 'price': 200},
      {'name': 'Beach Chair', 'price': 2},
      {'name': 'Happy Summer', 'price': 200},
      {'name': 'Beach Couple', 'price': 77700},
      {'name': 'Castle Love', 'price': 27700},
      {'name': 'Flower Man', 'price': 17700},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final gifts = giftCategories[selectedCategory] ?? [];

    return Container(
      height: 420,
      decoration: const BoxDecoration(
        color: Color(0xFF1A122B),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header Categories Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: giftCategories.keys.map((category) {
                bool isSelected = selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                        selectedGiftName = null;
                      });
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white60,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                        if (isSelected)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            height: 3,
                            width: 20,
                            decoration: BoxDecoration(
                              color: Colors.pinkAccent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(color: Colors.white24, height: 1),

          // Gifts Grid View
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemCount: gifts.length,
              itemBuilder: (context, index) {
                final gift = gifts[index];
                bool isSelected = selectedGiftName == gift['name'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGiftName = gift['name'];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.pinkAccent.withOpacity(0.2) : Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.pinkAccent : Colors.white12,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.card_giftcard, color: Colors.amberAccent, size: 28),
                        const SizedBox(height: 6),
                        Text(
                          gift['name'],
                          style: const TextStyle(color: Colors.white, fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.diamond, color: Colors.cyanAccent, size: 10),
                            const SizedBox(width: 3),
                            Text(
                              '${gift['price']}',
                              style: const TextStyle(color: Colors.cyanAccent, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Bar with Diamond Balance, Quantities and Send Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.black.withOpacity(0.5),
            child: Row(
              children: [
                // Diamond Balance Box
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.amber.withOpacity(0.5)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.diamond, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text('1710', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      Icon(Icons.chevron_right, color: Colors.white70, size: 16),
                    ],
                  ),
                ),
                const Spacer(),

                // Quantity selector chips
                Row(
                  children: [1, 17, 37, 57].map((qty) {
                    bool isQtySelected = selectedQuantity == qty;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedQuantity = qty;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: isQtySelected ? Colors.white : Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$qty',
                          style: TextStyle(
                            color: isQtySelected ? Colors.black : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 8),

                // Send Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  ),
                  onPressed: () {
                    if (selectedGiftName != null) {
                      widget.onSendGift(selectedGiftName!, selectedQuantity);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a gift first!'), duration: Duration(seconds: 1)),
                      );
                    }
                  },
                  child: const Text('Send', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
