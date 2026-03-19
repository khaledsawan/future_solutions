import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:future_solutions/core/model/i_params.dart';

/// Base class for all use cases in the application.
///
/// Use cases encapsulate single business operations and depend on repository interfaces.
///
/// **Type Parameters:**
/// - `Type`: The return type when the use case succeeds
/// - `Params`: The parameter class for the use case input (must extend `Params`)
///
/// **Return Type:**
/// Returns `Future<Either>` where:
/// - `Either.left` contains an error (typically a `Failure` object)
/// - `Either.right` contains the successful result of type `Type`
///
/// **Note on Type Safety:**
/// The return type is `Future<Either>` (without explicit type parameters) for backward compatibility.
/// In practice, this resolves to `Future<Either<Object, Type>>` where the left side may contain
/// any error object (typically a `Failure`). For fully type-safe implementations, consider using
/// `Future<Either<Failure, Type>>` explicitly in concrete use case implementations.
///
/// **Example:**
/// ```dart
/// class GetUserUseCase extends UseCase<User, GetUserParams> {
///   final UserRepository repository;
///
///   GetUserUseCase({required this.repository});
///
///   @override
///   Future<Either> call(GetUserParams params) => repository.getUser(id: params.id);
/// }
/// ```
// ignore: avoid_types_as_parameter_names
abstract class UseCase<Type, Params> {
  Future<Either> call(Params params);
}

/// Parameters class for methods that don't require any input.
class NoParams extends Equatable implements Params {
  const NoParams();

  @override
  List<Object> get props => [];
}
