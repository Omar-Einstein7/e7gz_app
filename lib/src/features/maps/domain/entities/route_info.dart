import 'package:equatable/equatable.dart';

/// Route information returned from ORS via our backend proxy.
class RouteInfo extends Equatable {
  final double distanceMeters;
  final double durationSeconds;
  final String geometry; // encoded polyline from ORS

  const RouteInfo({
    required this.distanceMeters,
    required this.durationSeconds,
    required this.geometry,
  });

  /// Distance in km, rounded to 1 decimal.
  String get distanceLabel =>
      '${(distanceMeters / 1000).toStringAsFixed(1)} km';

  /// Duration formatted as "X min" or "X h Y min".
  String get durationLabel {
    final total = durationSeconds.round();
    final h = total ~/ 3600;
    final m = (total % 3600) ~/ 60;
    if (h == 0) return '$m min';
    return '${h}h ${m}min';
  }

  @override
  List<Object?> get props => [distanceMeters, durationSeconds, geometry];
}

/// Result of a geocoding search.
class GeocodedPlace extends Equatable {
  final String label;
  final double lat;
  final double lng;

  const GeocodedPlace({
    required this.label,
    required this.lat,
    required this.lng,
  });

  @override
  List<Object?> get props => [label, lat, lng];
}
