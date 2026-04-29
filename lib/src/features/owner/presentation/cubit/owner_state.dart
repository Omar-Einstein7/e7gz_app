import 'package:equatable/equatable.dart';
import '../../../pitches/domain/entities/pitch.dart';

enum OwnerStatus { initial, loading, success, failure }

class OwnerState extends Equatable {
  final OwnerStatus status;
  final Map<String, dynamic> stats;
  final List<Pitch> myPitches;
  final String? errorMessage;

  const OwnerState({
    this.status = OwnerStatus.initial,
    this.stats = const {},
    this.myPitches = const [],
    this.errorMessage,
  });

  OwnerState copyWith({
    OwnerStatus? status,
    Map<String, dynamic>? stats,
    List<Pitch>? myPitches,
    String? errorMessage,
  }) {
    return OwnerState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      myPitches: myPitches ?? this.myPitches,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, stats, myPitches, errorMessage];
}
