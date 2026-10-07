import 'package:flutter/foundation.dart';

class StreamerFollowManager {
  static final StreamerFollowManager _instance = StreamerFollowManager._internal();
  factory StreamerFollowManager() => _instance;
  StreamerFollowManager._internal();

  final Map<String, ValueNotifier<bool>> _followNotifiers = {};

  ValueNotifier<bool> getFollowNotifier(String streamerKey) {
    if (!_followNotifiers.containsKey(streamerKey)) {
      _followNotifiers[streamerKey] = ValueNotifier<bool>(false);
    }
    return _followNotifiers[streamerKey]!;
  }

  bool isFollowing(String streamerKey) {
    return getFollowNotifier(streamerKey).value;
  }

  void toggleFollow(String streamerKey) {
    final notifier = getFollowNotifier(streamerKey);
    notifier.value = !notifier.value;
  }

  void setFollowing(String streamerKey, bool status) {
    getFollowNotifier(streamerKey).value = status;
  }
}
