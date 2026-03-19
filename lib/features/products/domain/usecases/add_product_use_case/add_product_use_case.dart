import 'package:dartz/dartz.dart';
import 'package:future_solutions/core/usecases/usecase.dart';
import 'package:future_solutions/features/products/domain/repositories/products_repository.dart';
import 'package:future_solutions/features/products/domain/usecases/add_product_use_case/add_product_params.dart';
import 'package:injectable/injectable.dart';
import 'package:openapi/openapi.dart';

// GENERATED START - products - use_case_add_product_use_case
// This section is auto-generated. Do not edit manually.

@injectable
class AddProductUseCase extends UseCase<Product?, AddProductParams> {
  final ProductsRepository repository;

  AddProductUseCase(this.repository);

  @override
  Future<Either> call(AddProductParams params) =>
      repository.addProduct(params: params);
}

// GENERATED END - products - use_case_add_product_use_case
