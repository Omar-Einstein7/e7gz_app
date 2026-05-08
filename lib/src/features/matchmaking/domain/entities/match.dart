class Participant {
  final String id;
  final String name;
  final String? photoUrl;

  const Participant({required this.id, required this.name, this.photoUrl});
}

class MatchmakingMatch {
  final String id;
  final String title;
  final String pitchId;
  final String creatorId;
  final String date;
  final String startTime;
  final String endTime;
  final int maxPlayers;
  final List<String> participantIds;
  final List<Participant> participants; // Added this
  final double pricePerPlayer;
  final String skillLevel;
  final String status;
  final String? pitchName;
  final String? pitchImage;

  const MatchmakingMatch({
    required this.id,
    required this.title,
    required this.pitchId,
    required this.creatorId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.maxPlayers,
    required this.participantIds,
    this.participants = const [], // Added this
    required this.pricePerPlayer,
    required this.skillLevel,
    required this.status,
    this.pitchName,
    this.pitchImage,
  });

  bool get isFull => participantIds.length >= maxPlayers;
  int get slotsLeft => maxPlayers - participantIds.length;
}
