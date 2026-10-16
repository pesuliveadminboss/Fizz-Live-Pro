import 'package:flutter/material.dart';
import 'follow_tab_model.dart';

class FollowManagerService extends ChangeNotifier {
  // Singleton instance to manage global follow state across the app
  static final FollowManagerService _instance = FollowManagerService._internal();
  factory FollowManagerService() => _instance;
  FollowManagerService._internal();

  // List of users followed in Girls/Streamers tab
  final List<FollowTabModel> _followedGirls = List.from(
    FollowTabModel.dummyFollowList.where((item) => item.category == 'girl'),
  );

  // List of users/rooms followed in Party Room tab
  final List<FollowTabModel> _followedRooms = List.from(
    FollowTabModel.dummyFollowList.where((item) => item.category == 'room'),
  );

  List<FollowTabModel> get followedGirls => _followedGirls;
  List<FollowTabModel> get followedRooms => _followedRooms;

  // Toggle or add follow status
  void toggleFollow(FollowTabModel item) {
    if (item.category == 'girl') {
      if (_followedGirls.any((element) => element.id == item.id)) {
        _followedGirls.removeWhere((element) => element.id == item.id);
      } else {
        _followedGirls.add(item);
      }
    } else {
      if (_followedRooms.any((element) => element.id == item.id)) {
        _followedRooms.removeWhere((element) => element.id == item.id);
      } else {
        _followedRooms.add(item);
      }
    }
    notifyListeners();
  }

  bool isFollowing(String id) {
    return _followedGirls.any((element) => element.id == id) ||
        _followedRooms.any((element) => element.id == id);
  }
}
