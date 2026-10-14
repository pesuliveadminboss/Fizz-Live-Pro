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
  String selectedCategory = 'Lucky';
  String? selectedGiftName;
  int selectedQuantity = 1;

  final Map<String, List<Map<String, dynamic>>> giftCategories = {
    'Lucky': [
      {'name': 'Starship', 'price': 6666},
      {'name': 'Giant Feast', 'price': 9999},
      {'name': 'Bell', 'price': 180},
      {'name': 'Like', 'price': 1000},
      {'name': 'One piece', 'price': 5000},
      {'name': 'Mystery Box', 'price': 360},
      {'name': 'Bomb', 'price': 180},
      {'name': 'Puppy', 'price': 180},
      {'name': 'Hammer', 'price': 180},
      {'name': 'Kiss', 'price': 180},
      {'name': 'Chili', 'price': 180},
      {'name': 'Slippers', 'price': 180},
      {'name': 'Rose', 'price': 180},
    ],
    'Svip': [
      {'name': 'Festival of...', 'price': 10000},
      {'name': 'Crown', 'price': 3000},
      {'name': 'Jasmine G...', 'price': 4000},
      {'name': 'Masala Chai', 'price': 1000},
      {'name': 'Samosa', 'price': 1000},
      {'name': 'Forever R...', 'price': 1000},
      {'name': 'Bollywood...', 'price': 80000},
      {'name': 'Taj Mahal', 'price': 100000},
      {'name': 'Royal Elep...', 'price': 500000},
      {'name': 'Sky Castle', 'price': 300000},
      {'name': 'Bengal Tig...', 'price': 100000},
      {'name': 'Luxury Co...', 'price': 50000},
      {'name': 'Peacock...', 'price': 10000},
      {'name': 'Lassi', 'price': 500},
    ],
    'Intimacy': [
      {'name': 'Flower girl', 'price': 17700},
      {'name': 'Heart Deck', 'price': 2},
      {'name': 'Winged C...', 'price': 700},
      {'name': 'Magic Set', 'price': 3700},
      {'name': 'Pool Table', 'price': 17000},
      {'name': 'Queen of...', 'price': 97000},
      {'name': 'Swan Tea', 'price': 1700},
      {'name': 'foral love', 'price': 2},
      {'name': 'Lipstick', 'price': 2},
      {'name': 'Bracelet', 'price': 770},
      {'name': 'Perfume', 'price': 3770},
      {'name': 'Shopping...', 'price': 27770},
      {'name': 'VIP Collec...', 'price': 77700},
      {'name': 'Pearl Dress', 'price': 82770},
      {'name': 'Tulip Ring', 'price': 100000},
      {'name': 'Manor Tea...', 'price': 27770},
      {'name': 'Sky Roma...', 'price': 17000},
      {'name': 'I am cool', 'price': 57000},
      {'name': 'Love letter', 'price': 2},
      {'name': 'Airplane', 'price': 2},
      {'name': 'Pink rose', 'price': 2},
      {'name': 'Shining Ri...', 'price': 200},
      {'name': 'Together I...', 'price': 19700},
      {'name': 'Gift car', 'price': 3000},
      {'name': 'Timeless L...', 'price': 3000},
      {'name': 'I PAY', 'price': 17700},
      {'name': 'Memory I...', 'price': 37000},
      {'name': 'Diamond...', 'price': 17700},
      {'name': 'Luxury Air...', 'price': 57000},
      {'name': 'Air travel', 'price': 890},
      {'name': 'Billionaire...', 'price': 3000},
      {'name': 'Memory P...', 'price': 200},
      {'name': 'Castle Pro...', 'price': 77700},
      {'name': 'CP Letter', 'price': 2},
      {'name': 'In My Han...', 'price': 300,
      'name': 'CP Walk', 'price': 3000},
      {'name': 'Run to Love', 'price': 57000},
      {'name': 'CP Kiss', 'price': 17000},
      {'name': 'Love Book', 'price': 200},
      {'name': 'Paper plane', 'price': 2},
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
    'Bag': [
      {'name': 'Linked Ring', 'price': 2},
      {'name': 'RosePerfume', 'price': 2},
      {'name': 'LoveCrown', 'price': 2},
      {'name': 'Fluttering Ring', 'price': 2},
      {'name': 'Voting', 'price': 10},
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
                      boxShadow: isSelected
                          ? [BoxShadow(color: Colors.pinkAccent.withOpacity(0.6), blurRadius: 8, spreadRadius: 1)]
                          : [],
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.black.withOpacity(0.5),
            child: Row(
              children: [
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
                                                    
