import 'dart:async';
import '../utils/utils.dart';
import 'secure_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

/// Keys used to persist the JWT in secure storage.
const _kAccessTokenKey = 'jwt_token';
const _kRefreshTokenKey = 'refresh_token';

class AuthService {
  final SecureStorageService _secureStorage;
  final Dio _dio;
  final Dio _authDio;

  AuthService({
    required SecureStorageService secureStorage,
    required Dio dio,
    required Dio authDio,
  }) : _secureStorage = secureStorage,
       _dio = dio,
       _authDio = authDio;

  final StreamController<Map<String, dynamic>?> _authStateController =
      StreamController<Map<String, dynamic>?>.broadcast();

  /// Stream of auth state changes. Emits the current user map or null.
  Stream<Map<String, dynamic>?> get authStateChanges =>
      _authStateController.stream;

  // ─── Internal token helpers ────────────────────────────────────────────────

  Future<void> _saveTokens(String accessToken, String? refreshToken) async {
    AppLogger.info('💾 Saving new tokens to secure storage');
    await _secureStorage.write(_kAccessTokenKey, accessToken);
    if (refreshToken != null) {
      await _secureStorage.write(_kRefreshTokenKey, refreshToken);
    }
  }

  /// Called at app startup to restore a previously saved token.
  Future<void> loadSavedToken() async {
    // No need to manually load into headers here, the Interceptor reads from storage
  }

  // ─── Auth operations ───────────────────────────────────────────────────────

