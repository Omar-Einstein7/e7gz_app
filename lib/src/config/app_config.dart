import '../imports/core_imports.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

class AppConfig {
  AppConfig._();

  /// Authenticated client — used for all protected API calls.
  /// Automatically injects the Bearer token and retries once on 401.
  static late final Dio dio;

  /// Clean client — used ONLY for auth endpoints (login, signup, refresh).
  /// No token injection, no retry logic. Prevents refresh loops.
  static late final Dio authDio;

  static String get baseUrl => _getBaseUrl();

  static Future<void> init() async {
    // ── Clean Auth Client (no token injection, no retry) ─────────────────────
    authDio = Dio(
      BaseOptions(
        baseUrl: _getBaseUrl(),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // ── Protected Client (Base Setup) ─────────────────────
    dio = Dio(
      BaseOptions(
        baseUrl: _getBaseUrl(),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  /// Attaches interceptors that depend on [GetIt] services.
  /// This MUST be called after [initDependencies].
  static void attachInterceptors({
    required SecureStorageService secureStorage,
    required AuthService authService,
  }) {
    // ── Auth Client Logging ─────────────────────
    authDio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          AppLogger.info('🌐 [AUTH] REQUEST[${options.method}] => PATH: ${options.path}');
          // Note: We don't log the request body here to prevent leaking credentials in logs
          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.info('✅ [AUTH] RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (e, handler) {
          // Log only the status code and path, avoiding the body which might contain sensitive info
          AppLogger.error('❌ [AUTH] ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
          return handler.next(e);
        },
      ),
    );

    // ── Protected Client (Token Injection + Refresh) ─────────────────────
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          AppLogger.info('🌐 [DIO] REQUEST[${options.method}] => PATH: ${options.path}');

          final tokenResult = await secureStorage.read('jwt_token');
          tokenResult.fold((_) {}, (token) {
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          });

          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.info('✅ [DIO] RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          final errorBody = e.response?.data;
          AppLogger.error('❌ [DIO] ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path} => BODY: $errorBody');

          if (e.response?.statusCode == 401) {
            try {
              final isRefreshed = await authService.refreshAccessToken();
              if (isRefreshed) {
                final tokenResult = await secureStorage.read('jwt_token');
                String? newToken;
                tokenResult.fold((_) => null, (v) => newToken = v);

                if (newToken != null && newToken!.isNotEmpty) {
                  e.requestOptions.headers['Authorization'] = 'Bearer $newToken';
                  final response = await dio.request<dynamic>(
                    e.requestOptions.path,
                    data: e.requestOptions.data,
                    queryParameters: e.requestOptions.queryParameters,
                    options: Options(
                      method: e.requestOptions.method,
                      headers: e.requestOptions.headers,
                    ),
                  );
                  return handler.resolve(response);
                }
              }
            } catch (err) {
              AppLogger.error('Token refresh failed: $err');
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  static String _getBaseUrl() {
    String url = dotenv.get(
      'API_BASE_URL',
      fallback: 'https://api.e7gzz.com/api',
    );

    if (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }
    if (!url.endsWith('/api')) {
      url = '$url/api';
    }

    // Always end with slash for Dio relative paths
    return '$url/';
  }
}
