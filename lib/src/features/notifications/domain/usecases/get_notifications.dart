import 'package:e7gz/src/imports/core_imports.dart';
import '../entities/notification.dart';
import '../repositories/notification_repository.dart';

class GetNotifications {
  final NotificationRepository repository;

  GetNotifications(this.repository);

  FutureEither<List<AppNotification>> call() {
    return repository.getNotifications();
  }
}
