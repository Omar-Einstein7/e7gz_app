import 'package:fpdart/fpdart.dart';
import '../../../../utils/failure.dart';
import '../../../../utils/typedefs.dart';
import '../../domain/entities/home_data.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

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
