import 'package:e7gz/src/features/matchmaking/domain/entities/match.dart';

class MatchModel extends MatchmakingMatch {
  const MatchModel({
    required super.id,
    required super.title,
    required super.pitchId,
    required super.creatorId,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.maxPlayers,
    required super.participantIds,
    required super.pricePerPlayer,
    required super.skillLevel,
    required super.status,
    super.pitchName,
    super.pitchImage,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    final pitch = json['pitchId'] as Map<String, dynamic>?;
    
    return MatchModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      pitchId: pitch != null ? (pitch['_id'] ?? '') : (json['pitchId'] ?? ''),
      creatorId: _extractUserId(json['creatorId']),
      date: json['date'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      maxPlayers: (json['maxPlayers'] as num?)?.toInt() ?? 0,
      participantIds: (json['participantIds'] as List<dynamic>?)
              ?.map((p) => _extractUserId(p))
              .toList() ??
          [],
      pricePerPlayer: (json['pricePerPlayer'] as num?)?.toDouble() ?? 0.0,
      skillLevel: json['skillLevel'] ?? 'all',
      status: json['status'] ?? 'open',
      pitchName: pitch?['name'],
      pitchImage: (pitch?['images'] as List<dynamic>?)?.isNotEmpty == true 
          ? pitch!['images'][0] 
          : null,
    );
  }

  static String _extractUserId(dynamic user) {
    if (user == null) return '';
    if (user is String) return user;
    if (user is Map) return user['_id']?.toString() ?? '';
    return '';
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'pitchId': pitchId,
        'date': date,
        'startTime': startTime,
        'endTime': endTime,
        'maxPlayers': maxPlayers,
        'skillLevel': skillLevel,
      };
}
