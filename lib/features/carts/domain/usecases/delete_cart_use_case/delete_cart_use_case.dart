import 'package:dartz/dartz.dart';
import 'package:future_solutions/core/usecases/usecase.dart';
import 'package:future_solutions/features/carts/domain/repositories/carts_repository.dart';
import 'package:future_solutions/features/carts/domain/usecases/delete_cart_use_case/delete_cart_params.dart';
import 'package:injectable/injectable.dart';

// GENERATED START - carts - use_case_delete_cart_use_case
// This section is auto-generated. Do not edit manually.

@injectable
class DeleteCartUseCase extends UseCase<void, DeleteCartParams> {
  final CartsRepository repository;

  DeleteCartUseCase(this.repository);

  @override
  Future<Either> call(DeleteCartParams params) =>
      repository.deleteCart(params: params);
}

// GENERATED END - carts - use_case_delete_cart_use_case
