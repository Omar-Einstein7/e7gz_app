import 'package:e7gz/src/utils/utils.dart';
import 'package:e7gz/src/features/admin/domain/entities/admin_stats.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';
import 'package:e7gz/src/features/bookings/domain/entities/booking.dart';
import 'package:e7gz/src/features/matchmaking/domain/entities/match.dart';
import 'package:e7gz/src/features/notifications/domain/entities/notification.dart';
import 'package:e7gz/src/features/auth/domain/entities/user.dart';

abstract class AdminRepository {
  FutureEither<AdminStats> getDashboardStats();
  FutureEither<List<Pitch>> getAllPitches();
  FutureEither<List<Pitch>> getMyPitches();
  FutureEither<List<Booking>> getMyBookings();
  FutureEither<List<MatchmakingMatch>> getAllMatches();
  FutureEither<List<AppNotification>> getNotifications();
  FutureEither<void> markNotificationsAsRead();
  FutureEither<AppUser> getProfile();
  
  FutureEither<bool> createPitch(
    Map<String, dynamic> pitchData, {
    List<int>? imageBytes,
    String? fileName,
  });

  FutureEither<bool> deletePitch(String id);

  FutureEither<bool> updatePitch(
    String id,
    Map<String, dynamic> pitchData, {
    List<int>? imageBytes,
    String? fileName,
  });
}
