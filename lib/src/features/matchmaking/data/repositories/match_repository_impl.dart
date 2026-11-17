import 'package:e7gz/src/core/utils/task_runner.dart';
import 'package:e7gz/src/core/utils/typedefs.dart';
import 'package:e7gz/src/features/matchmaking/domain/entities/match.dart';
import 'package:e7gz/src/features/matchmaking/domain/repositories/match_repository.dart';
import 'package:e7gz/src/features/matchmaking/data/datasources/match_remote_datasource.dart';

class MatchRepositoryImpl implements MatchRepository {
  final MatchRemoteDataSource remoteDataSource;

  MatchRepositoryImpl(this.remoteDataSource);

  @override
  FutureEither<List<MatchmakingMatch>> getMatches({
    String? pitchId,
    String? date,
    String? status,
  }) {
    return runTask(
      () => remoteDataSource.getMatches(
        pitchId: pitchId,
        date: date,
        status: status,
      ),
      requiresNetwork: true,
    );
  }

  @override
  FutureEither<MatchmakingMatch> getMatchById(String id) {
    return runTask(
      () => remoteDataSource.getMatchById(id),
      requiresNetwork: true,
    );
  }

  @override
  FutureEither<MatchmakingMatch> createMatch(CreateMatchRequest request) {
    return runTask(
      () => remoteDataSource.createMatch(request),
      requiresNetwork: true,
    );
  }

  @override
  FutureEither<MatchmakingMatch> joinMatch(String id, String team) {
    return runTask(
      () => remoteDataSource.joinMatch(id, team),
      requiresNetwork: true,
    );
  }

  @override
  FutureEither<MatchmakingMatch> resolveMatch(String id, String winner) {
    return runTask(
      () => remoteDataSource.resolveMatch(id, winner),
      requiresNetwork: true,
    );
  }

  @override
  FutureEither<List<LeaderboardEntry>> getLeaderboard() {
    return runTask(() async {
      final result = await remoteDataSource.getLeaderboard();
      return result.map((e) {
        return LeaderboardEntry(
          id: e['_id']?.toString() ?? '',
          name: e['name']?.toString() ?? 'Player',
          photoUrl: e['photoUrl']?.toString(),
          wins: (e['wins'] as num?)?.toInt() ?? 0,
          losses: (e['losses'] as num?)?.toInt() ?? 0,
          matchesPlayed: (e['matchesPlayed'] as num?)?.toInt() ?? 0,
        );
      }).toList();
    }, requiresNetwork: true);
  }
}
