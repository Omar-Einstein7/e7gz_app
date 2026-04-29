import 'package:e7gz/src/imports/imports.dart';
import '../../domain/entities/match.dart';
import '../../domain/repositories/match_repository.dart';
import 'matchmaking_state.dart';

class MatchmakingCubit extends Cubit<MatchmakingState> {
  final MatchRepository repository;

  MatchmakingCubit(this.repository) : super(const MatchmakingState());

  Future<void> loadMatches({String? pitchId, String? date, String? status}) async {
    emit(state.copyWith(status: MatchmakingStatus.loading));
    final result = await repository.getMatches(
      pitchId: pitchId,
      date: date,
      status: status,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: MatchmakingStatus.failure,
        errorMessage: failure.message,
      )),
      (matches) => emit(state.copyWith(
        status: MatchmakingStatus.success,
        matches: matches,
      )),
    );
  }

  Future<void> loadMatchById(String id) async {
    emit(state.copyWith(singleMatchStatus: MatchmakingStatus.loading));
    final result = await repository.getMatchById(id);

    result.fold(
      (failure) => emit(state.copyWith(
        singleMatchStatus: MatchmakingStatus.failure,
        errorMessage: failure.message,
      )),
      (match) => emit(state.copyWith(
        singleMatchStatus: MatchmakingStatus.success,
        selectedMatch: match,
      )),
    );
  }

  void clearSelectedMatch() {
    emit(state.copyWith(selectedMatch: null, singleMatchStatus: MatchmakingStatus.initial));
  }

  Future<void> joinMatch(String matchId) async {
    final result = await repository.joinMatch(matchId);
    
    result.fold(
      (failure) {
        // Handle failure (e.g., show toast)
      },
      (MatchmakingMatch updatedMatch) {
        final List<MatchmakingMatch> updatedMatches = state.matches.map((m) {
          return m.id == updatedMatch.id ? updatedMatch : m;
        }).toList();
        
        emit(state.copyWith(
          matches: updatedMatches,
          selectedMatch: state.selectedMatch?.id == updatedMatch.id ? updatedMatch : state.selectedMatch,
        ));
      },
    );
  }
}
