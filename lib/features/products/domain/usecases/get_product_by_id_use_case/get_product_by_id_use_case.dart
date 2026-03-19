import 'package:dartz/dartz.dart';
import 'package:future_solutions/core/usecases/usecase.dart';
import 'package:future_solutions/features/products/domain/repositories/products_repository.dart';
import 'package:future_solutions/features/products/domain/usecases/get_product_by_id_use_case/get_product_by_id_params.dart';
import 'package:injectable/injectable.dart';
import 'package:openapi/openapi.dart';

// GENERATED START - products - use_case_get_product_by_id_use_case
// This section is auto-generated. Do not edit manually.

@injectable
class GetProductByIdUseCase extends UseCase<Product?, GetProductByIdParams> {
  final ProductsRepository repository;

  GetProductByIdUseCase(this.repository);

  @override
  Future<Either> call(GetProductByIdParams params) =>
      repository.getProductById(params: params);
}

// GENERATED END - products - use_case_get_product_by_id_use_case
