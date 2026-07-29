import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Base UseCase interface following Clean Architecture
/// [T] = return type, [Params] = input parameters
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// UseCase with no parameters
abstract class UseCaseNoParams<T> {
  Future<Either<Failure, T>> call();
}

/// UseCase that returns a Stream
abstract class StreamUseCase<T, Params> {
  Stream<Either<Failure, T>> call(Params params);
}

/// Represents absence of parameters
class NoParams {
  const NoParams();
}
