import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/shared/wrappers/main_wrapper.dart';
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
              builder: (context, state) => const SearchScreen(),
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
      builder: (context, state) => const PitchDetailsScreen(),
    ),
    GoRoute(
      path: AppRoutes.bookingSlots,
      name: 'bookingSlots',
      builder: (context, state) => const BookingSlotsScreen(),
    ),
    GoRoute(
      path: AppRoutes.paymentCheckout,
      name: 'paymentCheckout',
      builder: (context, state) => const PaymentCheckoutScreen(),
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
  ],
);
