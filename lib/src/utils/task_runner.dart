import 'package:fpdart/fpdart.dart';
import 'package:dio/dio.dart';

import '../di/injection_container.dart';
import '../imports/core_imports.dart';
import 'failure.dart';
import 'typedefs.dart';

/// A reusable generic function to handle potential exceptions in async tasks
/// and map them to the [Either] type matching [FutureEither<T>].
FutureEither<T> runTask<T>(
  Future<T> Function() action, {
  bool requiresNetwork = false,
}) async {
  if (requiresNetwork) {
    try {
      final hasNetwork = await sl<InternetConnectionService>().hasConnection();

      if (!hasNetwork) {
        return left(const NetworkFailure());
      }
    } catch (e) {
      AppLogger.warning('Network check error: $e');
      // If network check fails, we still attempt the task
    }
  }

  try {
    final result = await action();
    return right(result);
  } catch (error, stackTrace) {
    AppLogger.error('Task execution failed', [error, stackTrace]);
    
    if (error is DioException) {
      return left(ServerFailure.fromDio(error));
    }
    
    if (error is TypeError) {
      return left(UnknownFailure('Data parsing error: ${error.toString()}', error: error));
    }

    return left(UnknownFailure(error.toString(), error: error));
  }
}
