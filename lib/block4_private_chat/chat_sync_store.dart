import 'package:flutter/material.dart';
import '../block2_navigation_shell/streamer_model_data.dart';
import '../block3_hot_tab/streamer_profile_model.dart';

class ChatSyncStore {
  ChatSyncStore._internal();
  static final ChatSyncStore instance = ChatSyncStore._internal();

  final Map<String, dynamic> _threads = {};

  ValueNotifier threadNotifierFor(String peerName) {
    final key = peerName.trim().toLowerCase();
    if (!_threads.containsKey(key)) {
      _threads[key] = ValueNotifier([
        {
          'sender': 'streamer',
          'text': 'Hi! Welcome to my private chat ✨',
          'type': 'text',
        },
      ]);
    }
    return _threads[key] as ValueNotifier;
  }

  void addMessage(
    String peerName, {
    required String sender,
    required String text,
    String type = 'text',
  }) {
    final notifier = threadNotifierFor(peerName);
    final currentList = List.from(notifier.value as List);
    currentList.add({
      'sender': sender,
      'text': text,
      'type': type,
    });
    notifier.value = currentList;
  }

  String lastMessagePreview(String peerName) {
    final list = threadNotifierFor(peerName).value as List;
    if (list.isEmpty) return 'Tap to start private chat';
    final lastItem = list.last as Map;
    return (lastItem['text'] as String?) ?? 'Tap to start private chat';
  }

  StreamerProfileModel profileFromStreamer(StreamerItem item) {
    return StreamerProfileModel(
      id: item.id,
      name: item.name,
      country: item.country,
      flag: item.flag,
      age: item.age,
      status: item.status,
      intro: item.intro,
      language: item.language,
      isVerified: true,
    );
  }
}
