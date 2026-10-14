import 'package:flutter/foundation.dart';

class PartyRoomFollowManager {
  static final PartyRoomFollowManager _instance = PartyRoomFollowManager._internal();
  factory PartyRoomFollowManager() => _instance;
  PartyRoomFollowManager._internal();

  final ValueNotifier<bool> isFollowingNotifier = ValueNotifier<bool>(false);

  bool get isFollowing => isFollowingNotifier.value;

  void toggleFollow() {
    isFollowingNotifier.value = !isFollowingNotifier.value;
  }

  void setFollowing(bool status) {
    isFollowingNotifier.value = status;
  }
}

