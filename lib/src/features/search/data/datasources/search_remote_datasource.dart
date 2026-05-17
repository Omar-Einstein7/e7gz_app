import 'package:dio/dio.dart';
import '../../../pitches/data/models/pitch_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<PitchModel>> searchPitches({
    String? query,
    String? sportType,
    double? minPrice,
    double? maxPrice,
    double? rating,
    int page = 1,
    int limit = 10,
  });
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio dio;

  SearchRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PitchModel>> searchPitches({
    String? query,
    String? sportType,
    double? minPrice,
    double? maxPrice,
    double? rating,
    int page = 1,
    int limit = 10,
  }) async {
    final params = {
      if (query != null && query.isNotEmpty) 'search': query,
      if (sportType != null && sportType.isNotEmpty) 'sportType': sportType,
      if (minPrice != null) 'minPrice': minPrice,
      if (maxPrice != null) 'maxPrice': maxPrice,
      if (rating != null) 'rating': rating,
      'page': page,
      'limit': limit,
    };

    final response = await dio.get('pitches', queryParameters: params);

    final data = response.data as Map<String, dynamic>;
    final dynamic pitchesData = data['data'];
    final List<dynamic> list = (pitchesData is Map)
        ? (pitchesData['pitches'] ?? [])
        : (pitchesData is List ? pitchesData : []);

    return list.map((e) => PitchModel.fromJson(e)).toList();
  }
}
