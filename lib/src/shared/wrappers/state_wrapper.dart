import 'package:e7gz/src/imports/imports.dart';
import 'package:e7gz/src/di/injection_container.dart';

// Auth
import 'package:e7gz/src/features/auth/presentation/providers/session_cubit.dart';
import 'package:e7gz/src/features/auth/presentation/providers/auth_cubit.dart';

// Pitches
import 'package:e7gz/src/features/pitches/presentation/cubit/pitches_cubit.dart';

// Bookings
import 'package:e7gz/src/features/bookings/presentation/cubit/booking_cubit.dart';

// Maps
import 'package:e7gz/src/features/maps/presentation/cubit/maps_cubit.dart';

// Matchmaking
import 'package:e7gz/src/features/matchmaking/presentation/cubit/matchmaking_cubit.dart';

// Owner
import 'package:e7gz/src/features/owner/presentation/cubit/owner_cubit.dart';

// Admin
import 'package:e7gz/src/features/admin/presentation/cubit/admin_cubit.dart';

// Notifications
import 'package:e7gz/src/features/notifications/presentation/cubit/notifications_cubit.dart';

// Home
import 'package:e7gz/src/features/home/presentation/cubit/home_cubit.dart';

// Search
import 'package:e7gz/src/features/search/presentation/cubit/search_cubit.dart';

// Profile
import 'package:e7gz/src/features/profile/presentation/cubit/profile_cubit.dart';

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
