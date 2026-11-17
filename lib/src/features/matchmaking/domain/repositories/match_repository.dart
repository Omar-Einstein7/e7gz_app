import 'package:e7gz/src/core/utils/typedefs.dart';
import 'package:e7gz/src/features/matchmaking/domain/entities/match.dart';

abstract class MatchRepository {
  FutureEither<List<MatchmakingMatch>> getMatches({
    String? pitchId,
    String? date,
    String? status,
  });
  FutureEither<MatchmakingMatch> getMatchById(String id);
  FutureEither<MatchmakingMatch> createMatch(CreateMatchRequest request);
  FutureEither<MatchmakingMatch> joinMatch(String id, String team);
  FutureEither<MatchmakingMatch> resolveMatch(
    String id,
    String winner,
  );
  FutureEither<List<LeaderboardEntry>> getLeaderboard();
}

class LeaderboardEntry {
  final String id;
  final String name;
  final String? photoUrl;
  final int wins;
  final int losses;
  final int matchesPlayed;

  const LeaderboardEntry({
    required this.id,
    required this.name,
    this.photoUrl,
    required this.wins,
    required this.losses,
    required this.matchesPlayed,
  });
}
