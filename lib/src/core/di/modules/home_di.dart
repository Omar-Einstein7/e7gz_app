import 'package:dio/dio.dart';
import 'package:e7gz/src/core/di/sl.dart';


import 'package:e7gz/src/features/home/data/datasources/home_remote_datasource.dart';
import 'package:e7gz/src/features/home/data/repositories/home_repository_impl.dart';
import 'package:e7gz/src/features/home/domain/repositories/home_repository.dart';
import 'package:e7gz/src/features/home/presentation/cubit/home_cubit.dart';

void initHomeDependencies() {
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl<HomeRemoteDataSource>()),
  );

  sl.registerFactory(() => HomeCubit(repository: sl<HomeRepository>()));
}