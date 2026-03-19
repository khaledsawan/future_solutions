// ignore: unused_import
import 'package:built_collection/built_collection.dart';
import 'package:dartz/dartz.dart';
import 'package:future_solutions/core/base/base_repo.dart';
import 'package:future_solutions/core/model/fetch_data_params.dart';
import 'package:future_solutions/core/usecases/usecase.dart';
import 'package:future_solutions/features/products/data/sources/products_remote_data_source.dart';
import 'package:future_solutions/features/products/domain/repositories/products_repository.dart';
import 'package:future_solutions/features/products/domain/usecases/params.dart';
import 'package:injectable/injectable.dart';
import 'package:openapi/openapi.dart';

// GENERATED START - products - repository_implementation
// This section is auto-generated. Do not edit manually.

@LazySingleton(as: ProductsRepository)
class ProductsRepositoryImp extends BaseRepository
    implements ProductsRepository {
  final ProductsRemoteDataSource remoteDataSource;

  ProductsRepositoryImp({
    required this.remoteDataSource,
    required super.networkInfo,
  });

  @override
  Future<Either<dynamic, Product?>> addProduct({
    required AddProductParams params,
  }) async {
    return fetchData<Product?, AddProductParams>(
      params: FetchDataParams(
        getData: (p) async {
          final response = await remoteDataSource.addProduct(
            product: p.product,
          );
          return response.data;
        },
        requestParams: params,
      ),
    );
  }

  @override
  Future<Either<dynamic, void>> deleteProduct({
    required DeleteProductParams params,
  }) async {
    return fetchData<void, DeleteProductParams>(
      params: FetchDataParams(
        getData: (p) async {
          await remoteDataSource.deleteProduct(id: p.id);
          return;
        },
        requestParams: params,
      ),
    );
  }

  @override
  Future<Either<dynamic, BuiltList<Product>?>> getAllProducts() async {
    return fetchData<BuiltList<Product>?, NoParams>(
      params: FetchDataParams(
        getData: (p) async {
          final response = await remoteDataSource.getAllProducts();
          return response.data;
        },
        requestParams: const NoParams(),
      ),
    );
  }

  @override
  Future<Either<dynamic, Product?>> getProductById({
    required GetProductByIdParams params,
  }) async {
    return fetchData<Product?, GetProductByIdParams>(
      params: FetchDataParams(
        getData: (p) async {
          final response = await remoteDataSource.getProductById(id: p.id);
          return response.data;
        },
        requestParams: params,
      ),
    );
  }

  @override
  Future<Either<dynamic, Product?>> updateProduct({
    required UpdateProductParams params,
  }) async {
    return fetchData<Product?, UpdateProductParams>(
      params: FetchDataParams(
        getData: (p) async {
          final response = await remoteDataSource.updateProduct(
            id: p.id,
            product: p.product,
          );
          return response.data;
        },
        requestParams: params,
      ),
    );
  }
}

// GENERATED END - products - repository_implementation
