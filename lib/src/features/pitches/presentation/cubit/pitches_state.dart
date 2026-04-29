import 'package:equatable/equatable.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';
import 'package:e7gz/src/features/pitches/domain/repositories/pitch_repository.dart';

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
  List<Object?> get props =>
      [status, pitches, result, errorMessage, isLoadingMore];
}

// ─── Single Pitch Detail State ────────────────────────────────────────────────

enum PitchDetailStatus { initial, loading, success, failure }

class PitchDetailState extends Equatable {
  final PitchDetailStatus status;
  final Pitch? pitch;
  final String? errorMessage;

  const PitchDetailState({
    this.status = PitchDetailStatus.initial,
    this.pitch,
    this.errorMessage,
  });

  PitchDetailState copyWith({
    PitchDetailStatus? status,
    Pitch? pitch,
    String? errorMessage,
  }) {
    return PitchDetailState(
      status: status ?? this.status,
      pitch: pitch ?? this.pitch,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, pitch, errorMessage];
}
