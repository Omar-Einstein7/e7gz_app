import 'package:dio/dio.dart';
import '../models/notification_model.dart';

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
    final response = await dio.get('/notifications');
    final List data = response.data['data'] ?? response.data;
    return data.map((json) => NotificationModel.fromJson(json)).toList();
  }

  @override
  Future<void> markAsRead(String id) async {
    await dio.patch('/notifications/$id/read');
  }

  @override
  Future<void> markAllAsRead() async {
    await dio.patch('/notifications/read-all');
  }

  @override
  Future<void> deleteNotification(String id) async {
    await dio.delete('/notifications/$id');
  }
}
