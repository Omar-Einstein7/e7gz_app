import 'package:e7gz/src/core/utils/task_runner.dart';
import 'package:e7gz/src/core/utils/typedefs.dart';
import 'package:e7gz/src/features/maps/domain/entities/route_info.dart';
import 'package:e7gz/src/features/maps/domain/repositories/maps_repository.dart';
import 'package:e7gz/src/features/maps/data/datasources/maps_remote_datasource.dart';

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
  }) {
    return runTask(
      () => _remote.getRoute(
        fromLat: fromLat,
        fromLng: fromLng,
        toLat: toLat,
        toLng: toLng,
        profile: profile,
      ),
      requiresNetwork: true,
    );
  }

  @override
  FutureEither<List<GeocodedPlace>> geocode(String address) {
    return runTask(() => _remote.geocode(address), requiresNetwork: true);
  }

  @override
  FutureEither<GeocodedPlace?> reverseGeocode({
    required double lat,
    required double lng,
  }) {
    return runTask(
      () => _remote.reverseGeocode(lat: lat, lng: lng),
      requiresNetwork: true,
    );
  }
}
