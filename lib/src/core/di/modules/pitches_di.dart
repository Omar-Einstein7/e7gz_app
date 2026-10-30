import 'package:e7gz/src/core/di/sl.dart';
import 'package:e7gz/src/core/services/dio_service.dart';


import 'package:e7gz/src/features/pitches/data/datasources/pitch_remote_datasource.dart';
import 'package:e7gz/src/features/pitches/data/repositories/pitch_repository_impl.dart';
import 'package:e7gz/src/features/pitches/domain/repositories/pitch_repository.dart';
import 'package:e7gz/src/features/pitches/domain/usecases/pitch_usecases.dart';
import 'package:e7gz/src/features/pitches/presentation/cubit/pitches_cubit.dart';

void initPitchesDependencies() {
  // Data source — Pattern A: constructor-injected with DioService
  sl.registerLazySingleton<PitchRemoteDataSource>(
    () => PitchRemoteDataSource(dioService: sl<DioService>()),
  );

  // Repository
  sl.registerLazySingleton<PitchRepository>(
    () => PitchRepositoryImpl(sl<PitchRemoteDataSource>()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetPitchesUseCase(sl<PitchRepository>()));
  sl.registerLazySingleton(
    () => GetNearbyPitchesUseCase(sl<PitchRepository>()),
  );
  sl.registerLazySingleton(() => GetPitchDetailsUseCase(sl<PitchRepository>()));
  sl.registerLazySingleton(() => CreateReviewUseCase(sl<PitchRepository>()));

  // Cubits (factory = fresh instance per BlocProvider)
  sl.registerFactory(
    () => PitchesCubit(
      getPitches: sl<GetPitchesUseCase>(),
      getNearbyPitches: sl<GetNearbyPitchesUseCase>(),
    ),
  );
  sl.registerFactory(
    () => PitchDetailCubit(
      getPitchDetails: sl<GetPitchDetailsUseCase>(),
      createReview: sl<CreateReviewUseCase>(),
    ),
  );
}