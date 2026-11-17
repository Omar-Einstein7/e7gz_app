import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:e7gz/src/utils/logger.dart';

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

    AppLogger.error(
      '[ServerFailure] DioException caught\n'
      '  type        : ${error.type}\n'
      '  statusCode  : $statusCode\n'
      '  url         : ${error.requestOptions.uri}\n'
      '  method      : ${error.requestOptions.method}\n'
      '  rawData     : ${response?.data}\n'
      '  dioMessage  : ${error.message}',
    );

    String message = 'An unexpected server error occurred';

    if (response != null && response.data != null) {
      dynamic data = response.data;
      if (data is String) {
        try {
          data = jsonDecode(data);
        } catch (_) {}
      }

      if (data is Map) {
        if (data.containsKey('message') && data['message'] != null) {
          message = data['message'].toString();
        } else if (data.containsKey('error') && data['error'] != null) {
          message = data['error'].toString();
        } else if (data.containsKey('msg') && data['msg'] != null) {
          message = data['msg'].toString();
        }

        if (data.containsKey('errors') && data['errors'] is List) {
          final list = data['errors'] as List;
          final errorMsgs = list
              .map((e) =>
                  e is Map && e.containsKey('message')
                      ? e['message'].toString()
                      : e.toString())
              .where((m) => m.isNotEmpty)
              .toList();
          if (errorMsgs.isNotEmpty) {
            message = errorMsgs.join(', ');
          }
        }
      } else if (data is String && data.isNotEmpty) {
        message = data;
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

    if (message == 'An unexpected server error occurred' && statusCode != null) {
      if (statusCode == 401) {
        message = 'Invalid email or password.';
      } else if (statusCode == 404) {
        message = 'Requested service not found (404).';
      } else if (statusCode >= 500) {
        message = 'Server error ($statusCode). Please try again later.';
      }
    }

    AppLogger.warning('[ServerFailure] resolved message: "$message" (statusCode: $statusCode)');

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
