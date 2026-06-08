import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

// Config
import '../config/app_config.dart';

// Services
import '../services/auth_service.dart';
import '../services/copy_service.dart';
import '../services/device_info_service.dart';
import '../services/dio_service.dart';
import '../services/internet_connection_service.dart';
import '../services/location_service.dart';
import '../services/path_service.dart';
import '../services/permission_service.dart';
import '../services/secure_storage_service.dart';
import '../services/storage_service.dart';
import '../services/url_launcher_service.dart';
import '../services/version_update_service.dart';
import '../services/notification_service.dart';

// ── Auth ─────────────────────────────────────────────────────────────────────
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/presentation/providers/session_cubit.dart';
import '../features/auth/presentation/providers/auth_cubit.dart';

// ── Pitches ──────────────────────────────────────────────────────────────────
import '../features/pitches/data/datasources/pitch_remote_datasource.dart';
import '../features/pitches/data/repositories/pitch_repository_impl.dart';
import '../features/pitches/domain/repositories/pitch_repository.dart';
import '../features/pitches/domain/usecases/pitch_usecases.dart';
import '../features/pitches/presentation/cubit/pitches_cubit.dart';

// ── Bookings ─────────────────────────────────────────────────────────────────
import '../features/bookings/data/datasources/booking_remote_datasource.dart';
import '../features/bookings/data/repositories/booking_repository_impl.dart';
import '../features/bookings/domain/repositories/booking_repository.dart';
import '../features/bookings/domain/usecases/booking_usecases.dart';
import '../features/bookings/presentation/cubit/booking_cubit.dart';

// ── Maps ─────────────────────────────────────────────────────────────────────
import '../features/maps/data/datasources/maps_remote_datasource.dart';
import '../features/maps/data/repositories/maps_repository_impl.dart';
import '../features/maps/domain/repositories/maps_repository.dart';
import '../features/maps/domain/usecases/maps_usecases.dart';
import '../features/maps/presentation/cubit/maps_cubit.dart';

// ── Matchmaking ──────────────────────────────────────────────────────────────
import '../features/matchmaking/data/datasources/match_remote_datasource.dart';
import '../features/matchmaking/data/repositories/match_repository_impl.dart';
import '../features/matchmaking/domain/repositories/match_repository.dart';
import '../features/matchmaking/presentation/cubit/matchmaking_cubit.dart';

// ── Owner ────────────────────────────────────────────────────────────────────
import '../features/owner/data/datasources/owner_remote_datasource.dart';
import '../features/owner/data/repositories/owner_repository_impl.dart';
import '../features/owner/domain/repositories/owner_repository.dart';
import '../features/owner/presentation/cubit/owner_cubit.dart';

// ── Admin ────────────────────────────────────────────────────────────────────
import '../features/admin/data/datasources/admin_remote_datasource.dart';
import '../features/admin/data/repositories/admin_repository_impl.dart';
import '../features/admin/domain/repositories/admin_repository.dart';
import '../features/admin/presentation/cubit/admin_cubit.dart';

// ── Notifications ────────────────────────────────────────────────────────────
import '../features/notifications/data/datasources/notification_remote_datasource.dart';
import '../features/notifications/data/repositories/notification_repository_impl.dart';
import '../features/notifications/domain/repositories/notification_repository.dart';
import '../features/notifications/presentation/cubit/notifications_cubit.dart';
import '../features/profile/presentation/cubit/profile_cubit.dart';
import '../theme/cubit/theme_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Home ─────────────────────────────────────────────────────────────────────
import '../features/home/data/datasources/home_remote_datasource.dart';
import '../features/home/data/repositories/home_repository_impl.dart';
import '../features/home/domain/repositories/home_repository.dart';
import '../features/home/presentation/cubit/home_cubit.dart';

// ── Search ───────────────────────────────────────────────────────────────────
import '../features/search/data/datasources/search_remote_datasource.dart';
import '../features/search/data/repositories/search_repository_impl.dart';
import '../features/search/domain/repositories/search_repository.dart';
import '../features/search/presentation/cubit/search_cubit.dart';

// ── Profile ──────────────────────────────────────────────────────────────────
import '../features/profile/data/datasources/profile_remote_datasource.dart';
import '../features/profile/data/repositories/profile_repository_impl.dart';
import '../features/profile/domain/repositories/profile_repository.dart';

/// Global service locator instance.
final sl = GetIt.instance;

