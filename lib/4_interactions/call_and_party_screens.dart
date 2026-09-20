import 'dart:async';
import 'package:flutter/material.dart';
import '../1_core/core_data.dart';

class CustomCallScreen extends StatefulWidget {
  final String hostName;
  final int ratePerMin;
  const CustomCallScreen({super.key, required this.hostName, required this.ratePerMin});
  @override
  State<CustomCallScreen> createState() => _CustomCallScreenState();
}

class _CustomCallScreenState extends State<CustomCallScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startBilling();
  }

  void _startBilling() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      int burnPerSec = widget.ratePerMin ~/ 60;
      bool ok = globalWallet.deduct(burnPerSec);
      if (!ok) {
        _timer?.cancel();
        if (mounted) Navigator.pop(context);
      } else {
        setState(() {});
      }
    });
  }

  void _openGifts(ctx) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: AppTheme.cardDark,
      builder: (_) => Container(
        height: 180, padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Send Gift (Instant Deduction)', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () { globalWallet.deduct(50); Navigator.pop(ctx); },
                  child: const Text('Champagne 🍾 (-50 gems)'),
                ),
                ElevatedButton(
                  onPressed: () { globalWallet.deduct(900); Navigator.pop(ctx); },
                  child: const Text('Loving Girl 💃 (-900 gems)'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Zego / Live Stream Video Surface placeholder (Updated Step A)
          Positioned.fill(
            child: Container(
              color: Colors.black87,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.videocam_rounded, size: 64, color: Colors.pinkAccent),
                    SizedBox(height: 8),
                    Text('Zego RTC Live Stream Connected', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 50, left: 20, right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: globalWallet,
                  builder: (_, val, __) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                    child: Text('💎 $val gems', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                  ),
                ),
                Text(widget.hostName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Positioned(
            bottom: 40, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(icon: const Icon(Icons.card_giftcard, color: Colors.amber, size: 32), onPressed: () => _openGifts(context)),
                IconButton(icon: const Icon(Icons.call_end, color: Colors.white), style: IconButton.styleFrom(backgroundColor: Colors.red), onPressed: () => Navigator.pop(context)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PartyRoomGridWidget extends StatelessWidget {
  const PartyRoomGridWidget({super.key});

  @override
  Widget build(context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.graphic_eq, size: 64, color: AppTheme.primaryPink),
          const SizedBox(height: 12),
          const Text('Audio Party Room (5–10 Seats)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentAmber),
            onPressed: () {
              bool ok = globalWallet.deduct(500);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Joined Party Room (-500 gems entry)' : 'Insufficient gems for party room!')));
            },
            child: const Text('Join Room (-500 Gems)', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}
