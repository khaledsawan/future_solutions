import 'package:dartz/dartz.dart';
import 'package:future_solutions/core/usecases/usecase.dart';
import 'package:future_solutions/features/products/domain/repositories/products_repository.dart';
import 'package:future_solutions/features/products/domain/usecases/update_product_use_case/update_product_params.dart';
import 'package:injectable/injectable.dart';
import 'package:openapi/openapi.dart';

// GENERATED START - products - use_case_update_product_use_case
// This section is auto-generated. Do not edit manually.

@injectable
class UpdateProductUseCase extends UseCase<Product?, UpdateProductParams> {
  final ProductsRepository repository;

  UpdateProductUseCase(this.repository);

  @override
  Future<Either> call(UpdateProductParams params) =>
      repository.updateProduct(params: params);
}

// GENERATED END - products - use_case_update_product_use_case
