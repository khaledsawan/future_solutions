import 'package:built_collection/built_collection.dart';
import 'package:dartz/dartz.dart';
import 'package:future_solutions/features/products/domain/usecases/params.dart';
// ignore: unused_import
import 'package:openapi/openapi.dart';

// GENERATED START - products - repository_interface
// This section is auto-generated. Do not edit manually.

abstract class ProductsRepository {
  Future<Either<dynamic, Product?>> addProduct({
    required AddProductParams params,
  });
  Future<Either<dynamic, void>> deleteProduct({
    required DeleteProductParams params,
  });
  Future<Either<dynamic, BuiltList<Product>?>> getAllProducts();
  Future<Either<dynamic, Product?>> getProductById({
    required GetProductByIdParams params,
  });
  Future<Either<dynamic, Product?>> updateProduct({
    required UpdateProductParams params,
  });
}

// GENERATED END - products - repository_interface
