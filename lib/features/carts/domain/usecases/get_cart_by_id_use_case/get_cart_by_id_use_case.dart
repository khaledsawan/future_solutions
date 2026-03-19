import 'package:dartz/dartz.dart';
import 'package:future_solutions/core/usecases/usecase.dart';
import 'package:future_solutions/features/carts/domain/repositories/carts_repository.dart';
import 'package:future_solutions/features/carts/domain/usecases/get_cart_by_id_use_case/get_cart_by_id_params.dart';
import 'package:injectable/injectable.dart';
import 'package:openapi/openapi.dart';

// GENERATED START - carts - use_case_get_cart_by_id_use_case
// This section is auto-generated. Do not edit manually.

@injectable
class GetCartByIdUseCase extends UseCase<Cart?, GetCartByIdParams> {
  final CartsRepository repository;

  GetCartByIdUseCase(this.repository);

  @override
  Future<Either> call(GetCartByIdParams params) =>
      repository.getCartById(params: params);
}

// GENERATED END - carts - use_case_get_cart_by_id_use_case
