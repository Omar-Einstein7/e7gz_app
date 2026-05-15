import '../../../../utils/typedefs.dart';
import '../entities/reward.dart';

abstract class ProfileRepository {
  FutureEither<List<Reward>> getAvailableRewards();
  FutureEither<void> redeemReward(String rewardId);
  FutureEither<Map<String, dynamic>> getTierStatus();
}
