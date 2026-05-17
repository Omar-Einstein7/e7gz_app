import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

import 'package:e7gz/src/features/admin/domain/entities/admin_stats.dart';
import 'package:e7gz/src/features/admin/domain/repositories/admin_repository.dart';
import 'package:e7gz/src/features/admin/data/datasources/admin_remote_datasource.dart';
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
  FutureEither<AdminStats> getDashboardStats() async {
    try {
      final statsMap = await _dataSource.getDashboardStats();
      final data = statsMap['data'] ?? statsMap;
      return right(
        AdminStats(
          totalRevenue: (data['totalRevenue'] ?? 0).toDouble(),
          totalBookings: data['totalBookings'] ?? 0,
          pitchCount: data['pitchCount'] ?? 0,
          userCount: data['userCount'] ?? 0,
        ),
      );
    } catch (e) {
      return left(ServerFailure('Failed to fetch dashboard stats: $e'));
    }
  }

  @override
  FutureEither<List<Pitch>> getAllPitches() async {
    try {
      final rawList = await _dataSource.getAllPitches();
      final pitches = rawList
          .map((p) => PitchModel.fromJson(p as Map<String, dynamic>))
          .toList();
      return right(pitches);
    } catch (e) {
      return left(ServerFailure('Failed to fetch all pitches: $e'));
    }
  }

  @override
  FutureEither<List<Pitch>> getMyPitches() async {
    try {
      final rawList = await _dataSource.getMyPitches();
      final pitches = rawList
          .map((p) => PitchModel.fromJson(p as Map<String, dynamic>))
          .toList();
      return right(pitches);
    } catch (e) {
      return left(ServerFailure('Failed to fetch my pitches: $e'));
    }
  }

  @override
  FutureEither<List<Booking>> getMyBookings() async {
    try {
      final rawList = await _dataSource.getMyBookings();
      final bookings = rawList
          .map((b) => BookingModel.fromJson(b as Map<String, dynamic>))
          .toList();
      return right(bookings);
    } catch (e) {
      return left(ServerFailure('Failed to fetch bookings: $e'));
    }
  }

  @override
  FutureEither<List<MatchmakingMatch>> getAllMatches() async {
    try {
      final rawList = await _dataSource.getAllMatches();
      final matches = rawList
          .map((m) => MatchModel.fromJson(m as Map<String, dynamic>))
          .toList();
      return right(matches);
    } catch (e) {
      return left(ServerFailure('Failed to fetch matches: $e'));
    }
  }

  @override
  FutureEither<List<AppNotification>> getNotifications() async {
    try {
      final rawList = await _dataSource.getNotifications();
      final notifications = rawList
          .map((n) => AppNotification.fromJson(n as Map<String, dynamic>))
          .toList();
      return right(notifications);
    } catch (e) {
      return left(ServerFailure('Failed to fetch notifications: $e'));
    }
  }

  @override
  FutureEither<void> markNotificationsAsRead() async {
    try {
      await _dataSource.markNotificationsAsRead();
      return right(null);
    } catch (e) {
      return left(ServerFailure('Failed to mark notifications as read: $e'));
    }
  }

  @override
  FutureEither<AppUser> getProfile() async {
    try {
      final rawUser = await _dataSource.getProfile();
      final user = UserModel.fromJson(rawUser);
      return right(user);
    } catch (e) {
      return left(ServerFailure('Failed to fetch profile: $e'));
    }
  }

  @override
  FutureEither<bool> createPitch(
    Map<String, dynamic> pitchData, {
    List<int>? imageBytes,
    String? fileName,
  }) async {
    try {
      final success = await _dataSource.createPitch(
        pitchData,
        imageBytes: imageBytes,
        fileName: fileName,
      );
      if (success) return right(true);
      return left(const ServerFailure('Failed to create pitch'));
    } catch (e) {
      return left(ServerFailure('Failed to create pitch: $e'));
    }
  }

  @override
  FutureEither<bool> deletePitch(String id) async {
    try {
      final success = await _dataSource.deletePitch(id);
      if (success) return right(true);
      return left(const ServerFailure('Failed to delete pitch'));
    } catch (e) {
      return left(ServerFailure('Failed to delete pitch: $e'));
    }
  }

  @override
  FutureEither<bool> updatePitch(
    String id,
    Map<String, dynamic> pitchData, {
    List<int>? imageBytes,
    String? fileName,
  }) async {
    try {
      final success = await _dataSource.updatePitch(
        id,
        pitchData,
        imageBytes: imageBytes,
        fileName: fileName,
      );
      if (success) return right(true);
      return left(const ServerFailure('Failed to update pitch'));
    } catch (e) {
      return left(ServerFailure('Failed to update pitch: $e'));
    }
  }
}
