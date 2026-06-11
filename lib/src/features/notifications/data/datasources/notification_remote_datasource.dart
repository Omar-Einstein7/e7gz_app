import 'package:dio/dio.dart';
import 'package:e7gz/src/features/notifications/data/models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String id);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio dio;

  NotificationRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final response = await dio.get<Map<String, dynamic>>('notifications');
    final Map<String, dynamic> data =
        (response.data?['data'] ?? response.data) as Map<String, dynamic>;
    final List<dynamic> list =
        (data['notifications'] ?? <dynamic>[]) as List<dynamic>;
    return list
        .map((json) => NotificationModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> markAsRead(String id) async {
    // Current backend doesn't support individual read, we could implement it or just mark all
    // For now, let's keep it as is or use mark-read if needed
  }

  @override
  Future<void> markAllAsRead() async {
    await dio.put<dynamic>('notifications/mark-read');
  }

  @override
  Future<void> deleteNotification(String id) async {
    // Backend doesn't have delete yet, but endpoint would be this if added
    await dio.delete<dynamic>('notifications/$id');
  }
}
