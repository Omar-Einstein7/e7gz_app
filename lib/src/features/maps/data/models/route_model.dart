import 'package:e7gz/src/features/maps/domain/entities/route_info.dart';

class RouteModel extends RouteInfo {
  const RouteModel({
    required super.distanceMeters,
    required super.durationSeconds,
    required super.geometry,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      distanceMeters: (json['distanceMeters'] as num?)?.toDouble() ?? 0,
      durationSeconds: (json['durationSeconds'] as num?)?.toDouble() ?? 0,
      geometry: json['geometry']?.toString() ?? '',
    );
  }
}

class GeocodedPlaceModel extends GeocodedPlace {
  const GeocodedPlaceModel({
    required super.label,
    required super.lat,
    required super.lng,
  });

  factory GeocodedPlaceModel.fromJson(Map<String, dynamic> json) {
    return GeocodedPlaceModel(
      label: json['label']?.toString() ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0,
    );
  }
}
