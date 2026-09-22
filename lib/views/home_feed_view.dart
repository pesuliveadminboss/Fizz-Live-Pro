import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/fizz_core_controller.dart';
import 'live_room_view.dart';

class HomeFeedView extends StatelessWidget {
  final FizzCoreController core = Get.find<FizzCoreController>();
  final TextEditingController roomController = TextEditingController(text: "fizz_room_777");

  final List<Map<String, dynamic>> mockRooms = [
    {"roomID": "room_101", "host": "Priya_Live", "viewers": "1.4k", "thumb": "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400"},
    {"roomID": "room_102", "host": "Divya_Vibes", "viewers": "850", "thumb": "https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400"},
    {"roomID": "room_103", "host": "Anitha_Official", "viewers": "3.2k", "thumb": "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400"},
    {"roomID": "room_104", "host": "Kavi_Chat", "viewers": "620", "thumb": "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Fizz Live Pro", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF1E0B36),
        actions: [
          IconButton(
            icon: Icon(Icons.videocam, color: Color(0xFFE91E63)),
            tooltip: "Go Live",
            onPressed: () => _showGoLiveDialog(),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Trending Live Streams", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Chip(
                  label: Text("Engine: ${core.engineState.value.name.toUpperCase()}", style: TextStyle(fontSize: 10)),
                  backgroundColor: core.engineState.value == ConnectionStateEnum.connected ? Colors.green.withOpacity(0.3) : Colors.deepPurple.withOpacity(0.4),
                ),
              ],
            )),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: roomController,
                    style: TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: "Enter custom room ID...",
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.08),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE91E63),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text("Join", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    String rID = roomController.text.trim();
                    if (rID.isNotEmpty) {
                      core.startCorePlayback(rID, "stream_${rID}_test");
                      Get.to(() => LiveRoomView(roomID: rID, isHost: false));
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: mockRooms.length,
              itemBuilder: (context, index) {
                var room = mockRooms[index];
                return GestureDetector(
                  onTap: () {
                    String rID = room["roomID"];
                    core.startCorePlayback(rID, "stream_${rID}_${index}");
                    Get.to(() => LiveRoomView(roomID: rID, isHost: false));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(room["thumb"], fit: BoxFit.cover),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black87],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Color(0xFFE91E63), borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                CircleAvatar(radius: 3, backgroundColor: Colors.white),
                                SizedBox(width: 4),
                                Text("LIVE", style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)),
                            child: Text("👁️ ${room["viewers"]}", style: TextStyle(color: Colors.white, fontSize: 10)),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 12,
                          right: 12,
                          child: Text(room["host"], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
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

  void _showGoLiveDialog() {
    Get.defaultDialog(
      title: "Go Live Setup",
      titleStyle: TextStyle(color: Colors.white),
      backgroundColor: Color(0xFF1E0B36),
      content: Column(
        children: [
          TextField(
            controller: roomController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Broadcast Room ID",
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE91E63),
              minimumSize: Size(double.infinity, 45),
            ),
            child: Text("Start Live Broadcast", style: TextStyle(color: Colors.white)),
            onPressed: () {
              Get.back();
              String rID = roomController.text.trim();
              core.startCoreBroadcast(rID);
              Get.to(() => LiveRoomView(roomID: rID, isHost: true));
            },
          ),
        ],
      ),
    );
  }
}

