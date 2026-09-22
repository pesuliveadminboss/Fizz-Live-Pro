import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/fizz_core_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(FizzCoreController(), permanent: true);
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    home: CoreEngineTestView(),
  ));
}

class CoreEngineTestView extends StatelessWidget {
  final FizzCoreController core = Get.find<FizzCoreController>();
  final TextEditingController roomInput = TextEditingController(text: "fizz_room_777");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fizz Live Pro - Core Engine")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Obx(() => Chip(
              label: Text("State: ${core.engineState.value.name.toUpperCase()}"),
              backgroundColor: core.engineState.value == ConnectionStateEnum.connected ? Colors.green : Colors.grey[800],
            )),
            SizedBox(height: 20),
            TextField(controller: roomInput, decoration: InputDecoration(labelText: "Test Room ID", border: OutlineInputBorder())),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text("Test Go-Live"),
                    onPressed: () => core.startCoreBroadcast(roomInput.text.trim()),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: Text("Test Watch"),
                    onPressed: () => core.startCorePlayback(roomInput.text.trim(), "stream_${roomInput.text.trim()}_test"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              child: Text("Kill / Reset Session"),
              onPressed: () => core.destroySession(),
            ),
            Spacer(),
            Obx(() => core.errorMessage.value.isNotEmpty ? Text(core.errorMessage.value, style: TextStyle(color: Colors.redAccent)) : SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
