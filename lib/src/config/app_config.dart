import '../imports/core_imports.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();
  static late final Dio dio;

  static String get baseUrl => _getBaseUrl();

  static Future<void> init() async {
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
          AppLogger.info('🌐 [DIO] REQUEST[${options.method}] => PATH: ${options.path}');
          
          // Inject Token from Secure Storage
          final tokenResult = await SecureStorageService.instance.read('jwt_token');
          tokenResult.fold(
            (_) {},
            (token) {
              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
              }
            },
          );

          AppLogger.info('🔑 HEADERS: ${options.headers}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.info('✅ [DIO] RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          AppLogger.error('❌ [DIO] ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
          return handler.next(e);
        },
      ),
    );

  }

  static String _getBaseUrl() {
    return dotenv.get('API_BASE_URL', fallback: 'http://192.168.1.7:3000/api');
  }
}
