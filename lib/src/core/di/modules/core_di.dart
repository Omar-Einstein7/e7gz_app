import 'package:e7gz/src/core/services/notification_service.dart';
import 'package:e7gz/src/di/injection_container.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:e7gz/src/theme/cubit/theme_cubit.dart';

Future<void> initCoreDependencies() async {
  // Dio instances (already initialised by AppConfig.init())
  sl.registerLazySingleton<Dio>(() => AppConfig.dio);
  sl.registerLazySingleton<Dio>(
    () => AppConfig.authDio,
    instanceName: 'authDio',
  );

  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // Base services first — others depend on them
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  sl.registerLazySingleton<StorageService>(() => StorageService());
  sl.registerLazySingleton<InternetConnectionService>(
    () => InternetConnectionService(),
  );

  // AuthService depends on SecureStorageService
  sl.registerLazySingleton<AuthService>(
    () => AuthService(
      secureStorage: sl<SecureStorageService>(),
      dio: sl<Dio>(),
      authDio: sl<Dio>(instanceName: 'authDio'),
    ),
  );

  // DioService wraps AppConfig.dio
  sl.registerLazySingleton<DioService>(() => DioService(dio: sl<Dio>()));

  // Utility services — no dependencies
  sl.registerLazySingleton<LocationService>(() => LocationService());
  sl.registerLazySingleton<PermissionService>(() => PermissionService());
  sl.registerLazySingleton<PathService>(() => PathService());
  sl.registerLazySingleton<CopyService>(() => CopyService());
  sl.registerLazySingleton<UrlLauncherService>(() => UrlLauncherService());
  sl.registerLazySingleton<DeviceInfoService>(() => DeviceInfoService());
  sl.registerLazySingleton<VersionUpdateService>(() => VersionUpdateService());
  sl.registerLazySingleton<NotificationService>(() => NotificationService());

  // App-level cubit (has no feature owner)
  sl.registerSingleton<ThemeCubit>(ThemeCubit(sl<SharedPreferences>()));
}