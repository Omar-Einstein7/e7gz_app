import 'dart:async';
import '../utils/utils.dart';
import '../config/app_config.dart';
import 'secure_storage_service.dart';
import 'package:dio/dio.dart';

/// Key used to persist the JWT in secure storage.
const _kTokenKey = 'jwt_token';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  Dio get _dio => AppConfig.dio;

  final StreamController<Map<String, dynamic>?> _authStateController =
      StreamController<Map<String, dynamic>?>.broadcast();

  /// Stream of auth state changes. Emits the current user map or null.
  Stream<Map<String, dynamic>?> get authStateChanges =>
      _authStateController.stream;

  // ─── Internal token helpers ────────────────────────────────────────────────

  Future<void> _saveAndInjectToken(String token) async {
    await SecureStorageService.instance.write(_kTokenKey, token);
    // Token injection is now handled by the Dio Interceptor in AppConfig
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
      final response = await _dio.post<dynamic>('/auth/login', data: {
        'email': email,
        'password': password,
      });
      final data = response.data as Map<String, dynamic>;
      final token = data['data']?['token']?.toString() ?? data['token']?.toString();
      if (token != null) await _saveAndInjectToken(token);
      _authStateController.add(data['data'] ?? data);
      return data['data'] ?? data;
    }, requiresNetwork: true);
  }

  FutureEither<Map<String, dynamic>?> signUp({
    required String name,
    required String email,
    required String password,
    String? role,
  }) async {
    return runTask(() async {
      final response = await _dio.post<dynamic>('/auth/signup', data: {
        'name': name,
        'email': email,
        'password': password,
        'role': role ?? 'player',
      });
      final data = response.data as Map<String, dynamic>;
      final token = data['data']?['token']?.toString() ?? data['token']?.toString();
      if (token != null) await _saveAndInjectToken(token);
      _authStateController.add(data['data'] ?? data);
      return data['data'] ?? data;
    }, requiresNetwork: true);
  }

  FutureEither<void> forgotPassword({required String email}) async {
    return runTask(() async {
      await _dio.post<dynamic>('/auth/forgot-password', data: {'email': email});
    }, requiresNetwork: true);
  }

  FutureEither<void> logout() async {
    return runTask(() async {
      await _dio.post<dynamic>('/auth/logout');
      await SecureStorageService.instance.delete(_kTokenKey);
      AppConfig.dio.options.headers.remove('Authorization');
      _authStateController.add(null);
    }, requiresNetwork: true);
  }

  FutureEither<Map<String, dynamic>?> getCurrentUser() async {
    return runTask(() async {
      final response = await _dio.get<dynamic>('/auth/me');
      final data = response.data as Map<String, dynamic>;
      return data['data'] ?? data;
    });
  }

  void dispose() {
    _authStateController.close();
  }
}
