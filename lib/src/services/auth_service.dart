import 'dart:async';
import '../utils/utils.dart';
import '../config/app_config.dart';
import 'secure_storage_service.dart';
import 'package:dio/dio.dart';

/// Keys used to persist the JWT in secure storage.
const _kAccessTokenKey = 'jwt_token';
const _kRefreshTokenKey = 'refresh_token';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  /// Clean Dio for unauthenticated auth endpoints (login, signup, refresh)
  Dio get _authDio => AppConfig.authDio;

  /// Authenticated Dio for protected endpoints (me, logout)
  Dio get _dio => AppConfig.dio;

  final StreamController<Map<String, dynamic>?> _authStateController =
      StreamController<Map<String, dynamic>?>.broadcast();

  /// Stream of auth state changes. Emits the current user map or null.
  Stream<Map<String, dynamic>?> get authStateChanges =>
      _authStateController.stream;

  // ─── Internal token helpers ────────────────────────────────────────────────

  Future<void> _saveTokens(String accessToken, String? refreshToken) async {
    await SecureStorageService.instance.write(_kAccessTokenKey, accessToken);
    if (refreshToken != null) {
      await SecureStorageService.instance.write(_kRefreshTokenKey, refreshToken);
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
      final response = await _authDio.post<dynamic>('auth/login', data: {
        'email': email,
        'password': password,
      });
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
      final response = await _authDio.post<dynamic>('auth/signup', data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'role': role ?? 'player',
      });
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
      await _authDio.post<dynamic>('auth/forgot-password', data: {'email': email});
    }, requiresNetwork: true);
  }

  FutureEither<void> logout() async {
    return runTask(() async {
      try {
        // Use authenticated dio — logout requires token
        await _dio.post<dynamic>('auth/logout');
      } catch (e) {
        AppLogger.error('Logout request failed but continuing local logout: $e');
      }
      await SecureStorageService.instance.delete(_kAccessTokenKey);
      await SecureStorageService.instance.delete(_kRefreshTokenKey);
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

  /// Refreshes the access token using the stored refresh token.
  /// Uses authDio — MUST NOT send Authorization header.
  Future<bool> refreshAccessToken() async {
    try {
      final refreshTokenResult = await SecureStorageService.instance.read(_kRefreshTokenKey);
      String? storedRefreshToken;
      refreshTokenResult.fold((_) => null, (v) => storedRefreshToken = v);

      if (storedRefreshToken == null || storedRefreshToken!.isEmpty) return false;

      // Use authDio to avoid token injection loop
      final response = await _authDio.post<dynamic>('auth/refresh', data: {
        'refreshToken': storedRefreshToken,
      });

      final data = response.data as Map<String, dynamic>;
      final responseData = data['data'] ?? data;
      final newAccessToken = responseData['accessToken']?.toString();

      if (newAccessToken != null) {
        await SecureStorageService.instance.write(_kAccessTokenKey, newAccessToken);
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
