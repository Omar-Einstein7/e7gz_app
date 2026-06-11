import 'package:fpdart/fpdart.dart';
import 'package:e7gz/src/utils/failure.dart';
import 'package:e7gz/src/utils/typedefs.dart';
import 'package:e7gz/src/features/home/domain/entities/home_data.dart';
import 'package:e7gz/src/features/home/domain/repositories/home_repository.dart';
import 'package:e7gz/src/features/home/data/datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  FutureEither<HomeData> getHomeData() async {
    try {
      final homeData = await remoteDataSource.getHomeData();
      return right(homeData);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
