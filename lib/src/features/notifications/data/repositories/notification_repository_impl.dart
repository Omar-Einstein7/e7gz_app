import 'package:e7gz/src/core/utils/task_runner.dart';
import 'package:e7gz/src/core/utils/typedefs.dart';
import 'package:e7gz/src/features/notifications/domain/entities/notification.dart';
import 'package:e7gz/src/features/notifications/domain/repositories/notification_repository.dart';
import 'package:e7gz/src/features/notifications/data/datasources/notification_remote_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  FutureEither<List<AppNotification>> getNotifications() {
    return runTask(
      () => remoteDataSource.getNotifications(),
      requiresNetwork: true,
    );
  }

  @override
  FutureEither<void> markAsRead(String notificationId) {
    return runTask(
      () => remoteDataSource.markAsRead(notificationId),
      requiresNetwork: true,
    );
  }

  @override
  FutureEither<void> markAllAsRead() {
    return runTask(
      () => remoteDataSource.markAllAsRead(),
      requiresNetwork: true,
    );
  }

  @override
  FutureEither<void> deleteNotification(String notificationId) {
    return runTask(
      () => remoteDataSource.deleteNotification(notificationId),
      requiresNetwork: true,
    );
  }
}
