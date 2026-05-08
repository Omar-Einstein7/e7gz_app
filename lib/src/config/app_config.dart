import '../imports/core_imports.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
    final baseOptions = BaseOptions(
      baseUrl: _getBaseUrl(),
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

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
    authDio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          AppLogger.info(
            '🌐 [AUTH] REQUEST[${options.method}] => PATH: ${options.path}',
          );
          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.info(
            '✅ [AUTH] RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (e, handler) {
          AppLogger.error(
            '❌ [AUTH] ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}',
          );
          return handler.next(e);
        },
      ),
    );

    // ── Protected Client (token injection + auto-refresh on 401) ─────────────
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
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          AppLogger.info(
            '🌐 [DIO] REQUEST[${options.method}] => PATH: ${options.path}',
          );

          // Always inject token — this client is only used for protected routes
          final tokenResult = await SecureStorageService.instance.read(
            'jwt_token',
          );
          tokenResult.fold((_) {}, (token) {
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          });

          AppLogger.info('🔑 HEADERS: ${options.headers}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.info(
            '✅ [DIO] RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          final errorBody = e.response?.data;
          AppLogger.error(
            '❌ [DIO] ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path} => BODY: $errorBody',
          );

          if (e.response?.statusCode == 401) {
            try {
              final isRefreshed = await AuthService.instance
                  .refreshAccessToken();
              if (isRefreshed) {
                final tokenResult = await SecureStorageService.instance.read(
                  'jwt_token',
                );
                String? newToken;
                tokenResult.fold((_) => null, (v) => newToken = v);

                if (newToken != null && newToken!.isNotEmpty) {
                  e.requestOptions.headers['Authorization'] =
                      'Bearer $newToken';
                  try {
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
                  } on DioException catch (retryError) {
                    return handler.next(retryError);
                  }
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
      fallback: 'https://e7gz-backend.onrender.com/api',
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
