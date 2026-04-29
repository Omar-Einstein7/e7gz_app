import '../../imports/imports.dart';

// Auth
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/presentation/providers/session_bloc.dart';
import '../../features/auth/presentation/providers/auth_bloc.dart';

// Pitches
import '../../features/pitches/data/datasources/pitch_remote_datasource.dart';
import '../../features/pitches/data/repositories/pitch_repository_impl.dart';
import '../../features/pitches/domain/usecases/pitch_usecases.dart';
import '../../features/pitches/presentation/cubit/pitches_cubit.dart';

// Bookings
import '../../features/bookings/data/datasources/booking_remote_datasource.dart';
import '../../features/bookings/data/repositories/booking_repository_impl.dart';
import '../../features/bookings/domain/usecases/booking_usecases.dart';
import '../../features/bookings/presentation/cubit/booking_cubit.dart';

// Maps
import '../../features/maps/data/datasources/maps_remote_datasource.dart';
import '../../features/maps/data/repositories/maps_repository_impl.dart';
import '../../features/maps/domain/usecases/maps_usecases.dart';
import '../../features/maps/presentation/cubit/maps_cubit.dart';

// Matchmaking
import '../../features/matchmaking/data/datasources/match_remote_datasource.dart';
import '../../features/matchmaking/data/repositories/match_repository_impl.dart';
import '../../features/matchmaking/presentation/cubit/matchmaking_cubit.dart';

// Owner
import '../../features/owner/data/datasources/owner_remote_datasource.dart';
import '../../features/owner/data/repositories/owner_repository_impl.dart';
import '../../features/owner/presentation/cubit/owner_cubit.dart';

// Notifications
import '../../features/notifications/data/datasources/notification_remote_datasource.dart';
import '../../features/notifications/data/repositories/notification_repository_impl.dart';
import '../../features/notifications/presentation/cubit/notifications_cubit.dart';

// Home
import '../../features/home/data/datasources/home_remote_datasource.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';

// Search
import '../../features/search/data/datasources/search_remote_datasource.dart';
import '../../features/search/data/repositories/search_repository_impl.dart';
import '../../features/search/presentation/cubit/search_cubit.dart';

// Profile
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';

/// A wrapper to initialize the chosen State Management library.
class StateWrapper extends StatelessWidget {
  final Widget child;

  const StateWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // ── Datasources ──────────────────────────────────────────────────────────
    final dio = AppConfig.dio;
    final pitchDs = PitchRemoteDataSource();
    final bookingDs = BookingRemoteDataSource();
    final mapsDs = MapsRemoteDataSource();
    final matchDs = MatchRemoteDataSource();
    final ownerDs = OwnerRemoteDataSourceImpl(dio: dio);
    final notificationDs = NotificationRemoteDataSourceImpl(dio: dio);
    final homeDs = HomeRemoteDataSourceImpl(dio: dio);
    final searchDs = SearchRemoteDataSourceImpl(dio: dio);
    final profileDs = ProfileRemoteDataSourceImpl(dio: dio);

    // ── Repositories ─────────────────────────────────────────────────────────
    final pitchRepo = PitchRepositoryImpl(pitchDs);
    final bookingRepo = BookingRepositoryImpl(bookingDs);
    final mapsRepo = MapsRepositoryImpl(mapsDs);
    final matchRepo = MatchRepositoryImpl(matchDs);
    final ownerRepo = OwnerRepositoryImpl(ownerDs);
    final notificationRepo = NotificationRepositoryImpl(notificationDs);
    final homeRepo = HomeRepositoryImpl(homeDs);
    final searchRepo = SearchRepositoryImpl(searchDs);
    final profileRepo = ProfileRepositoryImpl(profileDs);

    return MultiBlocProvider(
      providers: [
        // Auth / Session
        BlocProvider(create: (_) => SessionBloc(repository: AuthRepositoryImpl())),
        BlocProvider(create: (_) => AuthBloc(repository: AuthRepositoryImpl())),

        // Pitches – list
        BlocProvider(
          create: (_) => PitchesCubit(
            getPitches: GetPitchesUseCase(pitchRepo),
            getNearbyPitches: GetNearbyPitchesUseCase(pitchRepo),
          )..loadPitches(refresh: true),
        ),

        // Home
        BlocProvider(
          create: (_) => HomeCubit(repository: homeRepo)..loadHomeData(),
        ),

        // Search
        BlocProvider(
          create: (_) => SearchCubit(repository: searchRepo),
        ),

        // Profile
        BlocProvider(
          create: (_) => ProfileCubit(repository: profileRepo)..loadProfileData(),
        ),

        // Pitches – single detail (lazy, provided lower in the tree when needed)
        // BookingsCubit – my bookings list
        BlocProvider(
          create: (_) => BookingsCubit(
            getMyBookings: GetMyBookingsUseCase(bookingRepo),
            cancelBooking: CancelBookingUseCase(bookingRepo),
          ),
        ),

        // CreateBookingCubit
        BlocProvider(
          create: (_) => CreateBookingCubit(
            createBooking: CreateBookingUseCase(bookingRepo),
          ),
        ),

        // Maps
        BlocProvider(
          create: (_) => MapsCubit(
            getRoute: GetRouteUseCase(mapsRepo),
            geocode: GeocodeUseCase(mapsRepo),
            reverseGeocode: ReverseGeocodeUseCase(mapsRepo),
          ),
        ),

        // Matchmaking
        BlocProvider(
          create: (_) => MatchmakingCubit(matchRepo)..loadMatches(),
        ),

        // Owner
        BlocProvider(
          create: (_) => OwnerCubit(repository: ownerRepo),
        ),

        // Notifications
        BlocProvider(
          create: (_) => NotificationsCubit(repository: notificationRepo)..loadNotifications(),
        ),
      ],
      child: child,
    );
  }
}

