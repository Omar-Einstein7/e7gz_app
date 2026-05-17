import 'package:equatable/equatable.dart';
import 'package:e7gz/src/features/maps/domain/entities/route_info.dart';

enum MapsStatus { initial, loading, success, failure }

class MapsState extends Equatable {
  final MapsStatus routeStatus;
  final RouteInfo? route;
  final MapsStatus geocodeStatus;
  final List<GeocodedPlace> geocodeResults;
  final String? errorMessage;

  const MapsState({
    this.routeStatus = MapsStatus.initial,
    this.route,
    this.geocodeStatus = MapsStatus.initial,
    this.geocodeResults = const [],
    this.errorMessage,
  });

  MapsState copyWith({
    MapsStatus? routeStatus,
    RouteInfo? route,
    MapsStatus? geocodeStatus,
    List<GeocodedPlace>? geocodeResults,
    String? errorMessage,
  }) {
    return MapsState(
      routeStatus: routeStatus ?? this.routeStatus,
      route: route ?? this.route,
      geocodeStatus: geocodeStatus ?? this.geocodeStatus,
      geocodeResults: geocodeResults ?? this.geocodeResults,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    routeStatus,
    route,
    geocodeStatus,
    geocodeResults,
    errorMessage,
  ];
}
