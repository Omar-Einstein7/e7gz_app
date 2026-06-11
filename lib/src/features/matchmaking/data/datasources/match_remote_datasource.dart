import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/features/matchmaking/data/models/match_model.dart';

class MatchRemoteDataSource {
  final DioService _dio;

  MatchRemoteDataSource({required DioService dioService}) : _dio = dioService;

  Future<List<MatchModel>> getMatches({
    String? pitchId,
    String? date,
    String? status,
  }) async {
    final params = <String, dynamic>{
      'pitchId': ?pitchId,
      'date': ?date,
      'status': ?status,
    };

    final result = await _dio.get('matches', queryParameters: params);
    return result.fold((failure) => throw Exception(failure.message), (
      response,
    ) {
      final data = response.data as Map<String, dynamic>;
      final matches = data['data']['matches'] as List<dynamic>;
      return matches
          .map((m) => MatchModel.fromJson(m as Map<String, dynamic>))
          .toList();
    });
  }

  Future<MatchModel> getMatchById(String id) async {
    final result = await _dio.get('matches/$id');
    return result.fold((failure) => throw Exception(failure.message), (
      response,
    ) {
      final data = response.data as Map<String, dynamic>;
      return MatchModel.fromJson(data['data']['match'] as Map<String, dynamic>);
    });
  }

  Future<MatchModel> createMatch(MatchModel match) async {
    final result = await _dio.post('matches', data: match.toJson());
    return result.fold(
      (failure) {
        // Log the detailed error from the backend if available
        if (failure.message.contains('500')) {
          AppLogger.error('BACKEND ERROR: ${failure.message}');
        }
        throw failure.message;
      },
      (response) {
        final data = response.data as Map<String, dynamic>;
        return MatchModel.fromJson(
          data['data']['match'] as Map<String, dynamic>,
        );
      },
    );
  }

  Future<MatchModel> joinMatch(String id, String team) async {
    final result = await _dio.post('matches/$id/join', data: {'team': team});
    return result.fold((failure) => throw failure.message, (response) {
      final data = response.data as Map<String, dynamic>;
      return MatchModel.fromJson(data['data']['match'] as Map<String, dynamic>);
    });
  }

  Future<MatchModel> resolveMatch(String id, String winner) async {
    final result = await _dio.post(
      'matches/$id/resolve',
      data: {'winner': winner},
    );
    return result.fold((failure) => throw failure.message, (response) {
      final data = response.data as Map<String, dynamic>;
      return MatchModel.fromJson(data['data']['match'] as Map<String, dynamic>);
    });
  }

  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    final result = await _dio.get('matches/leaderboard');
    return result.fold((failure) => throw failure.message, (response) {
      final data = response.data as Map<String, dynamic>;
      return (data['data']['leaderboard'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
    });
  }
}
