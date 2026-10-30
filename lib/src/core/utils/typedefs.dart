import 'package:e7gz/src/core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';


typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;
typedef StreamEither<T> = Stream<Either<Failure, T>>;
