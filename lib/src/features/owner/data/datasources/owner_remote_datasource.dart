import 'package:dio/dio.dart';
import '../../../pitches/data/models/pitch_model.dart';

abstract class OwnerRemoteDataSource {
  Future<Map<String, dynamic>> getStats();
  Future<List<PitchModel>> getPitches();
  Future<void> deletePitch(String pitchId);
}

class OwnerRemoteDataSourceImpl implements OwnerRemoteDataSource {
  final Dio dio;

  OwnerRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> getStats() async {
    final response = await dio.get<dynamic>('owner/stats');
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final inner = data['data'];
      if (inner is Map<String, dynamic>) {
        return (inner['stats'] as Map<String, dynamic>?) ?? {};
      }
    }
    return {};
  }

  @override
  Future<List<PitchModel>> getPitches() async {
    final response = await dio.get<dynamic>('pitches/owner/my-pitches');
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final inner = data['data'];
      if (inner is Map<String, dynamic>) {
        final pitchesData = inner['pitches'] as List<dynamic>? ?? [];
        return pitchesData
            .map((p) => PitchModel.fromJson(p as Map<String, dynamic>))
            .toList();
      }
      if (inner is List<dynamic>) {
        return inner
            .map((p) => PitchModel.fromJson(p as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }

  @override
  Future<void> deletePitch(String pitchId) async {
    await dio.delete<dynamic>('pitches/$pitchId');
  }
}
