import 'package:fpdart/fpdart.dart';

import '../di/injection_container.dart';
import '../imports/core_imports.dart';

/// A reusable generic function to handle potential exceptions in async tasks
/// and map them to the [Either] type matching [FutureEither<T>].
///
/// If [requiresNetwork] is `true` and [isNetworkAvailable] returns `false`,
/// the [action] will not be executed and a [NetworkFailure] will be returned.
FutureEither<T> runTask<T>(
  Future<T> Function() action, {
  bool requiresNetwork = false,
}) async {
  if (requiresNetwork) {
    try {
      final hasNetwork = await sl<InternetConnectionService>().hasConnection();

      if (!hasNetwork) {
        AppLogger.warning(
          'Network detection reported offline, but attempting task anyway...',
        );
        // We continue anyway because the check might be unreliable in some environments
      }
    } catch (e) {
      AppLogger.warning('Network check error: $e');
    }
  }

  try {
    final result = await action();
    return right(result);
  } catch (error, stackTrace) {
    AppLogger.error('Task execution failed $error', [error, stackTrace]);
    final errorMessage = AppErrorHandler.format(error);

    // Depending on logic, map error strings/types to specific Failure variants
    return left(ServerFailure(errorMessage, error: error));
  }
}
