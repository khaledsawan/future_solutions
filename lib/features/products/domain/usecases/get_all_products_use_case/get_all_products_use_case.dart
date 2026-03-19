import 'package:built_collection/built_collection.dart';
import 'package:dartz/dartz.dart';
import 'package:future_solutions/core/usecases/usecase.dart';
import 'package:future_solutions/features/products/domain/repositories/products_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:openapi/openapi.dart';

// GENERATED START - products - use_case_get_all_products_use_case
// This section is auto-generated. Do not edit manually.

@injectable
class GetAllProductsUseCase extends UseCase<BuiltList<Product>?, NoParams> {
  final ProductsRepository repository;

  GetAllProductsUseCase(this.repository);

  @override
  Future<Either> call(NoParams params) => repository.getAllProducts();
}

// GENERATED END - products - use_case_get_all_products_use_case
