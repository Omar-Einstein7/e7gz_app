import 'package:e7gz/src/core/di/modules/admin_di.dart';
import 'package:e7gz/src/core/di/modules/auth_di.dart';
import 'package:e7gz/src/core/di/modules/bookings_di.dart';
import 'package:e7gz/src/core/di/modules/core_di.dart';
import 'package:e7gz/src/core/di/modules/home_di.dart';
import 'package:e7gz/src/core/di/modules/maps_di.dart';
import 'package:e7gz/src/core/di/modules/matchmaking_di.dart';
import 'package:e7gz/src/core/di/modules/notifications_di.dart';
import 'package:e7gz/src/core/di/modules/owner_di.dart';
import 'package:e7gz/src/core/di/modules/pitches_di.dart';
import 'package:e7gz/src/core/di/modules/profile_di.dart';
import 'package:e7gz/src/core/di/modules/search_di.dart';
export 'sl.dart';

Future<void> initDependencies() async {
  // Core must come first — feature modules depend on its services.
  await initCoreDependencies();

  initAuthDependencies();
  initPitchesDependencies();
  initBookingsDependencies();
  initMapsDependencies();
  initMatchmakingDependencies();
  initOwnerDependencies();
  initAdminDependencies();
  initNotificationsDependencies();
  initHomeDependencies();
  initSearchDependencies();
  initProfileDependencies();
}