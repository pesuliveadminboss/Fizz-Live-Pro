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
  String selectedCategory = 'Hot';
  Map<String, dynamic>? selectedGift;
  int selectedQuantity = 1;
  final int userDiamondBalance = 1710;

  final Map<String, List<Map<String, dynamic>>> giftCategories = {
    'Hot': [
      {'name': 'Ferris Wheel', 'price': 277000},
      {'name': 'DJ music', 'price': 53500},
      {'name': 'Musical Note', 'price': 2},
      {'name': 'Hammer', 'price': 180},
      {'name': 'Tomato', 'price': 180},
      {'name': 'Egg', 'price': 180},
      {'name': 'Chili', 'price': 180},
      {'name': 'Rose', 'price': 180},
    ],
    'Lucky': [
      {'name': 'Starship', 'price': 6666},
      {'name': 'Giant Feast', 'price': 9999},
      {'name': 'Bell', 'price': 180},
      {'name': 'Like', 'price': 1000},
      {'name': 'One piece', 'price': 5000},
      {'name': 'Mystery Box', 'price': 360},
      {'name': 'Bomb', 'price': 180},
      {'name': 'Puppy', 'price': 180},
      {'name': 'Slippers', 'price': 180},
    ],
    'Svip': [
      {'name': 'Festival of...', 'price': 10000},
      {'name': 'Crown', 'price': 3000},
      {'name': 'Jasmine G...', 'price': 4000},
      {'name': 'Masala Chai', 'price': 1000},
      {'name': 'Samosa', 'price': 1000},
      {'name': 'Bollywood...', 'price': 80000},
      {'name': 'Taj Mahal', 'price': 100000},
    ],
    'Intimacy': [
      {'name': 'Flower girl', 'price': 17700},
      {'name': 'Heart Deck', 'price': 2},
      {'name': 'Winged C...', 'price': 700},
      {'name': 'Magic Set', 'price': 3700},
      {'name': 'Pool Table', 'price': 17000},
      {'name': 'Queen of...', 'price': 97000},
      {'name': 'Swan Tea', 'price': 1700},
      {'name': 'Lipstick', 'price': 2},
      {'name': 'Bracelet', 'price': 770},
    ],
    'Wealth': [
      {'name': 'Exclusive Car', 'price': 339900},
      {'name': 'Wealth Castle', 'price': 995800},
      {'name': 'Star Wand', 'price': 798000},
      {'name': 'Love Jet', 'price': 550000},
      {'name': 'Rocket', 'price': 4158000},
    ],
    'Festival': [
      {'name': 'Cute Love', 'price': 890},
      {'name': 'Flower Heart', 'price': 3990},
      {'name': 'Love Galaxy', 'price': 17000},
      {'name': 'Valentine Wish', 'price': 57000},
      {'name': '2026', 'price': 2},
      {'name': 'New Year Cheers', 'price': 890},
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
    final int giftUnitPrice = selectedGift != null ? (selectedGift!['price'] as int) : 0;
    final int totalRequiredDiamonds = giftUnitPrice * selectedQuantity;

    return Container(
      height: 420,
      decoration: const BoxDecoration(
        color: Color(0xFF161224),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                        selectedGift = null;
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
                            width: 16,
                            decoration: BoxDecoration(
                              color: Colors.white,
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
          const Divider(color: Colors.white12, height: 1),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.82,
              ),
              itemCount: gifts.length,
              itemBuilder: (context, index) {
                final gift = gifts[index];
                bool isSelected = selectedGift?['name'] == gift['name'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGift = gift;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.pinkAccent.withOpacity(0.25) : Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.pinkAccent : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.card_giftcard, color: Colors.amberAccent, size: 26),
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
                            const Icon(Icons.diamond, color: Colors.amber, size: 10),
                            const SizedBox(width: 3),
                            Text(
                              '${gift['price']}',
                              style: const TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold),
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
            color: Colors.black.withOpacity(0.6),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.diamond, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text('$userDiamondBalance', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      const Icon(Icons.chevron_right, color: Colors.white70, size: 16),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  children: [1, 77, 177].map((qty) {
                    bool isQtySelected = selectedQuantity == qty;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedQuantity = qty;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isQtySelected ? Colors.white24 : Colors.white10,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          '$qty',
                          style: TextStyle(
                            color: isQtySelected ? Colors.white : Colors.white60,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    if (selectedGift !=.null) {
                      if (userDiamondBalance >= totalRequiredDiamonds) {
                        widget.onSendGift(selectedGift!['name'], selectedQuantity);
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Insufficient Diamonds!'), duration: Duration(seconds: 1)),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a gift first!'), duration: Duration(seconds: 1)),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.pinkAccent, Colors.purpleAccent],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      totalRequiredDiamonds > 0 ? 'Send ($totalRequiredDiamonds)' : 'Send',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