  FutureEither<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    return runTask(() async {
      // Use authDio — NO Authorization header sent
      final response = await _authDio.post<dynamic>(
        'auth/login',
        data: {'email': email, 'password': password},
      );
      final data = response.data as Map<String, dynamic>;

      // Postman says: response.data.accessToken or token might be at the root
      final responseData = data['data'] ?? data;
      final accessToken =
          responseData['accessToken']?.toString() ?? data['token']?.toString();
      final refreshToken =
          responseData['refreshToken']?.toString() ??
          data['refreshToken']?.toString();

      if (accessToken != null && accessToken.isNotEmpty) {
        await _saveTokens(accessToken, refreshToken);
      } else {
        AppLogger.warning(
          '⚠️ Login successful but no token/accessToken found in response',
        );
      }

      _authStateController.add(responseData);
      return responseData;
    }, requiresNetwork: true);
  }

  FutureEither<Map<String, dynamic>?> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    String? role,
  }) async {
    return runTask(() async {
      // Use authDio — NO Authorization header sent
      final response = await _authDio.post<dynamic>(
        'auth/signup',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'role': (role ?? 'player').toLowerCase(),
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      final data = response.data as Map<String, dynamic>;

      final responseData = data['data'] ?? data;
      final accessToken =
          responseData['accessToken']?.toString() ?? data['token']?.toString();
      final refreshToken =
          responseData['refreshToken']?.toString() ??
          data['refreshToken']?.toString();

      if (accessToken != null && accessToken.isNotEmpty) {
        await _saveTokens(accessToken, refreshToken);
      } else {
        AppLogger.warning(
          '⚠️ Signup successful but no token/accessToken found in response',
        );
      }

      _authStateController.add(responseData);
      return responseData;
    }, requiresNetwork: true);
  }

  FutureEither<void> forgotPassword({required String email}) async {
    return runTask(() async {
      // Use authDio — no token needed
      await _authDio.post<dynamic>(
        'auth/forgot-password',
        data: {'email': email},
      );
    }, requiresNetwork: true);
  }

  FutureEither<String> verifyOtp({
    required String email,
    required String otp,
  }) async {
    return runTask(() async {
      final response = await _authDio.post<dynamic>(
        'auth/verify-otp',
        data: {'email': email, 'otp': otp},
      );
      final data = response.data as Map<String, dynamic>;
      final responseData = data['data'] ?? data;
      return responseData['resetToken'] as String;
    }, requiresNetwork: true);
  }

  FutureEither<void> resetPassword({
    required String email,
    required String resetToken,
    required String password,
  }) async {
    return runTask(() async {
      await _authDio.post<dynamic>(
        'auth/reset-password',
        data: {'email': email, 'resetToken': resetToken, 'password': password},
      );
    }, requiresNetwork: true);
  }

  FutureEither<void> logout() async {
    return runTask(() async {
      try {
        // Use authenticated dio — logout requires token
        await _dio.post<dynamic>('auth/logout');
      } catch (e) {
        AppLogger.error(
          'Logout request failed but continuing local logout: $e',
        );
      }
      await _secureStorage.delete(_kAccessTokenKey);
      await _secureStorage.delete(_kRefreshTokenKey);
      _authStateController.add(null);
    }, requiresNetwork: true);
  }

  FutureEither<Map<String, dynamic>?> getCurrentUser() async {
    return runTask(() async {
      final response = await _dio.get<dynamic>('auth/me');
      final data = response.data as Map<String, dynamic>;
      return data['data'] ?? data;
    });
  }

  Future<Map<String, dynamic>> _getUploadSignature() async {
    try {
      final response = await _dio.get<dynamic>('pitches/upload-signature');
      final data = response.data as Map<String, dynamic>;
      return (data['data'] ?? <String, dynamic>{}) as Map<String, dynamic>;
    } catch (e) {
      AppLogger.error('Failed to get upload signature: $e');
      return {};
    }
  }

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
      AppLogger.error('Cloudinary profile direct upload failed: $e');
      return null;
    }
  }

  FutureEither<Map<String, dynamic>?> updateProfile({
    String? name,
    String? phone,
    String? photoPath,
    String? password,
  }) async {
    return runTask(() async {
      final data = <String, dynamic>{};

      if (photoPath != null) {
        AppLogger.info('🚀 Starting direct profile photo upload...');
        final signatureData = await _getUploadSignature();
        if (signatureData.isNotEmpty) {
          final xfile = XFile(photoPath);
          final bytes = await xfile.readAsBytes();
          final url = await _uploadToCloudinary(
            bytes: bytes,
            filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
            signatureData: signatureData,
          );
          if (url != null) {
            data['photoUrl'] = url;
            AppLogger.info('✅ Profile photo uploaded: $url');
          }
        }
      }

      if (name != null) data['name'] = name;
      if (phone != null) data['phone'] = phone;
      if (password != null && password.isNotEmpty) data['password'] = password;

      AppLogger.info('🚀 Sending profile update JSON to backend...');
      final response = await _dio.put<dynamic>('auth/me', data: data);
      final Map<String, dynamic> responseBody =
          response.data as Map<String, dynamic>;
      final Map<String, dynamic> userMap =
          (responseBody['data'] ?? responseBody) as Map<String, dynamic>;

      _authStateController.add(userMap);
      return userMap;
    });
  }

  /// Refreshes the access token using the stored refresh token.
  /// Uses authDio — MUST NOT send Authorization header.
  Future<bool> refreshAccessToken() async {
    AppLogger.info('🔄 Attempting to refresh access token...');
    try {
      final refreshTokenResult = await _secureStorage.read(_kRefreshTokenKey);
      String? storedRefreshToken;
      refreshTokenResult.fold((_) => null, (v) => storedRefreshToken = v);

      if (storedRefreshToken == null || storedRefreshToken!.isEmpty) {
        AppLogger.warning('❌ Refresh token not found in storage');
        return false;
      }

      // Use authDio to avoid token injection loop
      final response = await _authDio.post<dynamic>(
        'auth/refresh',
        data: {'refreshToken': storedRefreshToken},
      );

      final data = response.data as Map<String, dynamic>;
      final responseData = data['data'] ?? data;
      final newAccessToken = responseData['accessToken']?.toString();

      if (newAccessToken != null) {
        AppLogger.info('✅ Token refreshed successfully');
        await _secureStorage.write(_kAccessTokenKey, newAccessToken);
        return true;
      }
      AppLogger.warning('❌ Refresh response did not contain a new accessToken');
      return false;
    } catch (e) {
      AppLogger.error('❌ Token refresh failed: $e');
      return false;
    }
  }

  void dispose() {
    _authStateController.close();
  }
}
