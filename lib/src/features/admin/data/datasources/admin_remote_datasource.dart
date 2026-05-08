import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../config/app_config.dart';
import '../../../../utils/logger.dart';

class AdminRemoteDataSource {
  final Dio _dio = AppConfig.dio;

  /// Helper to extract data or return an empty fallback
  T _extractData<T>(Response response, String key, T fallback) {
    try {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        // If data is wrapped in a 'data' key (e.g. { "data": { "pitches": [] } } or { "data": [] })
        if (data.containsKey('data')) {
          final innerData = data['data'];
          if (innerData is T) return innerData;
          if (innerData is Map<String, dynamic> && innerData.containsKey(key)) {
            final deeplyInnerData = innerData[key];
            if (deeplyInnerData is T) return deeplyInnerData;
          }
        }
        // If the key is at the top level (e.g. { "pitches": [] })
        if (data.containsKey(key)) {
          final innerData = data[key];
          if (innerData is T) return innerData;
        }
      }
      if (data is T) return data;
      return fallback;
    } catch (e) {
      AppLogger.error('Data extraction failed for $key: $e');
      return fallback;
    }
  }

  /// GET /api/owner/stats
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final response = await _dio.get<dynamic>('owner/stats');
      return _extractData<Map<String, dynamic>>(response, 'stats', {});
    } catch (e) {
      AppLogger.error('Failed to fetch dashboard stats: $e');
      return {};
    }
  }

  /// GET /api/pitches
  Future<List<dynamic>> getAllPitches() async {
    try {
      final response = await _dio.get<dynamic>('pitches');
      return _extractData<List<dynamic>>(response, 'pitches', []);
    } catch (e) {
      AppLogger.error('Failed to fetch all pitches: $e');
      return [];
    }
  }

  /// GET /api/pitches/owner/my-pitches
  Future<List<dynamic>> getMyPitches() async {
    try {
      final response = await _dio.get<dynamic>('pitches/owner/my-pitches');
      return _extractData<List<dynamic>>(response, 'pitches', []);
    } catch (e) {
      AppLogger.error('Failed to fetch my pitches: $e');
      return [];
    }
  }

  /// GET /api/bookings
  Future<List<dynamic>> getMyBookings() async {
    try {
      final response = await _dio.get<dynamic>('bookings');
      return _extractData<List<dynamic>>(response, 'bookings', []);
    } catch (e) {
      AppLogger.error('Failed to fetch bookings: $e');
      return [];
    }
  }

  /// GET /api/matches
  Future<List<dynamic>> getAllMatches() async {
    try {
      final response = await _dio.get<dynamic>('matches');
      return _extractData<List<dynamic>>(response, 'matches', []);
    } catch (e) {
      AppLogger.error('Failed to fetch matches: $e');
      return [];
    }
  }

  /// GET /api/notifications
  Future<List<dynamic>> getNotifications() async {
    try {
      final response = await _dio.get<dynamic>('notifications');
      return _extractData<List<dynamic>>(response, 'notifications', []);
    } catch (e) {
      AppLogger.error('Failed to fetch notifications: $e');
      return [];
    }
  }

  /// PUT /api/notifications/mark-read
  Future<void> markNotificationsAsRead() async {
    try {
      await _dio.put('notifications/mark-read');
    } catch (e) {
      AppLogger.error('Failed to mark notifications as read: $e');
    }
  }

  /// GET /api/auth/me
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _dio.get<dynamic>('auth/me');
      return _extractData<Map<String, dynamic>>(response, 'user', {});
    } catch (e) {
      AppLogger.error('Failed to fetch profile: $e');
      return {};
    }
  }

  /// POST /api/pitches
  Future<bool> createPitch(
    Map<String, dynamic> pitchData, {
    List<int>? imageBytes,
    String? fileName,
  }) async {
    try {
      dynamic data;

      if (imageBytes != null) {
        final Map<String, dynamic> mappedData = Map.from(pitchData);

        // Stringify nested objects for multipart compatibility
        if (mappedData['location'] != null) {
          mappedData['location'] = jsonEncode(mappedData['location']);
        }
        if (mappedData['amenities'] != null) {
          mappedData['amenities'] = jsonEncode(mappedData['amenities']);
        }
        // Ensure primitive numbers are strings in FormData
        if (mappedData['pricePerHour'] != null) {
          mappedData['pricePerHour'] = mappedData['pricePerHour'].toString();
        }

        data = FormData.fromMap({
          ...mappedData,
          'images': MultipartFile.fromBytes(
            imageBytes,
            filename: fileName ?? 'pitch.jpg',
          ),
        });
        AppLogger.info('Sending pitch with images (Multipart)');
      } else {
        data = pitchData;
        AppLogger.info('Sending pitch (JSON)');
      }

      // IMPORTANT: Intercepts or BaseOptions might force application/json.
      // We must explicitly override it to multipart/form-data when sending FormData.
      final response = await _dio.post(
        'pitches',
        data: data,
        options: imageBytes != null
            ? Options(contentType: 'multipart/form-data')
            : null,
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      if (e is DioException) {
        AppLogger.error(
          'Failed to create pitch: ${e.response?.data ?? e.message}',
        );
      } else {
        AppLogger.error('Failed to create pitch: $e');
      }
      return false;
    }
  }
}
