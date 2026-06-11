import 'package:fpdart/fpdart.dart';
import 'package:e7gz/src/utils/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;
typedef StreamEither<T> = Stream<Either<Failure, T>>;
