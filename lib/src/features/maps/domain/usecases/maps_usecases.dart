import 'package:e7gz/src/utils/typedefs.dart';
import '../entities/route_info.dart';
import '../repositories/maps_repository.dart';

class GetRouteUseCase {
  final MapsRepository _repository;
  const GetRouteUseCase(this._repository);

  FutureEither<RouteInfo> call({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
    String profile = 'driving-car',
  }) => _repository.getRoute(
    fromLat: fromLat,
    fromLng: fromLng,
    toLat: toLat,
    toLng: toLng,
    profile: profile,
  );
}

class GeocodeUseCase {
  final MapsRepository _repository;
  const GeocodeUseCase(this._repository);

  FutureEither<List<GeocodedPlace>> call(String address) =>
      _repository.geocode(address);
}

class ReverseGeocodeUseCase {
  final MapsRepository _repository;
  const ReverseGeocodeUseCase(this._repository);

  FutureEither<GeocodedPlace?> call({
    required double lat,
    required double lng,
  }) => _repository.reverseGeocode(lat: lat, lng: lng);
}
