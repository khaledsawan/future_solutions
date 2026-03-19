import 'package:dartz/dartz.dart';
import 'package:future_solutions/core/usecases/usecase.dart';
import 'package:future_solutions/features/carts/domain/repositories/carts_repository.dart';
import 'package:future_solutions/features/carts/domain/usecases/add_cart_use_case/add_cart_params.dart';
import 'package:injectable/injectable.dart';
import 'package:openapi/openapi.dart';

// GENERATED START - carts - use_case_add_cart_use_case
// This section is auto-generated. Do not edit manually.

@injectable
class AddCartUseCase extends UseCase<Cart?, AddCartParams> {
  final CartsRepository repository;

  AddCartUseCase(this.repository);

  @override
  Future<Either> call(AddCartParams params) =>
      repository.addCart(params: params);
}

// GENERATED END - carts - use_case_add_cart_use_case
