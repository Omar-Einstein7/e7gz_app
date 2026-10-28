import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final dynamic error;
  final int? statusCode;

  const Failure(this.message, {this.error, this.statusCode});

  @override
  List<Object?> get props => [message, error, statusCode];

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.error, super.statusCode});

  factory ServerFailure.fromDio(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;

    String message = 'An unexpected server error occurred';

    if (response != null && response.data != null) {
      final data = response.data;
      if (data is Map && data.containsKey('message')) {
        message = data['message'].toString();
      }
    } else {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          message = 'Connection timed out. Please check your internet.';
        case DioExceptionType.connectionError:
          message = 'No internet connection.';
        case DioExceptionType.badResponse:
          message = 'Server returned an invalid response ($statusCode)';
        default:
          message = error.message ?? message;
      }
    }

    return ServerFailure(message, error: error, statusCode: statusCode);
  }
}

class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.error});
}

class NetworkFailure extends Failure {
  const NetworkFailure([String? message])
    : super(message ?? 'No internet connection');
}

class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.statusCode});
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message, {super.error});
}
