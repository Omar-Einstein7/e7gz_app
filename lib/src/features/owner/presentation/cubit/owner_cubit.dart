import 'package:e7gz/src/features/owner/domain/repositories/owner_repository.dart';
import 'package:e7gz/src/imports/imports.dart';
import 'package:e7gz/src/utils/failure.dart';
import 'package:fpdart/fpdart.dart';
import '../../../pitches/domain/entities/pitch.dart';

import 'owner_state.dart';

class OwnerCubit extends Cubit<OwnerState> {
  final OwnerRepository repository;

  OwnerCubit({required this.repository}) : super(const OwnerState());

  Future<void> loadDashboardData() async {
    emit(state.copyWith(status: OwnerStatus.loading, clearError: true));

    // Run both requests in parallel — don't fail-fast
    final results = await Future.wait([
      repository.getOwnerStats(),
      repository.getOwnerPitches(),
    ]);

    final statsResult = results[0] as Either<Failure, Map<String, dynamic>>;
    final pitchesResult = results[1] as Either<Failure, List<Pitch>>;

    Map<String, dynamic> finalStats = state.stats;
    List<Pitch> finalPitches = state.myPitches;
    String? error;

    statsResult.fold(
      (failure) => error = failure.message,
      (stats) => finalStats = stats,
    );

    pitchesResult.fold(
      (failure) => error ??= failure.message,
      (pitches) => finalPitches = pitches,
    );

    emit(
      state.copyWith(
        status: error != null ? OwnerStatus.failure : OwnerStatus.success,
        stats: finalStats,
        myPitches: finalPitches,
        errorMessage: error,
      ),
    );
  }

  Future<void> refreshPitches() async {
    final result = await repository.getOwnerPitches();
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (pitches) =>
          emit(state.copyWith(myPitches: pitches, status: OwnerStatus.success)),
    );
  }

  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  void selectTab(int index) {
    _selectedTabIndex = index;
    emit(state.copyWith(selectedTab: index));
  }

  Future<void> deletePitch(String pitchId) async {
    emit(state.copyWith(status: OwnerStatus.loading));
    final result = await repository.deletePitch(pitchId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessage: failure.message,
          status: OwnerStatus.failure,
        ),
      ),
      (_) async {
        await refreshPitches();
      },
    );
  }
}
