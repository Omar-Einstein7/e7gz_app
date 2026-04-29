import 'package:e7gz/src/features/owner/domain/repositories/owner_repository.dart';
import 'package:e7gz/src/imports/imports.dart';
import '../../../pitches/domain/entities/pitch.dart';

import 'owner_state.dart';


class OwnerCubit extends Cubit<OwnerState> {
  final OwnerRepository repository;

  OwnerCubit({required this.repository}) : super(const OwnerState());

  Future<void> loadDashboardData() async {
    emit(state.copyWith(status: OwnerStatus.loading));
    
    final statsResult = await repository.getOwnerStats();
    final pitchesResult = await repository.getOwnerPitches();

    OwnerStatus finalStatus = OwnerStatus.success;
    Map<String, dynamic> finalStats = {};
    List<Pitch> finalPitches = [];
    String? error;

    statsResult.fold(
      (failure) {
        finalStatus = OwnerStatus.failure;
        error = failure.message;
      },
      (stats) {
        finalStats = stats;
      },
    );

    if (finalStatus != OwnerStatus.failure) {
      pitchesResult.fold(
        (failure) {
          finalStatus = OwnerStatus.failure;
          error = failure.message;
        },
        (pitches) {
          finalPitches = pitches;
        },
      );
    }

    emit(state.copyWith(
      status: finalStatus,
      stats: finalStats,
      myPitches: finalPitches,
      errorMessage: error,
    ));
  }
}
