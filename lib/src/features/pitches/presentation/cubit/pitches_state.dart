import 'package:equatable/equatable.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';
import 'package:e7gz/src/features/pitches/domain/repositories/pitch_repository.dart';
import 'package:e7gz/src/features/pitches/data/models/review_model.dart';

enum PitchesStatus { initial, loading, success, failure }

class PitchesState extends Equatable {
  final PitchesStatus status;
  final List<Pitch> pitches;
  final PitchListResult? result;
  final String? errorMessage;
  final bool isLoadingMore;

  const PitchesState({
    this.status = PitchesStatus.initial,
    this.pitches = const [],
    this.result,
    this.errorMessage,
    this.isLoadingMore = false,
  });

  bool get hasReachedMax =>
      result != null && result!.page >= result!.totalPages;

  PitchesState copyWith({
    PitchesStatus? status,
    List<Pitch>? pitches,
    PitchListResult? result,
    String? errorMessage,
    bool? isLoadingMore,
  }) {
    return PitchesState(
      status: status ?? this.status,
      pitches: pitches ?? this.pitches,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    status,
    pitches,
    result,
    errorMessage,
    isLoadingMore,
  ];
}

// ─── Single Pitch Detail State ────────────────────────────────────────────────

enum PitchDetailStatus { initial, loading, success, failure }

class PitchDetailState extends Equatable {
  final PitchDetailStatus status;
  final Pitch? pitch;
  final List<Review> reviews;
  final String? errorMessage;
  final bool isSubmitting;

  const PitchDetailState({
    this.status = PitchDetailStatus.initial,
    this.pitch,
    this.reviews = const [],
    this.errorMessage,
    this.isSubmitting = false,
  });

  PitchDetailState copyWith({
    PitchDetailStatus? status,
    Pitch? pitch,
    List<Review>? reviews,
    String? errorMessage,
    bool? isSubmitting,
  }) {
    return PitchDetailState(
      status: status ?? this.status,
      pitch: pitch ?? this.pitch,
      reviews: reviews ?? this.reviews,
      errorMessage: errorMessage ?? this.errorMessage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [
    status,
    pitch,
    reviews,
    errorMessage,
    isSubmitting,
  ];
}
