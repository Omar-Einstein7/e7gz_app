import 'package:e7gz/src/core/di/sl.dart';
import 'package:e7gz/src/core/services/dio_service.dart';


import 'package:e7gz/src/features/maps/data/datasources/maps_remote_datasource.dart';
import 'package:e7gz/src/features/maps/data/repositories/maps_repository_impl.dart';
import 'package:e7gz/src/features/maps/domain/repositories/maps_repository.dart';
import 'package:e7gz/src/features/maps/domain/usecases/maps_usecases.dart';
import 'package:e7gz/src/features/maps/presentation/cubit/maps_cubit.dart';

void initMapsDependencies() {
  sl.registerLazySingleton<MapsRemoteDataSource>(
    () => MapsRemoteDataSource(dioService: sl<DioService>()),
  );

  sl.registerLazySingleton<MapsRepository>(
    () => MapsRepositoryImpl(sl<MapsRemoteDataSource>()),
  );

  sl.registerLazySingleton(() => GetRouteUseCase(sl<MapsRepository>()));
  sl.registerLazySingleton(() => GeocodeUseCase(sl<MapsRepository>()));
  sl.registerLazySingleton(() => ReverseGeocodeUseCase(sl<MapsRepository>()));

  sl.registerFactory(
    () => MapsCubit(
      getRoute: sl<GetRouteUseCase>(),
      geocode: sl<GeocodeUseCase>(),
      reverseGeocode: sl<ReverseGeocodeUseCase>(),
    ),
  );
}