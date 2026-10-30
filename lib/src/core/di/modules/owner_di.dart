import 'package:dio/dio.dart';
import 'package:e7gz/src/di/injection_container.dart';


import 'package:e7gz/src/features/owner/data/datasources/owner_remote_datasource.dart';
import 'package:e7gz/src/features/owner/data/repositories/owner_repository_impl.dart';
import 'package:e7gz/src/features/owner/domain/repositories/owner_repository.dart';
import 'package:e7gz/src/features/owner/presentation/cubit/owner_cubit.dart';

void initOwnerDependencies() {
  // Data source — Pattern B: takes Dio via constructor
  sl.registerLazySingleton<OwnerRemoteDataSource>(
    () => OwnerRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<OwnerRepository>(
    () => OwnerRepositoryImpl(sl<OwnerRemoteDataSource>()),
  );

  sl.registerFactory(() => OwnerCubit(repository: sl<OwnerRepository>()));
}