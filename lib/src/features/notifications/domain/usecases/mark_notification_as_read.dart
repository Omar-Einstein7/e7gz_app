import 'package:e7gz/src/imports/core_imports.dart';

import 'package:e7gz/src/features/notifications/domain/repositories/notification_repository.dart';

class MarkNotificationAsRead {
  final NotificationRepository repository;

  MarkNotificationAsRead(this.repository);

  FutureEither<void> call(String id) {
    return repository.markAsRead(id);
  }
}
