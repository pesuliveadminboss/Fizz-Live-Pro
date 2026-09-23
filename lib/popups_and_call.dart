  static void showDailyRewardsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Consumer<AppState>(
        builder: (context, appState, child) {
          final dayRewards = [
            {'day': 1, 'label': 'x 40', 'icon': Icons.diamond, 'color': Colors.amberAccent},
            {'day': 2, 'label': 'x 1', 'icon': Icons.credit_card, 'color': Colors.orangeAccent},
            {'day': 3, 'label': 'x 50', 'icon': Icons.diamond, 'color': Colors.amberAccent},
            {'day': 4, 'label': 'x 90', 'icon': Icons.diamond, 'color': Colors.amberAccent},
            {'day': 5, 'label': 'x 120', 'icon': Icons.diamond, 'color': Colors.amberAccent},
            {'day': 6, 'label': 'x 180', 'icon': Icons.diamond, 'color': Colors.amberAccent},
            {'day': 7, 'label': 'x 1 (🎁 200)', 'icon': Icons.card_giftcard, 'color': Colors.pinkAccent},
          ];
          return Dialog(
            backgroundColor: const Color(0xFF1E1E2C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Daily rewards', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                          SizedBox(height: 2),
                          Text('Sign in for 7 days to get a surprise', style: TextStyle(fontSize: 11, color: Colors.white70)),
                        ],
                      ),
                      IconButton(icon: const Icon(Icons.close, color: Colors.white70, size: 20), onPressed: () => Navigator.pop(ctx)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 0.82,
                    ),
                    itemCount: dayRewards.length,
                    itemBuilder: (context, index) {
                      final item = dayRewards[index];
                      final dayNum = item['day'] as int;
                      final isSelected = dayNum == appState.currentStreakDay;
                      return Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFE94057).withOpacity(0.25) : const Color(0xFF151522),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: isSelected ? const Color(0xFFE94057) : Colors.white10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('day $dayNum', style: const TextStyle(fontSize: 9, color: Colors.white60)),
                            const Spacer(),
                            Icon(item['icon'] as IconData, size: 20, color: item['color'] as Color),
                            const Spacer(),
                            Text(item['label'] as String, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity, height: 44,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFE94057), Color(0xFFFF8E53)]),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                        onPressed: () {
                          appState.claimDailyReward();
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Daily reward claimed successfully! 🎁')));
                        },
                        child: Text(appState.claimedToday ? 'Claimed Today ✓' : 'Check-in', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

