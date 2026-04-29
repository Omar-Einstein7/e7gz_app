import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/services/dio_service.dart';
import '../models/match_model.dart';

class MatchRemoteDataSource {
  final DioService _dio = DioService.instance;

  Future<List<MatchModel>> getMatches({
    String? pitchId,
    String? date,
    String? status,
  }) async {
    final params = <String, dynamic>{
      if (pitchId != null) 'pitchId': pitchId,
      if (date != null) 'date': date,
      if (status != null) 'status': status,
    };

    final result = await _dio.get('/matches', queryParameters: params);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (response) {
        final data = response.data as Map<String, dynamic>;
        final matches = data['data']['matches'] as List<dynamic>;
        return matches
            .map((m) => MatchModel.fromJson(m as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<MatchModel> getMatchById(String id) async {
    final result = await _dio.get('/matches/$id');
    return result.fold(
      (failure) => throw Exception(failure.message),
      (response) {
        final data = response.data as Map<String, dynamic>;
        return MatchModel.fromJson(
            data['data']['match'] as Map<String, dynamic>);
      },
    );
  }

  Future<MatchModel> createMatch(MatchModel match) async {
    final result = await _dio.post('/matches', data: match.toJson());
    return result.fold(
      (failure) => throw Exception(failure.message),
      (response) {
        final data = response.data as Map<String, dynamic>;
        return MatchModel.fromJson(
            data['data']['match'] as Map<String, dynamic>);
      },
    );
  }

  Future<MatchModel> joinMatch(String id) async {
    final result = await _dio.post('/matches/$id/join');
    return result.fold(
      (failure) => throw Exception(failure.message),
      (response) {
        final data = response.data as Map<String, dynamic>;
        return MatchModel.fromJson(
            data['data']['match'] as Map<String, dynamic>);
      },
    );
  }
}
