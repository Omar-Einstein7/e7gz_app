import 'package:dio/dio.dart';
import 'package:e7gz/src/utils/utils.dart';

/// A robust networking service powered by Dio.
class DioService {
  final Dio _dio;

  DioService({required Dio dio}) : _dio = dio;

  // --- HTTP Methods ---

  FutureEither<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return runTask(
      () => _dio.get<dynamic>(path, queryParameters: queryParameters),
      requiresNetwork: true,
    );
  }

  FutureEither<Response<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return runTask(
      () => _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
      ),
      requiresNetwork: true,
    );
  }

  FutureEither<Response<dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return runTask(
      () =>
          _dio.put<dynamic>(path, data: data, queryParameters: queryParameters),
      requiresNetwork: true,
    );
  }

  FutureEither<Response<dynamic>> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return runTask(
      () => _dio.patch<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
      ),
      requiresNetwork: true,
    );
  }

  FutureEither<Response<dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return runTask(
      () => _dio.delete<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
      ),
      requiresNetwork: true,
    );
  }
}
