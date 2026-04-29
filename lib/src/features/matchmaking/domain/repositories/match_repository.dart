import 'package:fpdart/fpdart.dart';
import '../../../../utils/failure.dart';
import '../entities/match.dart';
import '../../data/models/match_model.dart';

abstract class MatchRepository {
  Future<Either<Failure, List<MatchmakingMatch>>> getMatches({
    String? pitchId,
    String? date,
    String? status,
  });
  Future<Either<Failure, MatchmakingMatch>> getMatchById(String id);
  Future<Either<Failure, MatchmakingMatch>> createMatch(MatchModel match);
  Future<Either<Failure, MatchmakingMatch>> joinMatch(String id);
}
