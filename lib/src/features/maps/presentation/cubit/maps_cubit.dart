import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e7gz/src/features/maps/domain/usecases/maps_usecases.dart';
import 'package:e7gz/src/features/maps/presentation/cubit/maps_state.dart';

class MapsCubit extends Cubit<MapsState> {
  final GetRouteUseCase _getRoute;
  final GeocodeUseCase _geocode;
  final ReverseGeocodeUseCase _reverseGeocode;

  MapsCubit({
    required GetRouteUseCase getRoute,
    required GeocodeUseCase geocode,
    required ReverseGeocodeUseCase reverseGeocode,
  }) : _getRoute = getRoute,
       _geocode = geocode,
       _reverseGeocode = reverseGeocode,
       super(const MapsState());

  /// Fetch driving route to pitch location.
  Future<void> fetchRoute({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
    String profile = 'driving-car',
  }) async {
    emit(state.copyWith(routeStatus: MapsStatus.loading));
    final result = await _getRoute(
      fromLat: fromLat,
      fromLng: fromLng,
      toLat: toLat,
      toLng: toLng,
      profile: profile,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          routeStatus: MapsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (route) =>
          emit(state.copyWith(routeStatus: MapsStatus.success, route: route)),
    );
  }

  /// Search for places by address text.
  Future<void> search(String address) async {
    if (address.trim().isEmpty) {
      emit(
        state.copyWith(geocodeStatus: MapsStatus.initial, geocodeResults: []),
      );
      return;
    }
    emit(state.copyWith(geocodeStatus: MapsStatus.loading));
    final result = await _geocode(address);
    result.fold(
      (failure) => emit(
        state.copyWith(
          geocodeStatus: MapsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (places) => emit(
        state.copyWith(
          geocodeStatus: MapsStatus.success,
          geocodeResults: places,
        ),
      ),
    );
  }

  /// Resolve current location to an address.
  Future<String?> reverseGeocode({
    required double lat,
    required double lng,
  }) async {
    final result = await _reverseGeocode(lat: lat, lng: lng);
    return result.fold((_) => null, (place) => place?.label);
  }

  void clearRoute() =>
      emit(state.copyWith(routeStatus: MapsStatus.initial, route: null));
}
