class MatchmakingMatch {
  final String id;
  final String title;
  final String location;
  final double pricePerPlayer;
  final int totalSlots;
  final int availableSlots;
  final DateTime kickoffTime;
  final String imageUrl;
  final List<String> participantIds;
  final String pitchId;

  const MatchmakingMatch({
    required this.id,
    required this.title,
    required this.location,
    required this.pricePerPlayer,
    required this.totalSlots,
    required this.availableSlots,
    required this.kickoffTime,
    required this.imageUrl,
    required this.participantIds,
    required this.pitchId,
  });

  bool get isFull => availableSlots == 0;
}
