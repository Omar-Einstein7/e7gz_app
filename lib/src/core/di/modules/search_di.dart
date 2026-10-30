import 'package:dio/dio.dart';
import 'package:e7gz/src/core/di/sl.dart';



import 'package:e7gz/src/features/search/data/datasources/search_remote_datasource.dart';
import 'package:e7gz/src/features/search/data/repositories/search_repository_impl.dart';
import 'package:e7gz/src/features/search/domain/repositories/search_repository.dart';
import 'package:e7gz/src/features/search/presentation/cubit/search_cubit.dart';

void initSearchDependencies() {
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(sl<SearchRemoteDataSource>()),
  );

  sl.registerFactory(() => SearchCubit(repository: sl<SearchRepository>()));
}