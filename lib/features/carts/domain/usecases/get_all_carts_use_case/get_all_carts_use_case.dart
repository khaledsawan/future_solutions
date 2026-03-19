import 'package:built_collection/built_collection.dart';
import 'package:dartz/dartz.dart';
import 'package:future_solutions/core/usecases/usecase.dart';
import 'package:future_solutions/features/carts/domain/repositories/carts_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:openapi/openapi.dart';

// GENERATED START - carts - use_case_get_all_carts_use_case
// This section is auto-generated. Do not edit manually.

@injectable
class GetAllCartsUseCase extends UseCase<BuiltList<Cart>?, NoParams> {
  final CartsRepository repository;

  GetAllCartsUseCase(this.repository);

  @override
  Future<Either> call(NoParams params) => repository.getAllCarts();
}

// GENERATED END - carts - use_case_get_all_carts_use_case
