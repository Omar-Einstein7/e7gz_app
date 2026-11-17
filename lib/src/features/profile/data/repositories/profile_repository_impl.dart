import 'package:e7gz/src/core/utils/task_runner.dart';

import 'package:e7gz/src/core/utils/typedefs.dart';
import 'package:e7gz/src/features/profile/domain/entities/reward.dart';
import 'package:e7gz/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:e7gz/src/features/profile/data/datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  FutureEither<List<Reward>> getAvailableRewards()async  {
   
     return runTask(
      () =>  remoteDataSource.getAvailableRewards() , requiresNetwork: true);
      
    
  }

  @override
  FutureEither<void> redeemReward(String rewardId) async {
    return runTask(
      () => remoteDataSource.redeemReward(rewardId), requiresNetwork: true);
  
  }

  @override
  FutureEither<Map<String, dynamic>> getTierStatus() async {
    return runTask(
      () => remoteDataSource.getTierStatus(), requiresNetwork: true);
  
  }
}
