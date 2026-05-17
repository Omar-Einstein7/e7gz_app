import 'package:equatable/equatable.dart';
import '../../domain/entities/match.dart';

enum MatchmakingStatus { initial, loading, success, failure }

class MatchmakingState extends Equatable {
  final MatchmakingStatus status;
  final MatchmakingStatus singleMatchStatus;
  final List<MatchmakingMatch> matches;
  final MatchmakingMatch? selectedMatch;
  final String? errorMessage;

  const MatchmakingState({
    this.status = MatchmakingStatus.initial,
    this.singleMatchStatus = MatchmakingStatus.initial,
    this.matches = const [],
    this.selectedMatch,
    this.errorMessage,
  });

  MatchmakingState copyWith({
    MatchmakingStatus? status,
    MatchmakingStatus? singleMatchStatus,
    List<MatchmakingMatch>? matches,
    MatchmakingMatch? selectedMatch,
    String? errorMessage,
  }) {
    return MatchmakingState(
      status: status ?? this.status,
      singleMatchStatus: singleMatchStatus ?? this.singleMatchStatus,
      matches: matches ?? this.matches,
      selectedMatch: selectedMatch ?? this.selectedMatch,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    singleMatchStatus,
    matches,
    selectedMatch,
    errorMessage,
  ];
}
