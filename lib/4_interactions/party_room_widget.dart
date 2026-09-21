import 'package:flutter/material.dart';
import '../2_auth/user_profile_model.dart';
import 'gift_sheet.dart';

class PartyRoomGridWidget extends StatefulWidget {
  const PartyRoomGridWidget({super.key});

  @override
  State<PartyRoomGridWidget> createState() => _PartyRoomGridWidgetState();
}

class _PartyRoomGridWidgetState extends State<PartyRoomGridWidget> {
  final List<String?> seats = List.filled(9, null);

  @override
  void initState() {
    super.initState();
    seats[0] = 'Host_Alpha';
  }

  void _tapSeat(int index) {
    setState(() {
      final myName = userProfile.username.isNotEmpty ? userProfile.username : 'Guest_Vibe';
      if (seats[index] == null) {
        seats[index] = myName;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Joined seat #${index + 1} ($myName)')));
      } else {
        seats[index] = null;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Left seat #${index + 1}')));
      }
    });
  }

  @override
  Widget build(context) {
    return Container(
      color: const Color(0xFF110B22),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.group, color: Colors.amber),
                const SizedBox(width: 8),
                const Text('Party Vibe Room #901', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                GestureDetector(
                  onTap: () => showGiftSendingSheet(context, 'PartyRoomHost'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.purpleAccent]), borderRadius: BorderRadius.circular(16)),
                    child: const Text('Send Gift 🎁', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.9,
              ),
              itemCount: 9,
              itemBuilder: (_, index) {
                final occupant = seats[index];
                return GestureDetector(
                  onTap: () => _tapSeat(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: occupant != null ? Colors.pinkAccent.withOpacity(0.15) : Colors.white.withOpacity(0.05),
                      border: Border.all(color: occupant != null ? Colors.pinkAccent : Colors.white24),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: occupant != null ? Colors.amber.withOpacity(0.2) : Colors.white12,
                          child: Icon(occupant != null ? Icons.mic : Icons.add, color: occupant != null ? Colors.amber : Colors.white54),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          occupant ?? 'Seat ${index + 1}\nTap to Sit',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: occupant != null ? Colors.white : Colors.white54, fontSize: 10, fontWeight: occupant != null ? FontWeight.bold : FontWeight.normal),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
