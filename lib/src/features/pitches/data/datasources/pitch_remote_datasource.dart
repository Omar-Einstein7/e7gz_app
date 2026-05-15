import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/services/dio_service.dart';
import '../models/pitch_model.dart';
import '../models/review_model.dart';

class PitchRemoteDataSource {
  final DioService _dio;

  PitchRemoteDataSource({required DioService dioService}) : _dio = dioService;

  Future<Map<String, dynamic>> getPitches({
    String? search,
    String? city,
    String? sportType,
    double? minPrice,
    double? maxPrice,
    int page = 1,
    int limit = 10,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (search != null && search.isNotEmpty) 'search': search,
      if (city != null && city.isNotEmpty) 'city': city,
      if (sportType != null) 'sportType': sportType,
      if (minPrice != null) 'minPrice': minPrice,
      if (maxPrice != null) 'maxPrice': maxPrice,
    };

    final result = await _dio.get('pitches', queryParameters: params);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (response) => response.data as Map<String, dynamic>,
    );
  }

  Future<List<PitchModel>> getNearbyPitches({
    required double lat,
    required double lng,
    double radiusMeters = 5000,
  }) async {
    final result = await _dio.get(
      'pitches/nearby',
      queryParameters: {'lat': lat, 'lng': lng, 'radius': radiusMeters},
    );

    return result.fold((failure) => throw Exception(failure.message), (
      response,
    ) {
      final data = response.data as Map<String, dynamic>;
      final pitches = data['data']['pitches'] as List<dynamic>;
      return pitches
          .map((p) => PitchModel.fromJson(p as Map<String, dynamic>))
          .toList();
    });
  }

  Future<PitchModel> getPitchById(String id) async {
    final result = await _dio.get('pitches/$id');
    return result.fold((failure) => throw Exception(failure.message), (
      response,
    ) {
      final data = response.data as Map<String, dynamic>;
      return PitchModel.fromJson(data['data']['pitch'] as Map<String, dynamic>);
    });
  }

  Future<List<Review>> getPitchReviews(String pitchId) async {
    final result = await _dio.get('pitches/$pitchId/reviews');
    return result.fold((failure) => throw Exception(failure.message), (
      response,
    ) {
      final data = response.data as Map<String, dynamic>;
      final reviews = data['data']['reviews'] as List<dynamic>;
      return reviews
          .map((r) => Review.fromJson(r as Map<String, dynamic>))
          .toList();
    });
  }

  Future<Review> createReview({
    required String pitchId,
    required double rating,
    required String comment,
  }) async {
    final result = await _dio.post(
      'reviews',
      data: {'pitchId': pitchId, 'rating': rating, 'comment': comment},
    );
    return result.fold((failure) => throw Exception(failure.message), (
      response,
    ) {
      final data = response.data as Map<String, dynamic>;
      return Review.fromJson(data['data']['review'] as Map<String, dynamic>);
    });
  }
}
