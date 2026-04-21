/// Centralized route path constants for GoRouter.
///
/// Use these variables instead of raw strings throughout the app.
/// Example: `context.go(AppRoutes.onboarding)` instead of `context.go('/')`.
abstract final class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String home = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';

  static const String search = '/search';
  static const String pitchDetails = '/pitch-details';
  static const String bookingSlots = '/booking-slots';
  static const String paymentCheckout = '/payment-checkout';
  static const String bookingSuccess = '/booking-success';
  static const String myBookings = '/my-bookings';
  static const String loyalty = '/loyalty';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String matchmaking = '/matchmaking';
  static const String ownerDashboard = '/owner-dashboard';
}
