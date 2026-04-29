import 'package:dio/dio.dart';
import '../../../pitches/data/models/pitch_model.dart';

abstract class OwnerRemoteDataSource {
  Future<Map<String, dynamic>> getStats();
  Future<List<PitchModel>> getPitches();
}

class OwnerRemoteDataSourceImpl implements OwnerRemoteDataSource {
  final Dio dio;

  OwnerRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> getStats() async {
    final response = await dio.get('/owner/stats');
    final data = response.data as Map<String, dynamic>;
    return data['data']['stats'] ?? {};
  }

  @override
  Future<List<PitchModel>> getPitches() async {
    final response = await dio.get('/pitches/owner/my-pitches');
    final data = response.data as Map<String, dynamic>;
    final List<dynamic> pitchesData = data['data']['pitches'] ?? [];
    return pitchesData.map((p) => PitchModel.fromJson(p)).toList();
  }
}
