class PartyRoomModel {
  final String roomID;
  final String roomName;
  final String hostName;
  final int onlineCount;
  final String theme;

  PartyRoomModel({
    required this.roomID,
    required this.roomName,
    required this.hostName,
    required this.onlineCount,
    required this.theme,
  });

  factory PartyRoomModel.fromJson(Map<String, dynamic> json) {
    return PartyRoomModel(
      roomID: json['roomID'] ?? '',
      roomName: json['roomName'] ?? '',
      hostName: json['hostName'] ?? '',
      onlineCount: json['onlineCount'] ?? 0,
      theme: json['theme'] ?? 'default',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomID': roomID,
      'roomName': roomName,
      'hostName': hostName,
      'onlineCount': onlineCount,
      'theme': theme,
    };
  }
}
