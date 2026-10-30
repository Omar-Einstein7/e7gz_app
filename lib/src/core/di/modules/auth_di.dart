import 'package:e7gz/src/core/di/sl.dart';
import 'package:e7gz/src/core/services/auth_service.dart';


import 'package:e7gz/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:e7gz/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:e7gz/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:e7gz/src/features/auth/presentation/cubit/session_cubit.dart';

/// Auth: repository + cubits.
/// (AuthService itself lives in core — see core_di.dart.)
void initAuthDependencies() {
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authService: sl<AuthService>()),
  );

  // Registered as *factory* so each BlocProvider gets a fresh instance.
  // This avoids stale state after logout/login and is the recommended
  // pattern for BLoC + get_it.
  sl.registerFactory(() => SessionCubit(repository: sl<AuthRepository>()));
  sl.registerFactory(() => AuthCubit(repository: sl<AuthRepository>()));
}