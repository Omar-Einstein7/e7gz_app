import 'package:e7gz/src/utils/typedefs.dart';
import '../entities/route_info.dart';

abstract class MapsRepository {
  /// Get a driving route between two coordinates.
  FutureEither<RouteInfo> getRoute({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
    String profile, // driving-car | cycling | foot-walking
  });

  /// Forward geocode an address string to coordinates.
  FutureEither<List<GeocodedPlace>> geocode(String address);

  /// Reverse geocode a coordinate to an address.
  FutureEither<GeocodedPlace?> reverseGeocode({
    required double lat,
    required double lng,
  });
}
