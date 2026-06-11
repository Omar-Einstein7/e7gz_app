import 'package:equatable/equatable.dart';
import 'package:e7gz/src/features/profile/domain/entities/reward.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final List<Reward> rewards;
  final Map<String, dynamic> tierStatus;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.rewards = const [],
    this.tierStatus = const {},
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    List<Reward>? rewards,
    Map<String, dynamic>? tierStatus,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      rewards: rewards ?? this.rewards,
      tierStatus: tierStatus ?? this.tierStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, rewards, tierStatus, errorMessage];
}
