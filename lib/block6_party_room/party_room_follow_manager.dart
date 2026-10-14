import 'package:flutter/foundation.dart';
import '../block5_live_streaming/streamer_follow_manager.dart';

class PartyRoomFollowManager {
  static final PartyRoomFollowManager _instance = PartyRoomFollowManager._internal();
  factory PartyRoomFollowManager() => _instance;
  PartyRoomFollowManager._internal();

  ValueNotifier<bool> getFollowNotifier(String streamerKey) {
    return StreamerFollowManager().getFollowNotifier(streamerKey);
  }

  bool isFollowing(String streamerKey) {
    return StreamerFollowManager().isFollowing(streamerKey);
  }

  void toggleFollow(String streamerKey) {
    StreamerFollowManager().toggleFollow(streamerKey);
  }
}
