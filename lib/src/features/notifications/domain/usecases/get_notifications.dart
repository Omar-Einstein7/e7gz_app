import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/features/notifications/domain/entities/notification.dart';
import 'package:e7gz/src/features/notifications/domain/repositories/notification_repository.dart';

class GetNotifications {
  final NotificationRepository repository;

  GetNotifications(this.repository);

  FutureEither<List<AppNotification>> call() {
    return repository.getNotifications();
  }
}
