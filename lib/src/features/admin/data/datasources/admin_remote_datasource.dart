import 'package:dio/dio.dart';
import 'package:e7gz/src/utils/logger.dart';

class AdminRemoteDataSource {
  final Dio _dio;

  AdminRemoteDataSource({required Dio dio}) : _dio = dio;

  /// Helper to extract data or return an empty fallback
  T _extractData<T>(Response<dynamic> response, String key, T fallback) {
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
      await _dio.put<dynamic>('notifications/mark-read');
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

  /// GET /api/pitches/upload-signature
  Future<Map<String, dynamic>> getUploadSignature() async {
    try {
      final response = await _dio.get<dynamic>('pitches/upload-signature');
      return _extractData<Map<String, dynamic>>(response, 'data', {});
    } catch (e) {
      AppLogger.error('Failed to get upload signature: $e');
      return {};
    }
  }

  /// Direct upload to Cloudinary using a signature
  Future<String?> _uploadToCloudinary({
    required List<int> bytes,
    required String filename,
    required Map<String, dynamic> signatureData,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          bytes,
          filename: filename,
          contentType: DioMediaType('image', 'jpeg'),
        ),
        'api_key': signatureData['apiKey'],
        'timestamp': signatureData['timestamp'],
        'signature': signatureData['signature'],
        'folder': signatureData['folder'],
      });

      final cloudName = signatureData['cloudName'];
      final uploadResponse = await Dio().post<Map<String, dynamic>>(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
        data: formData,
      );

      if (uploadResponse.statusCode == 200 ||
          uploadResponse.statusCode == 201) {
        return uploadResponse.data!['secure_url'] as String;
      }
      return null;
    } catch (e) {
      AppLogger.error('Cloudinary direct upload failed: $e');
      return null;
    }
  }

  /// POST /api/pitches
  /// Returns null on success, or error message on failure
  Future<String?> createPitch(
    Map<String, dynamic> pitchData, {
    List<List<int>>? multipleImageBytes,
    List<String>? multipleFileNames,
  }) async {
    try {
      final Map<String, dynamic> finalPayload = Map.from(pitchData);

      // Handle direct uploads if bytes are provided
      if (multipleImageBytes != null && multipleImageBytes.isNotEmpty) {
        AppLogger.info('🚀 Starting direct uploads to Cloudinary...');
        final signatureData = await getUploadSignature();
        if (signatureData.isEmpty) return 'Failed to get upload signature';

        final List<String> uploadedUrls = [];
        for (int i = 0; i < multipleImageBytes.length; i++) {
          final url = await _uploadToCloudinary(
            bytes: multipleImageBytes[i],
            filename:
                (multipleFileNames != null && multipleFileNames.length > i)
                ? multipleFileNames[i]
                : 'pitch_$i.jpg',
            signatureData: signatureData,
          );
          if (url != null) uploadedUrls.add(url);
        }

        if (uploadedUrls.isEmpty) {
          return 'Failed to upload images to Cloudinary';
        }

        // Combine with any existing URLs (unlikely for create, but good for consistency)
        final List<String> currentImages = List<String>.from(
          finalPayload['images'] ?? [],
        );
        finalPayload['images'] = [...currentImages, ...uploadedUrls];
      }

      AppLogger.info('🚀 Sending final JSON payload to backend...');
      final response = await _dio.post<dynamic>('pitches', data: finalPayload);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return null;
      }
      return 'Failed with status ${response.statusCode}';
    } catch (e) {
      String errorMessage = 'Failed to create pitch';
      if (e is DioException) {
        final responseData = e.response?.data;
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'].toString();
        } else {
          errorMessage = e.message ?? errorMessage;
        }
        AppLogger.error('Failed to create pitch (Dio): $errorMessage');
      } else {
        errorMessage = e.toString();
        AppLogger.error('Failed to create pitch: $errorMessage');
      }
      return errorMessage;
    }
  }

  /// DELETE /api/pitches/:id
  Future<bool> deletePitch(String id) async {
    try {
      final response = await _dio.delete<dynamic>('pitches/$id');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      if (e is DioException) {
        AppLogger.error(
          'Failed to delete pitch: ${e.response?.data ?? e.message}',
        );
      } else {
        AppLogger.error('Failed to delete pitch: $e');
      }
      return false;
    }
  }

  /// PUT /api/pitches/:id
  /// Returns null on success, or error message on failure
  Future<String?> updatePitch(
    String id,
    Map<String, dynamic> pitchData, {
    List<List<int>>? multipleImageBytes,
    List<String>? multipleFileNames,
  }) async {
    try {
      final Map<String, dynamic> finalPayload = Map.from(pitchData);

      // Handle direct uploads if bytes are provided
      if (multipleImageBytes != null && multipleImageBytes.isNotEmpty) {
        AppLogger.info('🚀 Starting direct uploads to Cloudinary...');
        final signatureData = await getUploadSignature();
        if (signatureData.isEmpty) return 'Failed to get upload signature';

        final List<String> uploadedUrls = [];
        for (int i = 0; i < multipleImageBytes.length; i++) {
          final url = await _uploadToCloudinary(
            bytes: multipleImageBytes[i],
            filename:
                (multipleFileNames != null && multipleFileNames.length > i)
                ? multipleFileNames[i]
                : 'pitch_$i.jpg',
            signatureData: signatureData,
          );
          if (url != null) uploadedUrls.add(url);
        }

        if (uploadedUrls.isEmpty) {
          return 'Failed to upload images to Cloudinary';
        }

        // Set them as 'newImages' for the backend to merge
        finalPayload['newImages'] = uploadedUrls;
      }

      AppLogger.info('🚀 Sending final JSON payload to pitches/$id');
      final response = await _dio.put<dynamic>(
        'pitches/$id',
        data: finalPayload,
      );
      AppLogger.info('✅ PUT response received: ${response.statusCode}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return null;
      }
      return 'Failed with status ${response.statusCode}';
    } catch (e) {
      String errorMessage = 'Failed to update pitch';
      if (e is DioException) {
        final responseData = e.response?.data;
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'].toString();
        } else {
          errorMessage = e.message ?? errorMessage;
        }
        AppLogger.error('Failed to update pitch (Dio): $errorMessage');
      } else {
        errorMessage = e.toString();
        AppLogger.error('Failed to update pitch: $errorMessage');
      }
      return errorMessage;
    }
  }
}
