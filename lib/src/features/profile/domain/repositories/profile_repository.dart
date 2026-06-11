import 'package:e7gz/src/utils/typedefs.dart';
import 'package:e7gz/src/features/profile/domain/entities/reward.dart';

abstract class ProfileRepository {
  FutureEither<List<Reward>> getAvailableRewards();
  FutureEither<void> redeemReward(String rewardId);
  FutureEither<Map<String, dynamic>> getTierStatus();
}
