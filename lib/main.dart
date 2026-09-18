Widget _buildPartyRoomsList() {
  return ListView.builder(
    padding: const EdgeInsets.all(8),
    itemCount: mockPartyRooms.length,
    itemBuilder: (ctx, i) {
      final r = mockPartyRooms[i];
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PartyAudioRoomScreen(
                room: r,
                gems: _gems,
                onGemsUpdate: (g) => setState(() => _gems = g),
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1428),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(radius: 28, backgroundImage: NetworkImage(r.avatar)),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.title,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        ...List.generate(3, (index) => Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: CircleAvatar(radius: 9, backgroundImage: NetworkImage(r.avatar)),
                        )),
                        const SizedBox(width: 4),
                        Text(
                          '🔊 ${r.onlineCount}',
                          style: const TextStyle(color: Colors.amberAccent, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.pink.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('Party', style: TextStyle(color: Colors.pinkAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 4),
                  Text('👥 ${r.membersCount} Seats', style: const TextStyle(color: Colors.white54, fontSize: 10)),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

