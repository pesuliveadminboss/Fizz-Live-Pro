import 'package:flutter/material.dart';

class GiftBottomSheet extends StatefulWidget {
  final Function(String, int) onSendGift;

  const GiftBottomSheet({super.key, required this.onSendGift});

  @override
  State<GiftBottomSheet> createState() => _GiftBottomSheetState();
}

class _GiftBottomSheetState extends State<GiftBottomSheet> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedQuantity = 1;
  String selectedGiftName = 'Mystery Box';
  int selectedGiftPrice = 360;

  final List<String> categories = ['Hot', 'Lucky', 'Svip', 'Intimacy', 'Wealth', 'Festival', 'Bag'];

  final Map<String, List<Map<String, dynamic>>> giftData = {
    'Hot': [
      {'name': 'Prayer Book', 'price': 137700, 'icon': Icons.menu_book, 'color': Colors.amberAccent},
      {'name': 'Romantic...', 'price': 100000, 'icon': Icons.favorite, 'color': Colors.pinkAccent},
      {'name': 'Cool Drivi...', 'price': 100000, 'icon': Icons.directions_car, 'color': Colors.blueAccent},
      {'name': 'Lambo', 'price': 200000, 'icon': Icons.local_taxi, 'color': Colors.orangeAccent},
    ],
    'Lucky': [
      {'name': 'Mystery B...', 'price': 360, 'icon': Icons.card_giftcard, 'color': Colors.amber},
      {'name': 'Bomb', 'price': 180, 'icon': Icons.local_fire_department, 'color': Colors.redAccent},
      {'name': 'Puppy', 'price': 180, 'icon': Icons.pets, 'color': Colors.orange},
      {'name': 'Hammer', 'price': 180, 'icon': Icons.build, 'color': Colors.grey},
      {'name': 'Kiss', 'price': 180, 'icon': Icons.favorite_border, 'color': Colors.pink},
      {'name': 'Chili', 'price': 180, 'icon': Icons.whatshot, 'color': Colors.red},
      {'name': 'Slippers', 'price': 180, 'icon': Icons.roller_skating, 'color': Colors.purpleAccent},
      {'name': 'Rose', 'price': 180, 'icon': Icons.local_florist, 'color': Colors.redAccent},
    ],
    'Svip': [
      {'name': 'Necklace', 'price': 1980, 'icon': Icons.diamond, 'color': Colors.cyanAccent},
      {'name': 'Mua~', 'price': 1440, 'icon': Icons.emoji_emotions, 'color': Colors.amberAccent},
      {'name': 'Sayhi', 'price': 180, 'icon': Icons.waving_hand, 'color': Colors.white70},
      {'name': 'Lollipop', 'price': 360, 'icon': Icons.icecream, 'color': Colors.pinkAccent},
    ],
    'Intimacy': [
      {'name': 'Love Book', 'price': 200, 'icon': Icons.book, 'color': Colors.purple},
      {'name': 'Paper plane', 'price': 2, 'icon': Icons.send, 'color': Colors.blue},
      {'name': 'Timeless L...', 'price': 3000, 'icon': Icons.watch, 'color': Colors.amber},
      {'name': 'I PAY', 'price': 17700, 'icon': Icons.payment, 'color': Colors.orange},
    ],
    'Wealth': [
      {'name': 'Wedding', 'price': 839000, 'icon': Icons.celebration, 'color': Colors.amberAccent},
      {'name': 'Pink Roma...', 'price': 17700, 'icon': Icons.favorite, 'color': Colors.pink},
      {'name': 'Treasure...', 'price': 2, 'icon': Icons.lock, 'color': Colors.yellow},
      {'name': 'Grand Tre...', 'price': 200, 'icon': Icons.security, 'color': Colors.orange},
    ],
    'Festival': [
      {'name': 'Dragon', 'price': 5555, 'icon': Icons.local_fire_department, 'color': Colors.red},
      {'name': 'Starship', 'price': 6666, 'icon': Icons.flight, 'color': Colors.blue},
      {'name': 'Giant Feast', 'price': 9999, 'icon': Icons.restaurant, 'color': Colors.amber},
      {'name': 'Clover', 'price': 99, 'icon': Icons.eco, 'color': Colors.green},
    ],
    'Bag': [
      {'name': 'Slot', 'price': 540, 'icon': Icons.casino, 'color': Colors.purple},
      {'name': 'Loving Ga...', 'price': 900, 'icon': Icons.people, 'color': Colors.pink},
      {'name': 'CP Kiss', 'price': 17000, 'icon': Icons.favorite, 'color': Colors.redAccent},
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      decoration: const BoxDecoration(
        color: Color(0xFF140822),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.black26,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.amberAccent,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.amberAccent,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: categories.map((cat) => Tab(text: cat)).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: categories.map((category) {
                final list = giftData[category] ?? [];
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final gift = list[index];
                    bool isSelected = selectedGiftName == gift['name'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGiftName = gift['name'];
                          selectedGiftPrice = gift['price'];
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Colors.redAccent : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(gift['icon'], color: gift['color'], size: 28),
                            const SizedBox(height: 4),
                            Text(
                              gift['name'],
                              style: const TextStyle(color: Colors.white, fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.diamond, color: Colors.amberAccent, size: 10),
                                const SizedBox(width: 2),
                                Text(
                                  '${gift['price']}',
                                  style: const TextStyle(color: Colors.amberAccent, fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
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
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.diamond, color: Colors.amberAccent, size: 16),
                      SizedBox(width: 4),
                      Text('1710 >', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      _buildQtyButton(1),
                      _buildQtyButton(77),
                      _buildQtyButton(177),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onPressed: () {
                    widget.onSendGift(selectedGiftName, selectedQuantity);
                    Navigator.pop(context);
                  },
                  child: const Text('Send', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyButton(int qty) {
    bool isSelected = selectedQuantity == qty;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedQuantity = qty;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.4) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '$qty',
          style: TextStyle(color: Colors.white, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 12),
        ),
      ),
    );
  }
}
