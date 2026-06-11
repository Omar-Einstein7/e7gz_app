import 'package:fpdart/fpdart.dart';
import 'package:e7gz/src/utils/failure.dart';
import 'package:e7gz/src/utils/typedefs.dart';
import 'package:e7gz/src/features/profile/domain/entities/reward.dart';
import 'package:e7gz/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:e7gz/src/features/profile/data/datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  FutureEither<List<Reward>> getAvailableRewards() async {
    try {
      final rewards = await remoteDataSource.getAvailableRewards();
      return right(rewards);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> redeemReward(String rewardId) async {
    try {
      await remoteDataSource.redeemReward(rewardId);
      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<Map<String, dynamic>> getTierStatus() async {
    try {
      final status = await remoteDataSource.getTierStatus();
      return right(status);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
