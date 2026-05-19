import 'package:e7gz/src/features/matchmaking/domain/entities/match.dart';

class MatchModel extends MatchmakingMatch {
  final String? team;

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
    required super.participants,
    required super.teamA,
    required super.teamB,
    super.winner,
    super.cancellationReason,
    required super.pricePerPlayer,
    required super.skillLevel,
    required super.status,
    super.pitchName,
    super.pitchImage,
    required super.sportType,
    this.team,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    final dynamic pitchData = json['pitchId'];
    final Map<String, dynamic>? pitch = pitchData is Map<String, dynamic>
        ? pitchData
        : null;

    final participantList = (json['participantIds'] as List<dynamic>?) ?? [];
    final List<Participant> participants = [];
    final List<String> participantIds = [];

    for (final p in participantList) {
      if (p is Map<String, dynamic>) {
        participants.add(_parseParticipant(p));
        participantIds.add(p['_id']?.toString() ?? '');
      } else if (p is String) {
        participantIds.add(p);
      }
    }

    final teamAList = (json['teamA'] as List<dynamic>?) ?? [];
    final List<Participant> teamA = teamAList
        .whereType<Map<String, dynamic>>()
        .map(_parseParticipant)
        .toList();

    final teamBList = (json['teamB'] as List<dynamic>?) ?? [];
    final List<Participant> teamB = teamBList
        .whereType<Map<String, dynamic>>()
        .map(_parseParticipant)
        .toList();

    return MatchModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      pitchId: pitch != null
          ? (pitch['_id'] ?? '')
          : (pitchData?.toString() ?? ''),
      creatorId: _extractUserId(json['creatorId']),
      date: json['date'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      maxPlayers: (json['maxPlayers'] as num?)?.toInt() ?? 0,
      participantIds: participantIds,
      participants: participants,
      teamA: teamA,
      teamB: teamB,
      winner: json['winner'],
      cancellationReason: json['cancellationReason'],
      pricePerPlayer: (json['pricePerPlayer'] as num?)?.toDouble() ?? 0.0,
      skillLevel: json['skillLevel'] ?? 'all',
      status: json['status'] ?? 'open',
      pitchName: pitch?['name'],
      pitchImage: (pitch?['images'] as List<dynamic>?)?.isNotEmpty == true
          ? pitch!['images'][0]
          : null,
      sportType: json['sportType']?.toString() ?? 'football',
    );
  }

  static Participant _parseParticipant(Map<String, dynamic> p) {
    return Participant(
      id: p['_id']?.toString() ?? '',
      name: p['name']?.toString() ?? 'Player',
      photoUrl: p['photoUrl']?.toString(),
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
    'pricePerPlayer': pricePerPlayer,
    'sportType': sportType,
    if (team != null) 'team': team,
  };
}
