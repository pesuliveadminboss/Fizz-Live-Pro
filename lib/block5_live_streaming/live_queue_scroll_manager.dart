import 'package:flutter/material.dart';
import 'streamer_session_model.dart';

class LiveQueueScrollManager extends ChangeNotifier {
  final List<StreamerSessionModel> _streamersQueue = [
    StreamerSessionModel(
      streamerId: '101',
      streamerName: 'Rani Sharma',
      profileImageUrl: '',
      isBusyInCall: false,
      isLiveActive: true,
      liveStateStatus: 'Live',
    ),
    StreamerSessionModel(
      streamerId: '102',
      streamerName: 'Sonia',
      profileImageUrl: '',
      isBusyInCall: true,
      isLiveActive: false,
      liveStateStatus: 'Busy',
    ),
    StreamerSessionModel(
      streamerId: '103',
      streamerName: 'MariaSopya',
      profileImageUrl: '',
      isBusyInCall: false,
      isLiveActive: true,
      liveStateStatus: 'Live',
    ),
  ];

  int _currentIndex = 0;

  StreamerSessionModel? getCurrentActiveStreamer() {
    final activeLiveStreamers = _streamersQueue
        .where((s) => s.isLiveActive && !s.isBusyInCall)
        .toList();
        
    if (activeLiveStreamers.isEmpty) return null;
    
    if (_currentIndex >= activeLiveStreamers.length) {
      _currentIndex = 0;
    }
    return activeLiveStreamers[_currentIndex];
  }

  void switchToNextStreamer() {
    _currentIndex++;
    notifyListeners();
  }

  void updateStreamerBusyStatus(String streamerId, bool isBusy) {
    final index = _streamersQueue.indexWhere((s) => s.streamerId == streamerId);
    if (index != -1) {
      _streamersQueue[index].isBusyInCall = isBusy;
      _streamersQueue[index].liveStateStatus = isBusy ? 'Busy' : 'Live';
      notifyListeners();
    }
  }
}

