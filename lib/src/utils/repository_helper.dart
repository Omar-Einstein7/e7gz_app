import 'package:dio/dio.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'failure.dart';

/// A helper mixin for repositories to handle exceptions and return [Either].
mixin RepositoryHelper {
  /// Wraps a repository call and maps exceptions to [Failure].
  Future<Either<Failure, T>> mapException<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDio(e));
    } on TypeError catch (e) {
      return Left(UnknownFailure('Data parsing error', error: e));
    } catch (e) {
      return Left(UnknownFailure(e.toString(), error: e));
    }
  }
}
