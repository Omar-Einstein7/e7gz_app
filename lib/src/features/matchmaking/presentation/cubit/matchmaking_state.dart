import 'package:equatable/equatable.dart';
import '../../domain/entities/match.dart';
import '../../domain/repositories/match_repository.dart';

enum MatchmakingStatus { initial, loading, success, failure }

class MatchmakingState extends Equatable {
  final MatchmakingStatus status;
  final MatchmakingStatus singleMatchStatus;
  final MatchmakingStatus leaderboardStatus;
  final List<MatchmakingMatch> matches;
  final List<LeaderboardEntry> leaderboard;
  final MatchmakingMatch? selectedMatch;
  final String? errorMessage;

  const MatchmakingState({
    this.status = MatchmakingStatus.initial,
    this.singleMatchStatus = MatchmakingStatus.initial,
    this.leaderboardStatus = MatchmakingStatus.initial,
    this.matches = const [],
    this.leaderboard = const [],
    this.selectedMatch,
    this.errorMessage,
  });

  MatchmakingState copyWith({
    MatchmakingStatus? status,
    MatchmakingStatus? singleMatchStatus,
    MatchmakingStatus? leaderboardStatus,
    List<MatchmakingMatch>? matches,
    List<LeaderboardEntry>? leaderboard,
    MatchmakingMatch? selectedMatch,
    String? errorMessage,
  }) {
    return MatchmakingState(
      status: status ?? this.status,
      singleMatchStatus: singleMatchStatus ?? this.singleMatchStatus,
      leaderboardStatus: leaderboardStatus ?? this.leaderboardStatus,
      matches: matches ?? this.matches,
      leaderboard: leaderboard ?? this.leaderboard,
      selectedMatch: selectedMatch ?? this.selectedMatch,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    singleMatchStatus,
    leaderboardStatus,
    matches,
    leaderboard,
    selectedMatch,
    errorMessage,
  ];
}
