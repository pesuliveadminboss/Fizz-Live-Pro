import 'package:flutter/material.dart';
import '../1_core/core_data.dart';
import '../2_auth/user_profile_model.dart';

class GiftItem {
  final String name;
  final int gemPrice;
  final String emoji;
  final bool isBackpackFree;

  const GiftItem({
    required this.name,
    required this.gemPrice,
    required this.emoji,
    this.isBackpackFree = false,
  });
}

final Map<String, int> userBackpackInventory = {
  'Linked Ring': 2,
  'RosePerfume': 144,
  'LoveCrown': 144,
  'Fluttering...': 28,
  'Voting': 3,
};

final List<GiftItem> appGiftCatalog = [
  const GiftItem(name: 'Linked Ring', gemPrice: 2, emoji: '💍', isBackpackFree: true),
  const GiftItem(name: 'RosePerfume', gemPrice: 2, emoji: '🌹', isBackpackFree: true),
  const GiftItem(name: 'LoveCrown', gemPrice: 2, emoji: '👑', isBackpackFree: true),
  const GiftItem(name: 'Fluttering...', gemPrice: 2, emoji: '🦋', isBackpackFree: true),
  const GiftItem(name: 'Voting', gemPrice: 10, emoji: '📜', isBackpackFree: true),
  const GiftItem(name: 'Cute Love', gemPrice: 890, emoji: '💌'),
  const GiftItem(name: 'Flower Heart', gemPrice: 3990, emoji: '💐'),
  const GiftItem(name: 'Love Gala...', gemPrice: 17000, emoji: '💖'),
  const GiftItem(name: 'Valentine...', gemPrice: 57000, emoji: '🌹'),
  const GiftItem(name: 'Eid Blessing', gemPrice: 770, emoji: '🌙'),
  const GiftItem(name: 'Eid Night', gemPrice: 27770, emoji: '🕌'),
  const GiftItem(name: 'Eid Feast', gemPrice: 50770, emoji: '✨'),
  const GiftItem(name: 'Wealth Ca...', gemPrice: 995800, emoji: '🏆'),
];

void showRechargeModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF1F1A24),
      title: const Row(
        children: [
          Icon(Icons.diamond, color: Colors.amber),
          SizedBox(width: 8),
          Text('Insufficient Gems', style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
      content: const Text(
        'Your gem balance is empty or insufficient for this gift/action!',
        style: TextStyle(color: Colors.white70, fontSize: 13),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
          onPressed: () {
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Recharge Now opened! 💎 Bonus 50% active.'), duration: Duration(seconds: 3)),
            );
          },
          child: const Text('Recharge Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}

void showGiftSendingSheet(BuildContext context, String targetName) {
  String selectedCategory = 'Bag';
  int selectedQuantity = 1;
  const List<int> quantOptions =;
  

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF19112E),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (ctx) {
      return StatefulBuilder(
        builder: (BuildContext modalCtx, StateSetter setStateModal) {
          final categories = ['Hot', 'Lucky', 'Svip', 'Intimacy', 'Wealth', 'Festival', 'Bag'];
          final displayedGifts = selectedCategory == 'Bag'
              ? appGiftCatalog.where((g) => g.isBackpackFree).toList()
              : appGiftCatalog.where((g) => !g.isBackpackFree).toList();

          GiftItem? selectedGift = displayedGifts.isNotEmpty ? displayedGifts.first : null;

          return Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Send to $targetName', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    ValueListenableBuilder<int>(
                      valueListenable: globalWallet,
                      builder: (_, val, __) => Row(
                        children: [
                          const Icon(Icons.diamond, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text('$val', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                if (selectedCategory == 'Bag')
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text('The gifts in the backpack are free', style: TextStyle(color: Colors.white60, fontSize: 11)),
                  ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 32,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: categories.map((cat) {
                      final isSelected = selectedCategory == cat;
                      return GestureDetector(
                        onTap: () => setStateModal(() => selectedCategory = cat),
                        child: Container(
                          margin: const EdgeInsets.only(right: 14),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            border: isSelected ? const Border(bottom: BorderSide(color: Colors.white, width: 2)) : null,
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white.withOpacity(0.65),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 210,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: displayedGifts.length,
                    itemBuilder: (_, index) {
                      final gift = displayedGifts[index];
                      final isSelected = selectedGift?.name == gift.name;
                      final backpackCount = userBackpackInventory[gift.name] ?? 0;

                      return GestureDetector(
                        onTap: () => setStateModal(() => selectedGift = gift),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.pinkAccent.withOpacity(0.25) : Colors.white.withOpacity(0.06),
                            border: Border.all(color: isSelected ? Colors.pinkAccent : Colors.white12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: Stack(
                            children: [
                              if (gift.isBackpackFree && backpackCount > 0)
                                Positioned(
                                  top: 0, right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                    decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(8)),
                                    child: Text('$backpackCount', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(gift.emoji, style: const TextStyle(fontSize: 24)),
                                    const SizedBox(height: 4),
                                    Text(gift.name, style: const TextStyle(color: Colors.white, fontSize: 9), overflow: TextOverflow.ellipsis),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.diamond, color: Colors.amber, size: 9),
                                        const SizedBox(width: 2),
                                        Text('${gift.gemPrice}', style: const TextStyle(color: Colors.amber, fontSize: 9, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (dotIdx) => Container(
                    width: dotIdx == 0 ? 12 : 5,
                    height: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: dotIdx == 0 ? Colors.white : Colors.white24,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  )),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: quantOptions.map((qty) {
                        final isSelected = selectedQuantity == qty;
                        return GestureDetector(
                          onTap: () => setStateModal(() => selectedQuantity = qty),
                          child: Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white.withOpacity(0.2) : Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text('$qty', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                          ),
                        );
                      }).toList(),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
                      ),
                      onPressed: () {
                        if (selectedGift == null) return;
                        final totalCost = selectedGift!.gemPrice * selectedQuantity;

                        if (selectedGift!.isBackpackFree) {
                          final currentBagCount = userBackpackInventory[selectedGift!.name] ?? 0;
                          if (currentBagCount >= selectedQuantity) {
                            userBackpackInventory[selectedGift!.name] = currentBagCount - selectedQuantity;
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Sent free backpack ${selectedGift!.name} x$selectedQuantity to $targetName!')),
                            );
                          } else {
                            if (globalWallet.value >= totalCost) {
                              globalWallet.value -= totalCost;
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Sent ${selectedGift!.name} x$selectedQuantity (-$totalCost gems)')),
                              );
                            } else {
                              Navigator.pop(ctx);
                              showRechargeModal(context);
                            }
                          }
                        } else {
                          if (globalWallet.value <= 0 || globalWallet.value < totalCost) {
                            Navigator.pop(ctx);
                            showRechargeModal(context);
                          } else {
                            globalWallet.value -= totalCost;
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Sent ${selectedGift!.name} x$selectedQuantity to $targetName (-$totalCost gems)!')),
                            );
                          }
                        }
                      },
                      child: const Text('Send', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
