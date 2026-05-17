import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';
import 'package:e7gz/src/features/pitches/domain/usecases/pitch_usecases.dart';
import 'pitches_state.dart';

/// Manages the list of pitches with search, filter, and pagination.
class PitchesCubit extends Cubit<PitchesState> {
  final GetPitchesUseCase _getPitches;
  final GetNearbyPitchesUseCase _getNearbyPitches;

  PitchesCubit({
    required GetPitchesUseCase getPitches,
    required GetNearbyPitchesUseCase getNearbyPitches,
  }) : _getPitches = getPitches,
       _getNearbyPitches = getNearbyPitches,
       super(const PitchesState());

  // ─── Current filter cache (for pagination) ────────────────────────────────
  String? _search;
  String? _city;
  String? _sportType;
  double? _minPrice;
  double? _maxPrice;

  Future<void> loadPitches({
    String? search,
    String? city,
    String? sportType,
    double? minPrice,
    double? maxPrice,
    bool refresh = false,
  }) async {
    if (state.status == PitchesStatus.loading) return;
    if (!refresh && state.hasReachedMax) return;

    if (refresh) {
      _search = search;
      _city = city;
      _sportType = sportType;
      _minPrice = minPrice;
      _maxPrice = maxPrice;
    }

    final page = refresh ? 1 : (state.result?.page ?? 0) + 1;

    if (page == 1) {
      emit(state.copyWith(status: PitchesStatus.loading, pitches: []));
    } else {
      emit(state.copyWith(isLoadingMore: true));
    }

    final result = await _getPitches(
      search: _search,
      city: _city,
      sportType: _sportType,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      page: page,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PitchesStatus.failure,
          errorMessage: failure.message,
          isLoadingMore: false,
        ),
      ),
      (pitchResult) {
        final allPitches = page == 1
            ? pitchResult.pitches
            : [...state.pitches, ...pitchResult.pitches];
        emit(
          state.copyWith(
            status: PitchesStatus.success,
            pitches: allPitches,
            result: pitchResult,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  Future<List<Pitch>> getNearbyPitches({
    required double lat,
    required double lng,
    double radiusMeters = 5000,
  }) async {
    final result = await _getNearbyPitches(
      lat: lat,
      lng: lng,
      radiusMeters: radiusMeters,
    );
    return result.fold((_) => [], (pitches) => pitches);
  }
}

// ─── Single Pitch Detail Cubit ────────────────────────────────────────────────

class PitchDetailCubit extends Cubit<PitchDetailState> {
  final GetPitchDetailsUseCase _getPitchDetails;

  PitchDetailCubit(this._getPitchDetails) : super(const PitchDetailState());

  Future<void> loadPitch(String pitchId) async {
    emit(state.copyWith(status: PitchDetailStatus.loading));
    final result = await _getPitchDetails(pitchId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PitchDetailStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (pitch) =>
          emit(state.copyWith(status: PitchDetailStatus.success, pitch: pitch)),
    );
  }
}
