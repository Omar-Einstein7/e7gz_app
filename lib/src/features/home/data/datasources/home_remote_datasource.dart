import 'package:dio/dio.dart';
import '../models/home_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeModel> getHomeData();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl({required this.dio});

  @override
  Future<HomeModel> getHomeData() async {
    final response = await dio.get<dynamic>('home');
    final data = response.data as Map<String, dynamic>;
    return HomeModel.fromJson(data['data'] ?? data);
  }
}
