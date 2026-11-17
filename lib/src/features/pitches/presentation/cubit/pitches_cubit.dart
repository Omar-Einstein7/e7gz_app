import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';
import 'package:e7gz/src/features/pitches/domain/usecases/pitch_usecases.dart';
import 'package:e7gz/src/features/pitches/presentation/cubit/pitches_state.dart';

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

class PitchDetailCubit extends Cubit<PitchDetailState> {
  final GetPitchDetailsUseCase _getPitchDetails;
  final GetPitchReviewsUseCase _getPitchReviews;
  final CreateReviewUseCase _createReview;

  PitchDetailCubit({
    required GetPitchDetailsUseCase getPitchDetails,
    required GetPitchReviewsUseCase getPitchReviews,
    required CreateReviewUseCase createReview,
  }) : _getPitchDetails = getPitchDetails,
       _getPitchReviews = getPitchReviews,
       _createReview = createReview,
       super(const PitchDetailState());

  Future<void> loadPitch(
    String pitchId, {
    Pitch? initialPitch,
    bool silent = false,
  }) async {
    if (initialPitch != null) {
      emit(
        state.copyWith(status: PitchDetailStatus.success, pitch: initialPitch),
      );
    } else if (!silent) {
      emit(state.copyWith(status: PitchDetailStatus.loading));
    }

    final result = await _getPitchDetails(pitchId);
    final reviewsResult = await _getPitchReviews(pitchId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PitchDetailStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (pitch) => emit(
        state.copyWith(
          status: PitchDetailStatus.success,
          pitch: pitch,
          reviews: reviewsResult.fold((_) => [], (reviews) => reviews),
        ),
      ),
    );
  }

  Future<void> submitReview({
    required String pitchId,
    required double rating,
    required String comment,
  }) async {
    emit(state.copyWith(isSubmitting: true));
    final result = await _createReview(
      pitchId: pitchId,
      rating: rating,
      comment: comment,
    );
    result.fold(
      (failure) => emit(state.copyWith(isSubmitting: false)),
      (_) {
        emit(state.copyWith(isSubmitting: false));
        loadPitch(pitchId, silent: true);
      },
    );
  }
}
