import 'package:flutter/material.dart';

class PartyRoomMembersHelper {
  // Map to store seat occupants: seatIndex -> userName
  final Map<int, String> _seatOccupants = {};

  String? getOccupant(int seatIndex) {
    return _seatOccupants[seatIndex];
  }

  bool isSeatOccupied(int seatIndex) {
    return _seatOccupants.containsKey(seatIndex) && _seatOccupants[seatIndex] != null;
  }

  void occupySeat(int seatIndex, String userName) {
    _seatOccupants[seatIndex] = userName;
  }

  void vacateSeat(int seatIndex) {
    _seatOccupants.remove(seatIndex);
  }

  // 1. Members List Dialog (from your original file)
  static void showMembersListDialog(BuildContext context, int onlineCount) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1D1B36),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Online Members ($onlineCount) 🚢',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(color: Colors.white12),
              Expanded(
                child: ListView.builder(
                  itemCount: onlineCount > 5 ? 5 : onlineCount,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.pinkAccent,
                        radius: 18,
                        child: Icon(Icons.person, color: Colors.white, size: 16),
                      ),
                      title: Text(
                        'Party Member ${index + 1}',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      subtitle: const Text(
                        'Active on Party Ship 🌊',
                        style: TextStyle(color: Colors.cyanAccent, fontSize: 11),
                      ),
                      trailing: const Icon(Icons.mic, color: Colors.greenAccent, size: 16),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 2. Seat Management Dialog (for taking or vacating seats)
  void showSeatManagementDialog(BuildContext context, int seatIndex, VoidCallback onUpdated) {
    final occupant = getOccupant(seatIndex);
    final isOccupied = occupant != null;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1D1B36),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Seat ${seatIndex + 1} Management 💺',
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.group, color: Colors.cyanAccent),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                isOccupied ? 'Current Occupant: $occupant' : 'This seat is currently empty.',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOccupied ? Colors.redAccent : Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    if (isOccupied) {
                      vacateSeat(seatIndex);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Seat ${seatIndex + 1} is now vacant.')),
                      );
                    } else {
                      occupySeat(seatIndex, 'Chandran S');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Successfully took Seat ${seatIndex + 1}!')),
                      );
                    }
                    Navigator.pop(context);
                    onUpdated();
                  },
                  child: Text(
                    isOccupied ? 'Kick / Vacate Seat' : 'Take Seat 💺',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
