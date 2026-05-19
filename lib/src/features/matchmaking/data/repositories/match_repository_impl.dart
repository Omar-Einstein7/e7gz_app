import 'package:fpdart/fpdart.dart';
import 'package:e7gz/src/utils/failure.dart';
import '../../domain/entities/match.dart';
import '../../domain/repositories/match_repository.dart';
import '../datasources/match_remote_datasource.dart';
import '../models/match_model.dart';

class MatchRepositoryImpl implements MatchRepository {
  final MatchRemoteDataSource remoteDataSource;

  MatchRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<MatchmakingMatch>>> getMatches({
    String? pitchId,
    String? date,
    String? status,
  }) async {
    try {
      final result = await remoteDataSource.getMatches(
        pitchId: pitchId,
        date: date,
        status: status,
      );
      return right(result);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MatchmakingMatch>> getMatchById(String id) async {
    try {
      final result = await remoteDataSource.getMatchById(id);
      return right(result);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MatchmakingMatch>> createMatch(
    MatchModel match,
  ) async {
    try {
      final result = await remoteDataSource.createMatch(match);
      return right(result);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MatchmakingMatch>> joinMatch(
    String id,
    String team,
  ) async {
    try {
      final result = await remoteDataSource.joinMatch(id, team);
      return right(result);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MatchmakingMatch>> resolveMatch(
    String id,
    String winner,
  ) async {
    try {
      final result = await remoteDataSource.resolveMatch(id, winner);
      return right(result);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LeaderboardEntry>>> getLeaderboard() async {
    try {
      final result = await remoteDataSource.getLeaderboard();
      final entries = result.map((e) {
        return LeaderboardEntry(
          id: e['_id']?.toString() ?? '',
          name: e['name']?.toString() ?? 'Player',
          photoUrl: e['photoUrl']?.toString(),
          wins: (e['wins'] as num?)?.toInt() ?? 0,
          losses: (e['losses'] as num?)?.toInt() ?? 0,
          matchesPlayed: (e['matchesPlayed'] as num?)?.toInt() ?? 0,
        );
      }).toList();
      return right(entries);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
