import 'package:fpdart/fpdart.dart';
import 'package:e7gz/src/utils/failure.dart';
import 'package:e7gz/src/utils/typedefs.dart';
import 'package:e7gz/src/features/maps/domain/entities/route_info.dart';
import 'package:e7gz/src/features/maps/domain/repositories/maps_repository.dart';
import '../datasources/maps_remote_datasource.dart';

class MapsRepositoryImpl implements MapsRepository {
  final MapsRemoteDataSource _remote;

  const MapsRepositoryImpl(this._remote);

  @override
  FutureEither<RouteInfo> getRoute({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
    String profile = 'driving-car',
  }) async {
    try {
      final route = await _remote.getRoute(
        fromLat: fromLat,
        fromLng: fromLng,
        toLat: toLat,
        toLng: toLng,
        profile: profile,
      );
      return right(route);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<List<GeocodedPlace>> geocode(String address) async {
    try {
      final places = await _remote.geocode(address);
      return right(places);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<GeocodedPlace?> reverseGeocode({
    required double lat,
    required double lng,
  }) async {
    try {
      final place = await _remote.reverseGeocode(lat: lat, lng: lng);
      return right(place);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
