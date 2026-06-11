import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/features/notifications/domain/entities/notification.dart';

abstract class NotificationRepository {
  FutureEither<List<AppNotification>> getNotifications();
  FutureEither<void> markAsRead(String notificationId);
  FutureEither<void> markAllAsRead();
  FutureEither<void> deleteNotification(String notificationId);
}
