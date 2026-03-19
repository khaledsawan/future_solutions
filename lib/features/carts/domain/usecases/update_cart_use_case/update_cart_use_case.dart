import 'package:dartz/dartz.dart';
import 'package:future_solutions/core/usecases/usecase.dart';
import 'package:future_solutions/features/carts/domain/repositories/carts_repository.dart';
import 'package:future_solutions/features/carts/domain/usecases/update_cart_use_case/update_cart_params.dart';
import 'package:injectable/injectable.dart';
import 'package:openapi/openapi.dart';

// GENERATED START - carts - use_case_update_cart_use_case
// This section is auto-generated. Do not edit manually.

@injectable
class UpdateCartUseCase extends UseCase<Cart?, UpdateCartParams> {
  final CartsRepository repository;

  UpdateCartUseCase(this.repository);

  @override
  Future<Either> call(UpdateCartParams params) =>
      repository.updateCart(params: params);
}

// GENERATED END - carts - use_case_update_cart_use_case
