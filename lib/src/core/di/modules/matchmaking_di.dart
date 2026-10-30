import 'package:e7gz/src/core/di/sl.dart';
import 'package:e7gz/src/core/services/dio_service.dart';


import 'package:e7gz/src/features/matchmaking/data/datasources/match_remote_datasource.dart';
import 'package:e7gz/src/features/matchmaking/data/repositories/match_repository_impl.dart';
import 'package:e7gz/src/features/matchmaking/domain/repositories/match_repository.dart';
import 'package:e7gz/src/features/matchmaking/presentation/cubit/matchmaking_cubit.dart';

void initMatchmakingDependencies() {
  sl.registerLazySingleton<MatchRemoteDataSource>(
    () => MatchRemoteDataSource(dioService: sl<DioService>()),
  );

  sl.registerLazySingleton<MatchRepository>(
    () => MatchRepositoryImpl(sl<MatchRemoteDataSource>()),
  );

  sl.registerFactory(() => MatchmakingCubit(sl<MatchRepository>()));
}