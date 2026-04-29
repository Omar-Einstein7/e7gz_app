import 'package:e7gz/src/imports/imports.dart';
import 'package:e7gz/src/features/notifications/domain/entities/notification.dart';
import 'package:e7gz/src/features/notifications/domain/repositories/notification_repository.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationRepository repository;

  NotificationsCubit({required this.repository}) : super(const NotificationsState());

  Future<void> loadNotifications() async {
    emit(state.copyWith(status: NotificationsStatus.loading));
    
    final result = await repository.getNotifications();

    result.fold(
      (failure) => emit(state.copyWith(
        status: NotificationsStatus.failure,
        errorMessage: failure.message,
      )),
      (notifications) {
        emit(state.copyWith(
          status: NotificationsStatus.success,
          notifications: notifications,
        ));
      },
    );
  }

  Future<void> markAllRead() async {
    final result = await repository.markAllAsRead();
    
    result.fold(
      (failure) => null,
      (success) {
        final List<AppNotification> updated = state.notifications.map((AppNotification n) => AppNotification(
          id: n.id,
          title: n.title,
          body: n.body,
          type: n.type,
          isRead: true,
          createdAt: n.createdAt,
        )).toList();
        emit(state.copyWith(notifications: updated));
      },
    );
  }
}
