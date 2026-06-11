import 'package:e7gz/src/imports/imports.dart';
import 'package:e7gz/src/features/matchmaking/domain/entities/match.dart';
import 'package:e7gz/src/features/matchmaking/domain/repositories/match_repository.dart';
import 'package:e7gz/src/features/matchmaking/data/models/match_model.dart';
import 'package:e7gz/src/features/matchmaking/presentation/cubit/matchmaking_state.dart';

class MatchmakingCubit extends Cubit<MatchmakingState> {
  final MatchRepository repository;

  MatchmakingCubit(this.repository) : super(const MatchmakingState());

  Future<void> loadMatches({
    String? pitchId,
    String? date,
    String? status,
  }) async {
    emit(state.copyWith(status: MatchmakingStatus.loading));
    final result = await repository.getMatches(
      pitchId: pitchId,
      date: date,
      status: status,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MatchmakingStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (matches) => emit(
        state.copyWith(status: MatchmakingStatus.success, matches: matches),
      ),
    );
  }

  Future<void> loadMatchById(String id) async {
    emit(state.copyWith(singleMatchStatus: MatchmakingStatus.loading));
    final result = await repository.getMatchById(id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          singleMatchStatus: MatchmakingStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (match) => emit(
        state.copyWith(
          singleMatchStatus: MatchmakingStatus.success,
          selectedMatch: match,
        ),
      ),
    );
  }

  void clearSelectedMatch() {
    emit(
      state.copyWith(
        selectedMatch: null,
        singleMatchStatus: MatchmakingStatus.initial,
      ),
    );
  }

  Future<void> loadLeaderboard() async {
    emit(state.copyWith(leaderboardStatus: MatchmakingStatus.loading));
    final result = await repository.getLeaderboard();

    result.fold(
      (failure) => emit(
        state.copyWith(
          leaderboardStatus: MatchmakingStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (entries) => emit(
        state.copyWith(
          leaderboardStatus: MatchmakingStatus.success,
          leaderboard: entries,
        ),
      ),
    );
  }

  Future<void> joinMatch(String matchId, String team) async {
    // Show loading on the details screen while request is in-flight
    emit(state.copyWith(singleMatchStatus: MatchmakingStatus.loading));

    final result = await repository.joinMatch(matchId, team);

    result.fold(
      (failure) => emit(
        state.copyWith(
          singleMatchStatus: MatchmakingStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (MatchmakingMatch updatedMatch) {
        final List<MatchmakingMatch> updatedMatches = state.matches.map((m) {
          return m.id == updatedMatch.id ? updatedMatch : m;
        }).toList();

        emit(
          state.copyWith(
            singleMatchStatus: MatchmakingStatus.success,
            errorMessage: null,
            matches: updatedMatches,
            selectedMatch: state.selectedMatch?.id == updatedMatch.id
                ? updatedMatch
                : state.selectedMatch,
          ),
        );
      },
    );
  }

  Future<void> resolveMatch(String matchId, String winner) async {
    emit(state.copyWith(singleMatchStatus: MatchmakingStatus.loading));
    final result = await repository.resolveMatch(matchId, winner);

    result.fold(
      (failure) => emit(
        state.copyWith(
          singleMatchStatus: MatchmakingStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (updatedMatch) {
        final List<MatchmakingMatch> updatedMatches = state.matches.map((m) {
          return m.id == updatedMatch.id ? updatedMatch : m;
        }).toList();

        emit(
          state.copyWith(
            singleMatchStatus: MatchmakingStatus.success,
            errorMessage: 'Match resolved successfully!',
            matches: updatedMatches,
            selectedMatch: updatedMatch,
          ),
        );
        // Refresh leaderboard after resolution
        loadLeaderboard();
      },
    );
  }

  Future<void> createMatch(MatchModel match) async {
    emit(state.copyWith(status: MatchmakingStatus.loading));
    final result = await repository.createMatch(match);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MatchmakingStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (newMatch) {
        final List<MatchmakingMatch> updatedMatches = [
          newMatch,
          ...state.matches,
        ];
        emit(
          state.copyWith(
            status: MatchmakingStatus.success,
            matches: updatedMatches,
          ),
        );
      },
    );
  }
}
