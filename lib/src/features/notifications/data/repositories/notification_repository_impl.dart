import 'package:fpdart/fpdart.dart';
import 'package:e7gz/src/utils/failure.dart';
import 'package:e7gz/src/utils/typedefs.dart';
import 'package:e7gz/src/features/notifications/domain/entities/notification.dart';
import 'package:e7gz/src/features/notifications/domain/repositories/notification_repository.dart';
import 'package:e7gz/src/features/notifications/data/datasources/notification_remote_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  FutureEither<List<AppNotification>> getNotifications() async {
    try {
      final notifications = await remoteDataSource.getNotifications();
      return right(notifications);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> markAsRead(String notificationId) async {
    try {
      await remoteDataSource.markAsRead(notificationId);
      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> markAllAsRead() async {
    try {
      await remoteDataSource.markAllAsRead();
      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> deleteNotification(String notificationId) async {
    try {
      await remoteDataSource.deleteNotification(notificationId);
      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
