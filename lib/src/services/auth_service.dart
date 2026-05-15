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

      // Postman says: response.data.accessToken
      final responseData = data['data'] ?? data;
      final accessToken = responseData['accessToken']?.toString();
      final refreshToken = responseData['refreshToken']?.toString();

      if (accessToken != null) {
        await _saveTokens(accessToken, refreshToken);
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
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      final data = response.data as Map<String, dynamic>;

      final responseData = data['data'] ?? data;
      final accessToken = responseData['accessToken']?.toString();
      final refreshToken = responseData['refreshToken']?.toString();

      if (accessToken != null) {
        await _saveTokens(accessToken, refreshToken);
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

  FutureEither<Map<String, dynamic>?> updateProfile({
    String? name,
    String? phone,
    String? photoPath,
  }) async {
    return runTask(() async {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (phone != null) data['phone'] = phone;
      
      final formData = FormData.fromMap(data);
      if (photoPath != null) {
        final xfile = XFile(photoPath);
        final bytes = await xfile.readAsBytes();
        formData.files.add(
          MapEntry(
            'photo',
            MultipartFile.fromBytes(
              bytes,
              filename: 'profile_pic.jpg',
              contentType: DioMediaType('image', 'jpeg'),
            ),
          ),
        );
      }

      final response = await _dio.put<dynamic>('auth/me', data: formData);
      final responseData = response.data as Map<String, dynamic>;
      final userMap = responseData['data'] ?? responseData;
      
      _authStateController.add(userMap);
      return userMap;
    });
  }

  /// Refreshes the access token using the stored refresh token.
  /// Uses authDio — MUST NOT send Authorization header.
  Future<bool> refreshAccessToken() async {
    try {
      final refreshTokenResult = await _secureStorage.read(_kRefreshTokenKey);
      String? storedRefreshToken;
      refreshTokenResult.fold((_) => null, (v) => storedRefreshToken = v);

      if (storedRefreshToken == null || storedRefreshToken!.isEmpty)
        return false;

      // Use authDio to avoid token injection loop
      final response = await _authDio.post<dynamic>(
        'auth/refresh',
        data: {'refreshToken': storedRefreshToken},
      );

      final data = response.data as Map<String, dynamic>;
      final responseData = data['data'] ?? data;
      final newAccessToken = responseData['accessToken']?.toString();

      if (newAccessToken != null) {
        await _secureStorage.write(_kAccessTokenKey, newAccessToken);
        return true;
      }
      return false;
    } catch (e) {
      AppLogger.error('Token refresh failed: $e');
      return false;
    }
  }

  void dispose() {
    _authStateController.close();
  }
}
