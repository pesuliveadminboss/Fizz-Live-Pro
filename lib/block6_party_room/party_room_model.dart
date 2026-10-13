class PartyRoomModel {
  final String roomID;
  final String roomName;
  final String hostName;
  final int onlineCount;
  final String theme;
  final bool isCinematicEffectActive;

  PartyRoomModel({
    required this.roomID,
    required this.roomName,
    required this.hostName,
    required this.onlineCount,
    required this.theme,
    this.isCinematicEffectActive = true,
  });

  factory PartyRoomModel.fromJson(Map<String, dynamic> json) {
    return PartyRoomModel(
      roomID: json['roomID'] ?? '',
      roomName: json['roomName'] ?? '',
      hostName: json['hostName'] ?? '',
      onlineCount: json['onlineCount'] ?? 0,
      theme: json['theme'] ?? 'party_ship_cinematic',
      isCinematicEffectActive: json['isCinematicEffectActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomID': roomID,
      'roomName': roomName,
      'hostName': hostName,
      'onlineCount': onlineCount,
      'theme': theme,
      'isCinematicEffectActive': isCinematicEffectActive,
    };
  }
}
