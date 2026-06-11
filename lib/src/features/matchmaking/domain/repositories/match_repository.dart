import 'package:fpdart/fpdart.dart';
import 'package:e7gz/src/utils/failure.dart';
import 'package:e7gz/src/features/matchmaking/domain/entities/match.dart';
import 'package:e7gz/src/features/matchmaking/data/models/match_model.dart';

abstract class MatchRepository {
  Future<Either<Failure, List<MatchmakingMatch>>> getMatches({
    String? pitchId,
    String? date,
    String? status,
  });
  Future<Either<Failure, MatchmakingMatch>> getMatchById(String id);
  Future<Either<Failure, MatchmakingMatch>> createMatch(MatchModel match);
  Future<Either<Failure, MatchmakingMatch>> joinMatch(String id, String team);
  Future<Either<Failure, MatchmakingMatch>> resolveMatch(
    String id,
    String winner,
  );
  Future<Either<Failure, List<LeaderboardEntry>>> getLeaderboard();
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
