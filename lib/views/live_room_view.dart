import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/fizz_core_controller.dart';

class LiveRoomView extends StatelessWidget {
  final String roomID;
  final bool isHost;
  final FizzCoreController core = Get.find<FizzCoreController>();
  final TextEditingController chatController = TextEditingController();

  LiveRoomView({required this.roomID, required this.isHost});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await core.destroySession();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.grey[900],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(isHost ? Icons.videocam : incomingOrLiveIcon(), size: 60, color: Colors.pinkAccent),
                      SizedBox(height: 12),
                      Text(
                        isHost ? "Broadcasting Room: $roomID" : "Watching Room: $roomID",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        CircleAvatar(radius: 12, backgroundColor: Colors.pink, child: Icon(Icons.person, size: 14, color: Colors.white)),
                        SizedBox(width: 8),
                        Text(isHost ? "You (Host)" : "Host_Live", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Color(0xFFE91E63), borderRadius: BorderRadius.circular(10)),
                          child: Text("LIVE", style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () async {
                      await core.destroySession();
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 140,
                    child: Obx(() => ListView.builder(
                      itemCount: core.liveMessages.length,
                      itemBuilder: (context, index) {
                        var msg = core.liveMessages[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(text: "${msg['sender']}: ", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
                                TextSpan(text: msg['text'] ?? '', style: TextStyle(color: Colors.white, fontSize: 12)),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: chatController,
                          style: TextStyle(color: Colors.white, fontSize: 13),
                          decoration: InputDecoration(
                            hintText: "Say something nice...",
                            hintStyle: TextStyle(color: Colors.white60),
                            filled: true,
                            fillColor: Colors.black54,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.send, color: Color(0xFFE91E63)),
                        onPressed: () {
                          if (chatController.text.trim().isNotEmpty) {
                            core.appendCoreLog("You", chatController.text.trim());
                            chatController.clear();
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.card_giftcard, color: Colors.amber),
                        onPressed: () {
                          core.appendCoreLog("System", "🎁 You sent a Diamond Rose to Host!");
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData incomingOrLiveIcon() => Icons.live_tv;
}
