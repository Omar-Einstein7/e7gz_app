import '../../imports/imports.dart';
import '../../di/injection_container.dart';

// Auth
import '../../features/auth/presentation/providers/session_cubit.dart';
import '../../features/auth/presentation/providers/auth_cubit.dart';

// Pitches
import '../../features/pitches/presentation/cubit/pitches_cubit.dart';

// Bookings
import '../../features/bookings/presentation/cubit/booking_cubit.dart';

// Maps
import '../../features/maps/presentation/cubit/maps_cubit.dart';

// Matchmaking
import '../../features/matchmaking/presentation/cubit/matchmaking_cubit.dart';

// Owner
import '../../features/owner/presentation/cubit/owner_cubit.dart';

// Admin
import '../../features/admin/presentation/cubit/admin_cubit.dart';

// Notifications
import '../../features/notifications/presentation/cubit/notifications_cubit.dart';

// Home
import '../../features/home/presentation/cubit/home_cubit.dart';

// Search
import '../../features/search/presentation/cubit/search_cubit.dart';

// Profile
import '../../features/profile/presentation/cubit/profile_cubit.dart';

/// A wrapper that provides all BLoCs / Cubits via [MultiBlocProvider].
///
/// Dependencies are resolved from [get_it] (see [initDependencies]).
/// Cubits are registered as *factories* so each provider gets a fresh
/// instance — no objects are recreated on rebuilds.
class StateWrapper extends StatelessWidget {
  final Widget child;

  const StateWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth / Session
        BlocProvider(create: (_) => sl<SessionCubit>()),
        BlocProvider(create: (_) => sl<AuthCubit>()),

        // Home
        BlocProvider(create: (_) => sl<HomeCubit>()),

        // Pitches – list
        BlocProvider(create: (_) => sl<PitchesCubit>()),

        // Search
        BlocProvider(create: (_) => sl<SearchCubit>()),

        // Profile
        BlocProvider(create: (_) => sl<ProfileCubit>()),

        // Bookings – my bookings list
        BlocProvider(create: (_) => sl<BookingsCubit>()),

        // Create Booking
        BlocProvider(create: (_) => sl<CreateBookingCubit>()),

        // Maps
        BlocProvider(create: (_) => sl<MapsCubit>()),

        // Matchmaking
        BlocProvider(create: (_) => sl<MatchmakingCubit>()),

        // Owner
        BlocProvider(create: (_) => sl<OwnerCubit>()),

        // Admin
        BlocProvider(create: (_) => sl<AdminCubit>()),

        // Notifications
        BlocProvider(create: (_) => sl<NotificationsCubit>()),
      ],
      child: child,
    );
  }
}
