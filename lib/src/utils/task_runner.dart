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
      // Add a small timeout to avoid hanging on slow network checks
      final hasNetwork = await sl<InternetConnectionService>()
          .hasConnection()
          .timeout(const Duration(seconds: 2));

      if (!hasNetwork) {
        return left(const NetworkFailure());
      }
    } catch (e) {
      AppLogger.warning(
        'Network check failed or timed out, proceeding anyway: $e',
      );
      // If network check fails or times out, we still attempt the task
      // and let Dio handle actual network errors.
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
      return left(
        UnknownFailure('Data parsing error: ${error.toString()}', error: error),
      );
    }

    return left(UnknownFailure(error.toString(), error: error));
  }
}
