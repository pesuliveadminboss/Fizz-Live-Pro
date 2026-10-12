import 'package:flutter/material.dart';
import 'party_room_model.dart';

class PartyRoomSummaryScreen extends StatelessWidget {
  final PartyRoom room;
  final int durationMinutes;
  final int totalGiftsReceived;
  final int gemsEarned;

  const PartyRoomSummaryScreen({
    super.key,
    required this.room,
    required this.durationMinutes,
    required this.totalGiftsReceived,
    required this.gemsEarned,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121026),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1B36),
        title: const Text('Room Summary Analytics', style: TextStyle(color: Colors.white, fontSize: 16)),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 35,
              backgroundColor: Colors.pinkAccent,
              child: Icon(Icons.celebration, color: Colors.white, size: 35),
            ),
            const SizedBox(height: 12),
            Text(
              room.roomName,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text('Party Session Ended Successfully', style: TextStyle(color: Colors.cyanAccent, fontSize: 13)),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1D1B36),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  _buildSummaryRow('Duration', '$durationMinutes Minutes'),
                  const Divider(color: Colors.white24),
                  _buildSummaryRow('Peak Listeners / Online', '${room.onlineCount} Users'),
                  const Divider(color: Colors.white24),
                  _buildSummaryRow('Total Gifts Received', '$totalGiftsReceived Gifts'),
                  const Divider(color: Colors.white24),
                  _buildSummaryRow('Gems Earned', '$gemsEarned Gems'),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Back to Home', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

