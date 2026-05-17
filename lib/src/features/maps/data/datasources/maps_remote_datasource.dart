import 'package:e7gz/src/services/dio_service.dart';
import '../models/route_model.dart';

/// Proxies all map operations through our Node.js backend
/// which in turn calls OpenRouteService.
class MapsRemoteDataSource {
  final DioService _dio;

  MapsRemoteDataSource({required DioService dioService}) : _dio = dioService;

  Future<RouteModel> getRoute({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
    String profile = 'driving-car',
  }) async {
    final result = await _dio.get(
      '/maps/route',
      queryParameters: {
        'fromLat': fromLat,
        'fromLng': fromLng,
        'toLat': toLat,
        'toLng': toLng,
        'profile': profile,
      },
    );
    return result.fold((failure) => throw Exception(failure.message), (
      response,
    ) {
      final data = response.data as Map<String, dynamic>;
      return RouteModel.fromJson(data['data'] as Map<String, dynamic>);
    });
  }

  Future<List<GeocodedPlaceModel>> geocode(String address) async {
    final result = await _dio.get(
      '/maps/geocode',
      queryParameters: {'address': address},
    );
    return result.fold((failure) => throw Exception(failure.message), (
      response,
    ) {
      final data = response.data as Map<String, dynamic>;
      final results = data['data']['results'] as List<dynamic>? ?? [];
      return results
          .map((r) => GeocodedPlaceModel.fromJson(r as Map<String, dynamic>))
          .toList();
    });
  }

  Future<GeocodedPlaceModel?> reverseGeocode({
    required double lat,
    required double lng,
  }) async {
    final result = await _dio.get(
      '/maps/reverse-geocode',
      queryParameters: {'lat': lat, 'lng': lng},
    );
    return result.fold((failure) => throw Exception(failure.message), (
      response,
    ) {
      final data = response.data as Map<String, dynamic>;
      final inner = data['data'] as Map<String, dynamic>?;
      if (inner == null || inner['address'] == null) return null;
      return GeocodedPlaceModel(
        label: inner['address'].toString(),
        lat: lat,
        lng: lng,
      );
    });
  }
}
