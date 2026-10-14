import 'package:flutter/material.dart';

class ZegoLiveToolsService {
  // Apply Face Beauty Filter / Mask during live streaming or video call
  static void applyBeautyFilter(int filterLevel) {
    debugPrint("Applied Zego Beauty Mask Level: $filterLevel");
  }

  // Send Virtual Gifts during Live Stream or Video Call
  static void sendGift({
    required String giftName,
    required int coinPrice,
    required String receiverName,
  }) {
    debugPrint("Gift Sent: $giftName ($coinPrice coins) to $receiverName");
  }
}
