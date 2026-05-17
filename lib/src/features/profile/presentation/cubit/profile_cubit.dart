import 'package:e7gz/src/imports/imports.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileCubit({required this.repository}) : super(const ProfileState());

  Future<void> loadProfileData() async {
    emit(state.copyWith(status: ProfileStatus.loading));

    final rewardsResult = await repository.getAvailableRewards();
    final tierResult = await repository.getTierStatus();

    rewardsResult.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (rewards) {
        tierResult.fold(
          (failure) => emit(
            state.copyWith(
              status: ProfileStatus.failure,
              errorMessage: failure.message,
              rewards: rewards,
            ),
          ),
          (tierStatus) => emit(
            state.copyWith(
              status: ProfileStatus.success,
              rewards: rewards,
              tierStatus: tierStatus,
            ),
          ),
        );
      },
    );
  }

  Future<void> redeemReward(String rewardId) async {
    final result = await repository.redeemReward(rewardId);

    result.fold(
      (failure) {
        // Handle failure
      },
      (success) {
        loadProfileData(); // Reload data after redemption
      },
    );
  }
}
