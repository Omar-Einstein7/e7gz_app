import 'package:equatable/equatable.dart';
import '../../../pitches/domain/entities/pitch.dart';

enum OwnerStatus { initial, loading, success, failure }

class OwnerState extends Equatable {
  final OwnerStatus status;
  final Map<String, dynamic> stats;
  final List<Pitch> myPitches;
  final String? errorMessage;
  final int selectedTab;
  final String refreshKey;

  const OwnerState({
    this.status = OwnerStatus.initial,
    this.stats = const {},
    this.myPitches = const [],
    this.errorMessage,
    this.selectedTab = 0,
    this.refreshKey = '',
  });

  OwnerState copyWith({
    OwnerStatus? status,
    Map<String, dynamic>? stats,
    List<Pitch>? myPitches,
    String? errorMessage,
    bool clearError = false,
    int? selectedTab,
    String? refreshKey,
  }) {
    return OwnerState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      myPitches: myPitches ?? this.myPitches,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selectedTab: selectedTab ?? this.selectedTab,
      refreshKey: refreshKey ?? this.refreshKey,
    );
  }

  @override
  List<Object?> get props => [
    status,
    stats,
    myPitches,
    errorMessage,
    selectedTab,
    refreshKey,
  ];
}
