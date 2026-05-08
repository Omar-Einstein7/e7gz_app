import 'package:dio/dio.dart';
import '../models/reward_model.dart';

abstract class ProfileRemoteDataSource {
  Future<List<RewardModel>> getAvailableRewards();
  Future<void> redeemReward(String rewardId);
  Future<Map<String, dynamic>> getTierStatus();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<RewardModel>> getAvailableRewards() async {
    final response = await dio.get('profile/rewards');
    final data = response.data as Map<String, dynamic>;
    final List<dynamic> list = data['data']['rewards'] ?? data['data'] ?? [];
    return list.map((e) => RewardModel.fromJson(e)).toList();
  }

  @override
  Future<void> redeemReward(String rewardId) async {
    await dio.post('profile/rewards/redeem', data: {'rewardId': rewardId});
  }

  @override
  Future<Map<String, dynamic>> getTierStatus() async {
    final response = await dio.get('profile/tier-status');
    final data = response.data as Map<String, dynamic>;
    return data['data'] ?? data;
  }
}
