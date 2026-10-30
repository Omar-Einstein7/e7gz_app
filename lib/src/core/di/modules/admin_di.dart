import 'package:dio/dio.dart';
import 'package:e7gz/src/core/di/sl.dart';



import 'package:e7gz/src/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:e7gz/src/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:e7gz/src/features/admin/domain/repositories/admin_repository.dart';
import 'package:e7gz/src/features/admin/presentation/cubit/admin_cubit.dart';

void initAdminDependencies() {
  sl.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSource(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(dataSource: sl<AdminRemoteDataSource>()),
  );

  sl.registerFactory(() => AdminCubit(repository: sl<AdminRepository>()));
}