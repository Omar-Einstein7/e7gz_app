import 'package:dio/dio.dart';

class AppErrorHandler {
  static String format(dynamic error) {
    if (error is String) return error;

    if (error is DioException) {
      final response = error.response;
      if (response != null && response.data != null) {
        final data = response.data;
        if (data is Map && data.containsKey('message')) {
          return data['message'].toString();
        }
      }

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timed out. Please check your internet.';
        case DioExceptionType.connectionError:
          return 'No internet connection.';
        default:
          return error.message ?? 'Server error occurred';
      }
    }

    try {
      if (error?.message != null) return error.message;
      return error.toString();
    } catch (_) {
      return 'An unexpected error occurred';
    }
  }
}
