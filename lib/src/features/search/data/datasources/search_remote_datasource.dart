import 'package:dio/dio.dart';
import '../../../pitches/data/models/pitch_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<PitchModel>> searchPitches({
    String? query,
    String? sportType,
    double? minPrice,
    double? maxPrice,
    double? rating,
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
  }) async {
    final params = {
      if (query != null && query.isNotEmpty) 'search': query,
      if (query != null && query.isNotEmpty) 'city': query,
      if (sportType != null && sportType.isNotEmpty) 'sportType': sportType,
      if (minPrice != null) 'minPrice': minPrice,
      if (maxPrice != null) 'maxPrice': maxPrice,
      if (rating != null) 'rating': rating,
      'limit': 20,
    };

    final response = await dio.get('pitches', queryParameters: params);

    final data = response.data as Map<String, dynamic>;
    // Robust extraction: handle { data: { pitches: [] } } or { data: [] }
    final dynamic pitchesData = data['data'];
    final List<dynamic> list = (pitchesData is Map)
        ? (pitchesData['pitches'] ?? [])
        : (pitchesData is List ? pitchesData : []);

    return list.map((e) => PitchModel.fromJson(e)).toList();
  }
}
