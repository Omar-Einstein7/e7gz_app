import 'package:e7gz/src/core/utils/task_runner.dart';
import 'package:e7gz/src/core/utils/typedefs.dart';
import 'package:e7gz/src/features/admin/domain/entities/admin_stats.dart';
import 'package:e7gz/src/features/admin/domain/repositories/admin_repository.dart';
import 'package:e7gz/src/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:e7gz/src/features/notifications/data/models/notification_model.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';
import 'package:e7gz/src/features/pitches/data/models/pitch_model.dart';
import 'package:e7gz/src/features/bookings/domain/entities/booking.dart';
import 'package:e7gz/src/features/bookings/data/models/booking_model.dart';
import 'package:e7gz/src/features/matchmaking/domain/entities/match.dart';
import 'package:e7gz/src/features/matchmaking/data/models/match_model.dart';
import 'package:e7gz/src/features/notifications/domain/entities/notification.dart';
import 'package:e7gz/src/features/auth/domain/entities/user.dart';
import 'package:e7gz/src/features/auth/data/models/user_model.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource _dataSource;

  AdminRepositoryImpl({required AdminRemoteDataSource dataSource})
    : _dataSource = dataSource;

  @override
  FutureEither<AdminStats> getDashboardStats() {
    return runTask(() async {
      final statsMap = await _dataSource.getDashboardStats();
      final data = statsMap['data'] ?? statsMap;
      return AdminStats(
        totalRevenue: (data['totalRevenue'] ?? 0).toDouble(),
        totalBookings: data['totalBookings'] ?? 0,
        pitchCount: data['pitchCount'] ?? 0,
        userCount: data['userCount'] ?? 0,
      );
    }, requiresNetwork: true);
  }

  @override
  FutureEither<List<Pitch>> getAllPitches() {
    return runTask(() async {
      final rawList = await _dataSource.getAllPitches();
      return rawList
          .map((p) => PitchModel.fromJson(p as Map<String, dynamic>))
          .toList();
    }, requiresNetwork: true);
  }

  @override
  FutureEither<List<Pitch>> getMyPitches() {
    return runTask(() async {
      final rawList = await _dataSource.getMyPitches();
      return rawList
          .map((p) => PitchModel.fromJson(p as Map<String, dynamic>))
          .toList();
    }, requiresNetwork: true);
  }

  @override
  FutureEither<List<Booking>> getMyBookings() {
    return runTask(() async {
      final rawList = await _dataSource.getMyBookings();
      return rawList
          .map((b) => BookingModel.fromJson(b as Map<String, dynamic>))
          .toList();
    }, requiresNetwork: true);
  }

  @override
  FutureEither<List<MatchmakingMatch>> getAllMatches() {
    return runTask(() async {
      final rawList = await _dataSource.getAllMatches();
      return rawList
          .map((m) => MatchModel.fromJson(m as Map<String, dynamic>))
          .toList();
    }, requiresNetwork: true);
  }

  @override
  FutureEither<List<AppNotification>> getNotifications() {
    return runTask(() async {
      final rawList = await _dataSource.getNotifications();
      return rawList
          .map((n) => NotificationModel.fromJson(n as Map<String, dynamic>))
          .toList();
    }, requiresNetwork: true);
  }

  @override
  FutureEither<void> markNotificationsAsRead() {
    return runTask(
      () => _dataSource.markNotificationsAsRead(),
      requiresNetwork: true,
    );
  }

  @override
  FutureEither<AppUser> getProfile() {
    return runTask(() async {
      final rawUser = await _dataSource.getProfile();
      return UserModel.fromJson(rawUser);
    }, requiresNetwork: true);
  }

  @override
  FutureEither<bool> createPitch(
    Map<String, dynamic> pitchData, {
    List<List<int>>? multipleImageBytes,
    List<String>? multipleFileNames,
  }) {
    return runTask(() async {
      final error = await _dataSource.createPitch(
        pitchData,
        multipleImageBytes: multipleImageBytes,
        multipleFileNames: multipleFileNames,
      );
      if (error != null) {
        throw Exception(error);
      }
      return true;
    }, requiresNetwork: true);
  }

  @override
  FutureEither<bool> deletePitch(String id) {
    return runTask(() async {
      final success = await _dataSource.deletePitch(id);
      if (!success) {
        throw Exception('Failed to delete pitch');
      }
      return true;
    }, requiresNetwork: true);
  }

  @override
  FutureEither<bool> updatePitch(
    String id,
    Map<String, dynamic> pitchData, {
    List<List<int>>? multipleImageBytes,
    List<String>? multipleFileNames,
  }) {
    return runTask(() async {
      final error = await _dataSource.updatePitch(
        id,
        pitchData,
        multipleImageBytes: multipleImageBytes,
        multipleFileNames: multipleFileNames,
      );
      if (error != null) {
        throw Exception(error);
      }
      return true;
    }, requiresNetwork: true);
  }
}
