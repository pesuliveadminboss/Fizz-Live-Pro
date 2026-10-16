class StreamerSessionModel {
  final String streamerId;
  final String streamerName;
  final String profileImageUrl;
  bool isBusyInCall;
  bool isLiveActive;
  String liveStateStatus; // 'Live', 'Busy', 'Offline'

  StreamerSessionModel({
    required this.streamerId,
    required this.streamerName,
    required this.profileImageUrl,
    required this.isBusyInCall,
    required this.isLiveActive,
    required this.liveStateStatus,
  });
}
