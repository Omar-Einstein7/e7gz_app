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
    final response = await dio.get('/pitches/search', queryParameters: {
      if (query != null) 'q': query,
      if (sportType != null) 'sportType': sportType,
      if (minPrice != null) 'minPrice': minPrice,
      if (maxPrice != null) 'maxPrice': maxPrice,
      if (rating != null) 'rating': rating,
    });
    
    final data = response.data as Map<String, dynamic>;
    final List<dynamic> list = data['data']['pitches'] ?? data['data'] ?? [];
    return list.map((e) => PitchModel.fromJson(e)).toList();
  }
}
