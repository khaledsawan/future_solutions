// ignore: unused_import
import 'package:built_collection/built_collection.dart';
import 'package:dartz/dartz.dart';
import 'package:future_solutions/core/base/base_repo.dart';
import 'package:future_solutions/core/model/fetch_data_params.dart';
import 'package:future_solutions/core/usecases/usecase.dart';
import 'package:future_solutions/features/carts/data/sources/carts_remote_data_source.dart';
import 'package:future_solutions/features/carts/domain/repositories/carts_repository.dart';
import 'package:future_solutions/features/carts/domain/usecases/params.dart';
import 'package:injectable/injectable.dart';
import 'package:openapi/openapi.dart';

// GENERATED START - carts - repository_implementation
// This section is auto-generated. Do not edit manually.

@LazySingleton(as: CartsRepository)
class CartsRepositoryImp extends BaseRepository implements CartsRepository {
  final CartsRemoteDataSource remoteDataSource;

  CartsRepositoryImp({
    required this.remoteDataSource,
    required super.networkInfo,
  });

  @override
  Future<Either<dynamic, Cart?>> addCart({
    required AddCartParams params,
  }) async {
    return fetchData<Cart?, AddCartParams>(
      params: FetchDataParams(
        getData: (p) async {
          final response = await remoteDataSource.addCart(cart: p.cart);
          return response.data;
        },
        requestParams: params,
      ),
    );
  }

  @override
  Future<Either<dynamic, void>> deleteCart({
    required DeleteCartParams params,
  }) async {
    return fetchData<void, DeleteCartParams>(
      params: FetchDataParams(
        getData: (p) async {
          await remoteDataSource.deleteCart(id: p.id);
          return;
        },
        requestParams: params,
      ),
    );
  }

  @override
  Future<Either<dynamic, BuiltList<Cart>?>> getAllCarts() async {
    return fetchData<BuiltList<Cart>?, NoParams>(
      params: FetchDataParams(
        getData: (p) async {
          final response = await remoteDataSource.getAllCarts();
          return response.data;
        },
        requestParams: const NoParams(),
      ),
    );
  }

  @override
  Future<Either<dynamic, Cart?>> getCartById({
    required GetCartByIdParams params,
  }) async {
    return fetchData<Cart?, GetCartByIdParams>(
      params: FetchDataParams(
        getData: (p) async {
          final response = await remoteDataSource.getCartById(id: p.id);
          return response.data;
        },
        requestParams: params,
      ),
    );
  }

  @override
  Future<Either<dynamic, Cart?>> updateCart({
    required UpdateCartParams params,
  }) async {
    return fetchData<Cart?, UpdateCartParams>(
      params: FetchDataParams(
        getData: (p) async {
          final response = await remoteDataSource.updateCart(
            id: p.id,
            cart: p.cart,
          );
          return response.data;
        },
        requestParams: params,
      ),
    );
  }
}

// GENERATED END - carts - repository_implementation
