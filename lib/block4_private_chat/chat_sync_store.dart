import 'package:flutter/material.dart';
import '../block2_navigation_shell/streamer_model_data.dart';
import '../block3_hot_tab/streamer_profile_model.dart';

typedef ChatMessageItem = Map<String, dynamic>;
typedef ChatMessageList = List<ChatMessageItem>;

class ChatSyncStore {
  ChatSyncStore._internal();
  static final ChatSyncStore instance = ChatSyncStore._internal();

  final Map<String, ValueNotifier<ChatMessageList>> _threads = {};

  ValueNotifier<ChatMessageList> threadNotifierFor(String peerName) {
    final key = peerName.trim().toLowerCase();
    return _threads.putIfAbsent(
      key,
      () => ValueNotifier<ChatMessageList>(
        [
          {
            'sender': 'streamer',
            'text': 'Hi! Welcome to my private chat ✨',
            'type': 'text',
          },
        ],
      ),
    );
  }

  void addMessage(
    String peerName, {
    required String sender,
    required String text,
    String type = 'text',
  }) {
    final notifier = threadNotifierFor(peerName);
    final ChatMessageList updated = List<ChatMessageItem>.from(notifier.value);
    updated.add({
      'sender': sender,
      'text': text,
      'type': type,
    });
    notifier.value = updated;
  }

  String lastMessagePreview(String peerName) {
    final ChatMessageList list = threadNotifierFor(peerName).value;
    if (list.isEmpty) return 'Tap to start private chat';
    return (list.last['text'] as String?) ?? 'Tap to start private chat';
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
