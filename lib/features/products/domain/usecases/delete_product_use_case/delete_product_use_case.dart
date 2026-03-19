import 'package:dartz/dartz.dart';
import 'package:future_solutions/core/usecases/usecase.dart';
import 'package:future_solutions/features/products/domain/repositories/products_repository.dart';
import 'package:future_solutions/features/products/domain/usecases/delete_product_use_case/delete_product_params.dart';
import 'package:injectable/injectable.dart';

// GENERATED START - products - use_case_delete_product_use_case
// This section is auto-generated. Do not edit manually.

@injectable
class DeleteProductUseCase extends UseCase<void, DeleteProductParams> {
  final ProductsRepository repository;

  DeleteProductUseCase(this.repository);

  @override
  Future<Either> call(DeleteProductParams params) =>
      repository.deleteProduct(params: params);
}

// GENERATED END - products - use_case_delete_product_use_case
