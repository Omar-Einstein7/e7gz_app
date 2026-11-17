import 'package:e7gz/src/core/utils/task_runner.dart';
import 'package:e7gz/src/core/utils/typedefs.dart';
import 'package:e7gz/src/features/home/domain/entities/home_data.dart';
import 'package:e7gz/src/features/home/domain/repositories/home_repository.dart';
import 'package:e7gz/src/features/home/data/datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  FutureEither<HomeData> getHomeData() {
    return runTask(() => remoteDataSource.getHomeData(), requiresNetwork: true);
  }
}
