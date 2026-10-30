import 'package:dio/dio.dart';
import 'package:e7gz/src/core/di/sl.dart';
import 'package:e7gz/src/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:e7gz/src/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:e7gz/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:e7gz/src/features/profile/presentation/cubit/profile_cubit.dart';

void initProfileDependencies() {
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl<ProfileRemoteDataSource>()),
  );

  sl.registerFactory(() => ProfileCubit(repository: sl<ProfileRepository>()));
}
