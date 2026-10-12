import 'package:flutter/material.dart';

class PartyRaiseHandHelper {
  static final List<Map<String, String>> raiseHandQueue = [];

  static void addRequest(String userId, String userName) {
    if (!raiseHandQueue.any((item) => item['userId'] == userId)) {
      raiseHandQueue.add({'userId': userId, 'userName': userName});
    }
  }

  static void showRaiseHandQueueDialog(BuildContext context, VoidCallback onUpdate) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1D1B36),
          title: const Text('Speaker Requests (Raise Hand)', style: TextStyle(color: Colors.white, fontSize: 16)),
          content: SizedBox(
            width: 300,
            height: 250,
            child: raiseHandQueue.isEmpty
                ? const Center(
                    child: Text('No pending requests', style: TextStyle(color: Colors.white54, fontSize: 13)),
                  )
                : ListView.builder(
                    itemCount: raiseHandQueue.length,
                    itemBuilder: (context, index) {
                      final req = raiseHandQueue[index];
                      return ListTile(
                        title: Text(req['userName'] ?? 'User', style: const TextStyle(color: Colors.white, fontSize: 14)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.greenAccent),
                              onPressed: () {
                                raiseHandQueue.removeAt(index);
                                Navigator.pop(context);
                                onUpdate();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Speaker request accepted & moved to seat!')),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.redAccent),
                              onPressed: () {
                                raiseHandQueue.removeAt(index);
                                Navigator.pop(context);
                                onUpdate();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