/// Initializes all dependencies. Must be called once before [runApp].
Future<void> initDependencies() async {
  // ════════════════════════════════════════════════════════════════════════════
  // ── 1. EXTERNAL / CORE ────────────────────────────────────────────────────
  // ════════════════════════════════════════════════════════════════════════════

  // Dio instances (already initialised by AppConfig.init())
  sl.registerLazySingleton<Dio>(() => AppConfig.dio);
  sl.registerLazySingleton<Dio>(
    () => AppConfig.authDio,
    instanceName: 'authDio',
  );

  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // ════════════════════════════════════════════════════════════════════════════
  // ── 2. SERVICES ───────────────────────────────────────────────────────────
  // ════════════════════════════════════════════════════════════════════════════

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

  // ════════════════════════════════════════════════════════════════════════════
  // ── 3. DATA SOURCES ───────────────────────────────────────────────────────
  // ════════════════════════════════════════════════════════════════════════════

  // Pattern A — now constructor-injected with DioService
  sl.registerLazySingleton<PitchRemoteDataSource>(
    () => PitchRemoteDataSource(dioService: sl<DioService>()),
  );
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSource(dioService: sl<DioService>()),
  );
  sl.registerLazySingleton<MapsRemoteDataSource>(
    () => MapsRemoteDataSource(dioService: sl<DioService>()),
  );
  sl.registerLazySingleton<MatchRemoteDataSource>(
    () => MatchRemoteDataSource(dioService: sl<DioService>()),
  );

  // Pattern B — takes Dio via constructor
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<OwnerRemoteDataSource>(
    () => OwnerRemoteDataSourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSource(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  // ════════════════════════════════════════════════════════════════════════════
  // ── 4. REPOSITORIES ───────────────────────────────────────────────────────
  // ════════════════════════════════════════════════════════════════════════════

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authService: sl<AuthService>()),
  );
  sl.registerLazySingleton<PitchRepository>(
    () => PitchRepositoryImpl(sl<PitchRemoteDataSource>()),
  );
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(sl<BookingRemoteDataSource>()),
  );
  sl.registerLazySingleton<MapsRepository>(
    () => MapsRepositoryImpl(sl<MapsRemoteDataSource>()),
  );
  sl.registerLazySingleton<MatchRepository>(
    () => MatchRepositoryImpl(sl<MatchRemoteDataSource>()),
  );
  sl.registerLazySingleton<OwnerRepository>(
    () => OwnerRepositoryImpl(sl<OwnerRemoteDataSource>()),
  );
  sl.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(dataSource: sl<AdminRemoteDataSource>()),
  );
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(sl<NotificationRemoteDataSource>()),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl<HomeRemoteDataSource>()),
  );
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(sl<SearchRemoteDataSource>()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl<ProfileRemoteDataSource>()),
  );

  // ════════════════════════════════════════════════════════════════════════════
  // ── 5. USE CASES ──────────────────────────────────────────────────────────
  // ════════════════════════════════════════════════════════════════════════════

  // Pitches
  sl.registerLazySingleton(() => GetPitchesUseCase(sl<PitchRepository>()));
  sl.registerLazySingleton(
    () => GetNearbyPitchesUseCase(sl<PitchRepository>()),
  );
  sl.registerLazySingleton(() => GetPitchDetailsUseCase(sl<PitchRepository>()));
  sl.registerLazySingleton(() => CreateReviewUseCase(sl<PitchRepository>()));

  // Bookings
  sl.registerLazySingleton(() => GetMyBookingsUseCase(sl<BookingRepository>()));
  sl.registerLazySingleton(
    () => GetBookingDetailsUseCase(sl<BookingRepository>()),
  );
  sl.registerLazySingleton(() => CreateBookingUseCase(sl<BookingRepository>()));
  sl.registerLazySingleton(() => CancelBookingUseCase(sl<BookingRepository>()));
  sl.registerLazySingleton(
    () => GetAvailableSlotsUseCase(sl<BookingRepository>()),
  );

  // Maps
  sl.registerLazySingleton(() => GetRouteUseCase(sl<MapsRepository>()));
  sl.registerLazySingleton(() => GeocodeUseCase(sl<MapsRepository>()));
  sl.registerLazySingleton(() => ReverseGeocodeUseCase(sl<MapsRepository>()));

  // ════════════════════════════════════════════════════════════════════════════
  // ── 6. BLOCS / CUBITS ─────────────────────────────────────────────────────
  // ════════════════════════════════════════════════════════════════════════════
  //
  // Registered as *factory* so each BlocProvider gets a fresh instance.
  // This avoids stale state after logout/login and is the recommended
  // pattern for BLoC + get_it.
  // ────────────────────────────────────────────────────────────────────────────

  sl.registerFactory(() => SessionCubit(repository: sl<AuthRepository>()));
  sl.registerFactory(() => AuthCubit(repository: sl<AuthRepository>()));
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
  sl.registerFactory(
    () => BookingsCubit(
      getMyBookings: sl<GetMyBookingsUseCase>(),
      cancelBooking: sl<CancelBookingUseCase>(),
    ),
  );
  sl.registerFactory(
    () => CreateBookingCubit(createBooking: sl<CreateBookingUseCase>()),
  );
  sl.registerFactory(
    () => MapsCubit(
      getRoute: sl<GetRouteUseCase>(),
      geocode: sl<GeocodeUseCase>(),
      reverseGeocode: sl<ReverseGeocodeUseCase>(),
    ),
  );
  sl.registerFactory(() => MatchmakingCubit(sl<MatchRepository>()));
  sl.registerFactory(() => OwnerCubit(repository: sl<OwnerRepository>()));
  sl.registerFactory(() => AdminCubit(repository: sl<AdminRepository>()));
  sl.registerFactory(
    () => NotificationsCubit(repository: sl<NotificationRepository>()),
  );
  sl.registerFactory(() => HomeCubit(repository: sl<HomeRepository>()));
  sl.registerFactory(() => SearchCubit(repository: sl<SearchRepository>()));
  sl.registerFactory(() => ProfileCubit(repository: sl<ProfileRepository>()));
  sl.registerSingleton<ThemeCubit>(ThemeCubit(sl<SharedPreferences>()));
}
