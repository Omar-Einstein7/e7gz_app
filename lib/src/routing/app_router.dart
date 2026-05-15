import 'package:e7gz/src/features/matchmaking/presentation/screens/create_match_screen.dart';
import 'package:e7gz/src/features/matchmaking/presentation/screens/match_details_screen.dart';
import 'package:e7gz/src/features/bookings/presentation/screens/booking_summary_screen.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/shared/wrappers/main_wrapper.dart';
import 'package:e7gz/src/features/admin/presentation/screens/add_pitch_screen.dart';
import 'package:e7gz/src/features/admin/presentation/screens/admin_dashboard_screen.dart';

import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      name: 'signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'forgotPassword',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    // Bottom Navigation Shell
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainWrapper(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              name: 'home',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.search,
              name: 'search',
              builder: (context, state) {
                final initialSport = state.extra as String?;
                return SearchScreen(initialSport: initialSport);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.matchmaking,
              name: 'matchmaking',
              builder: (context, state) => const MatchmakingScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.myBookings,
              name: 'myBookings',
              builder: (context, state) => const MyBookingsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              name: 'profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),

    // Independent Screens
    GoRoute(
      path: AppRoutes.pitchDetails,
      name: 'pitchDetails',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return PitchDetailsScreen(pitchId: id);
      },
    ),
    GoRoute(
      path: AppRoutes.matchDetails,
      name: 'matchDetails',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return MatchDetailsScreen(matchId: id);
      },
    ),
    GoRoute(
      path: AppRoutes.bookingSlots,
      name: 'bookingSlots',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        final extra = state.extra; // Optional pitch object
        return BookingSlotsScreen(pitchId: id, extraPitch: extra);
      },
    ),
    GoRoute(
      path: AppRoutes.paymentCheckout,
      name: 'paymentCheckout',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return PaymentCheckoutScreen(
          bookingId: extra?['bookingId'],
          matchId: extra?['matchId'],
          amount: extra?['amount'] ?? 0.0,
          pitchName: extra?['pitchName'] ?? 'Premium Pitch',
          pitchImage: extra?['pitchImage'],
          bookingDetails: extra?['bookingDetails'] ?? '',
        );
      },
    ),
    GoRoute(
      path: AppRoutes.bookingSummary,
      name: 'bookingSummary',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return BookingSummaryScreen(
          pitchId: extra?['pitchId'] ?? '',
          date: extra?['date'] ?? '',
          time: extra?['time'] ?? '',
        );
      },
    ),
    GoRoute(
      path: AppRoutes.bookingSuccess,
      name: 'bookingSuccess',
      builder: (context, state) => const BookingSuccessScreen(),
    ),
    GoRoute(
      path: AppRoutes.loyalty,
      name: 'loyalty',
      builder: (context, state) => const LoyaltyRewardsScreen(),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      name: 'notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: AppRoutes.ownerDashboard,
      name: 'ownerDashboard',
      builder: (context, state) => const OwnerDashboardScreen(),
    ),
    GoRoute(
      path: AppRoutes.addPitch,
      name: 'addPitch',
      builder: (context, state) => const AdminAddPitchScreen(),
    ),
    GoRoute(
      path: AppRoutes.createMatch,
      name: 'createMatch',
      builder: (context, state) => const CreateMatchScreen(),
    ),
    GoRoute(
      path: AppRoutes.admin,
      name: 'admin',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
  ],
);
